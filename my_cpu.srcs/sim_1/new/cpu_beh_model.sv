// cpu_beh_model.sv
// Minisys CPU �߲����Ϊģ�� (SystemVerilog)

module cpu_beh_model();

  // --- 1. ���� CPU ״̬ ---
  // ��������� (Program Counter)
  logic [31:0] PC; 
  
  // ͨ�üĴ��� (General Purpose Registers), 32��32λ�Ĵ���
  // regfile[0] ����0
  logic [31:0] regfile [0:31]; 
  
  // ͳһ�ڴ� (ָ������ݶ�������)���򻯴���
  // 1KB �ڴ棬���� (4�ֽ�) Ѱַ�������� 1024/4 = 256 ����
  parameter MEM_SIZE_WORDS = 256; // 256 words = 1KB
  logic [31:0] memory [0:MEM_SIZE_WORDS-1]; 

  // --- 2. ģ��ʱ�Ӻ͸�λ (Ϊ�˷�����Ҫ) ---
  logic clk;
  logic rst_n; // Active-low reset

  // ��ʼ��ʱ�Ӻ͸�λ
  initial begin
    clk = 0;
    rst_n = 0; // Assert reset
    #10 rst_n = 1; // Deassert reset after 10 time units
  end

  // ʱ������
  always #5 clk = ~clk; // 10ns period, 100MHz clock

  // --- 3. ��ʼ�� CPU ״̬ ---
  initial begin
    PC = 32'h0000_0000;
    for (int i = 0; i < 32; i += 1) begin
      regfile[i] = 32'h0000_0000;
    end
    regfile[0] = 32'h0000_0000; // ȷ��R0Ϊ0

    for (int i = 0; i < MEM_SIZE_WORDS; i++) begin
      memory[i] = 32'h0000_0000;
    end

    $display("--- Initial CPU State ---");
    $display("PC: %h", PC);
    $display("Registers:");
    for (int i = 0; i < 32; i++) begin
        $display("  R%02d: %h", i, regfile[i]);
    end
    $display("Memory (first 4 words):");
    for (int i = 0; i < 4; i++) begin
        $display("  Mem[0x%h]: %h", i*4, memory[i]);
    end
    $display("-------------------------\n");
  end

  // --- 4. ģ���ڴ���� (����ָ��ڴ�) ---
  // �ⲿ��ͨ���ɲ���ƽ̨��ɣ�����Ϊ���԰���ֱ����ģ����ģ��
  initial begin
    // ʾ������ (��Pythonʾ����ͬ)
    // ADDI R1, R0, 10      => 0x2021000A
    // ADDI R2, R0, 20      => 0x20420014
    // ADD R3, R1, R2       => 0x00221820
    // SW R3, 0(R0)         => 0xAC030000
    // LW R4, 0(R0)         => 0x8C040000
    // J 0                  => 0x08000000

    memory[0] = 32'h2021000A; // ADDI R1, R0, 10
    memory[1] = 32'h20420014; // ADDI R2, R0, 20
    memory[2] = 32'h00221820; // ADD R3, R1, R2
    memory[3] = 32'hAC030000; // SW R3, 0(R0) (Memory[0] = R3)
    memory[4] = 32'h8C040000; // LW R4, 0(R0) (R4 = Memory[0])
    memory[5] = 32'h08000000; // J 0 (�򵥵���ֹ����������ѭ��)
  end

  // --- 5. CPU ģ�������� (��Ϊ������) ---
  // ʹ��һ�� always_ff ����ģ��ʱ���߼�����PC�ͼĴ�����ʱ�������ظ���
  // ʹ��һ�� always_comb ����ģ������߼�����ָ�������ִ��
  
  logic [31:0] current_instruction_word;
  logic [5:0]  opcode;
  logic [4:0]  rs, rt, rd, shamt;
  logic [5:0]  func;
  logic [15:0] immediate_raw;
  logic [31:0] immediate_ext; // ������չ���������
  logic [25:0] jump_target_raw;
  logic [31:0] jump_target_addr;

  // ����߼����֣�ָ������ͼ�����
  // ����һ����Ϊ����������������ʵ�ĵ����ڻ�������߼�
  // ����Ŀ����"����"����"�ṹ"
  always_comb begin
    // 1. Fetch Instruction (ȡָ��) - ģ����ڴ��
    if (PC / 4 >= MEM_SIZE_WORDS) begin
      current_instruction_word = 32'hDEADBEEF; // ��ʾ�Ƿ�����
    end else begin
      current_instruction_word = memory[PC / 4];
    end

    // 2. Decode Instruction (����)
    opcode = current_instruction_word[31:26];
    rs = current_instruction_word[25:21];
    rt = current_instruction_word[20:16];
    rd = current_instruction_word[15:11];
    shamt = current_instruction_word[10:6];
    func = current_instruction_word[5:0];
    immediate_raw = current_instruction_word[15:0];
    jump_target_raw = current_instruction_word[25:0];

    // ������չ������ (��Ϊ��ֱ�Ӵ���)
    immediate_ext = {{16{immediate_raw[15]}}, immediate_raw}; // SystemVerilog ������չ�﷨

    // JUMP��ַ���� (��Ϊ��ֱ�Ӵ���)
    // MIPS J��ָ����PC��31:28λ + (target << 2)
    jump_target_addr = {PC[31:28], jump_target_raw, 2'b00}; 
  end

  // ʱ���߼����֣�PC�ͼĴ����ĸ���
  integer cycle_count = 0;
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin // Reset
      PC = 32'h0000_0000;
      for (int i = 0; i < 32; i++) begin
        regfile[i] = 32'h0000_0000;
      end
      regfile[0] = 32'h0000_0000;
      cycle_count = 0;
      $display("--- CPU Reset ---");
    end else begin
      cycle_count++;
      $display("\n--- Cycle %0d (PC: 0x%h, Instr: 0x%h) ---", cycle_count, PC, current_instruction_word);
      
      logic [31:0] next_PC = PC + 4; // Ĭ��PC����
      logic [31:0] alu_result;
      logic [31:0] mem_read_data;
      logic write_reg_en = 0;
      logic [4:0] write_reg_addr = 0;
      logic [31:0] write_reg_data = 0;

      // ��Ϊ��ִ��ָ��
      case (opcode)
        6'h00: begin // R-type instructions (ADD, SUB)
          case (func)
            6'h20: begin // ADD
              alu_result = regfile[rs] + regfile[rt];
              write_reg_en = 1;
              write_reg_addr = rd;
              write_reg_data = alu_result;
              $display("  ADD R%0d, R%0d, R%0d -> R%0d = %h", rd, rs, rt, rd, alu_result);
            end
            6'h22: begin // SUB
              alu_result = regfile[rs] - regfile[rt];
              write_reg_en = 1;
              write_reg_addr = rd;
              write_reg_data = alu_result;
              $display("  SUB R%0d, R%0d, R%0d -> R%0d = %h", rd, rs, rt, rd, alu_result);
            end
            default: $display("  UNKNOWN R-type func 0x%h", func);
          endcase
        end
        6'h08: begin // I-type: ADDI
          alu_result = regfile[rs] + immediate_ext;
          write_reg_en = 1;
          write_reg_addr = rt;
          write_reg_data = alu_result;
          $display("  ADDI R%0d, R%0d, %0d -> R%0d = %h", rt, rs, immediate_ext, rt, alu_result);
        end
        6'h23: begin // I-type: LW
          logic [31:0] mem_addr = regfile[rs] + immediate_ext;
          if (mem_addr % 4 != 0) begin
            $display("  Error: LW unaligned access at 0x%h", mem_addr);
            $stop; // ����ֹͣ
          end
          if ((mem_addr / 4) >= MEM_SIZE_WORDS || (mem_addr / 4) < 0) begin
            $display("  Error: LW out of bounds access at 0x%h", mem_addr);
            $stop;
          end
          mem_read_data = memory[mem_addr / 4];
          write_reg_en = 1;
          write_reg_addr = rt;
          write_reg_data = mem_read_data;
          $display("  LW R%0d, %0d(R%0d) -> Mem[0x%h] = %h, R%0d = %h", rt, immediate_ext, rs, mem_addr, mem_read_data, rt, mem_read_data);
        end
        6'h2B: begin // I-type: SW
          logic [31:0] mem_addr = regfile[rs] + immediate_ext;
          if (mem_addr % 4 != 0) begin
            $display("  Error: SW unaligned access at 0x%h", mem_addr);
            $stop;
          end
          if ((mem_addr / 4) >= MEM_SIZE_WORDS || (mem_addr / 4) < 0) begin
            $display("  Error: SW out of bounds access at 0x%h", mem_addr);
            $stop;
          end
          memory[mem_addr / 4] = regfile[rt];
          $display("  SW R%0d, %0d(R%0d) -> Mem[0x%h] = %h", rt, immediate_ext, rs, mem_addr, regfile[rt]);
        end
        6'h02: begin // J-type: J
          next_PC = jump_target_addr; // ֱ�Ӹ���PC
          $display("  J 0x%h -> PC = 0x%h", jump_target_raw, next_PC);
        end
        default: begin
          $display("  UNKNOWN instruction opcode 0x%h at 0x%h. Halting simulation.", opcode, PC);
          $stop; // ����ֹͣ
        end
      endcase

      // �Ĵ���д��
      if (write_reg_en && write_reg_addr != 0) begin // R0 ���ܱ�д��
        regfile[write_reg_addr] = write_reg_data;
      end else if (write_reg_en && write_reg_addr == 0) begin
        $display("  Warning: Attempted to write to R0. Write ignored.");
      end

      // ����PC (Jָ������������£�����ֻ�����Jָ���PC+4)
      if (opcode != 6'h02) begin // Not a J instruction
        PC = next_PC;
      end else begin
        PC = next_PC; // Jָ���Ѽ�����µ�PC
      end

      // ��ӡ��ǰCPU״̬
      $display("  Current Registers:");
      for (int i = 0; i < 32; i += 4) begin
          $display("    R%02d: %h  R%02d: %h  R%02d: %h  R%02d: %h", 
                   i, regfile[i], i+1, regfile[i+1], i+2, regfile[i+2], i+3, regfile[i+3]);
      end
      $display("  Memory Word 0x00: %h", memory[0]);

      // ������ֹ����
      if (cycle_count >= 10) begin // �������ִ��������
        $display("\n--- Max cycles reached. Halting simulation. ---");
        $finish;
      end
    end // else (!rst_n)
  end // always_ff

endmodule