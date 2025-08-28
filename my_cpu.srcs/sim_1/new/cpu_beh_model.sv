// cpu_beh_model.sv
// Minisys CPU 高层次行为模型 (SystemVerilog)

module cpu_beh_model();

  // --- 1. 定义 CPU 状态 ---
  // 程序计数器 (Program Counter)
  logic [31:0] PC; 
  
  // 通用寄存器 (General Purpose Registers), 32个32位寄存器
  // regfile[0] 总是0
  logic [31:0] regfile [0:31]; 
  
  // 统一内存 (指令和数据都在这里)，简化处理
  // 1KB 内存，按字 (4字节) 寻址，所以是 1024/4 = 256 个字
  parameter MEM_SIZE_WORDS = 256; // 256 words = 1KB
  logic [31:0] memory [0:MEM_SIZE_WORDS-1]; 

  // --- 2. 模拟时钟和复位 (为了仿真需要) ---
  logic clk;
  logic rst_n; // Active-low reset

  // 初始化时钟和复位
  initial begin
    clk = 0;
    rst_n = 0; // Assert reset
    #10 rst_n = 1; // Deassert reset after 10 time units
  end

  // 时钟生成
  always #5 clk = ~clk; // 10ns period, 100MHz clock

  // --- 3. 初始化 CPU 状态 ---
  initial begin
    PC = 32'h0000_0000;
    for (int i = 0; i < 32; i += 1) begin
      regfile[i] = 32'h0000_0000;
    end
    regfile[0] = 32'h0000_0000; // 确保R0为0

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

  // --- 4. 模拟内存加载 (加载指令到内存) ---
  // 这部分通常由测试平台完成，这里为了自包含直接在模块内模拟
  initial begin
    // 示例程序 (与Python示例相同)
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
    memory[5] = 32'h08000000; // J 0 (简单的终止，或者无限循环)
  end

  // --- 5. CPU 模拟器核心 (行为级描述) ---
  // 使用一个 always_ff 块来模拟时序逻辑，即PC和寄存器在时钟上升沿更新
  // 使用一个 always_comb 块来模拟组合逻辑，即指令解析和执行
  
  logic [31:0] current_instruction_word;
  logic [5:0]  opcode;
  logic [4:0]  rs, rt, rd, shamt;
  logic [5:0]  func;
  logic [15:0] immediate_raw;
  logic [31:0] immediate_ext; // 符号扩展后的立即数
  logic [25:0] jump_target_raw;
  logic [31:0] jump_target_addr;

  // 组合逻辑部分：指令解析和计算结果
  // 这是一个行为级的描述，不是真实的单周期或多周期逻辑
  // 它的目标是"功能"而非"结构"
  always_comb begin
    // 1. Fetch Instruction (取指令) - 模拟从内存读
    if (PC / 4 >= MEM_SIZE_WORDS) begin
      current_instruction_word = 32'hDEADBEEF; // 表示非法访问
    end else begin
      current_instruction_word = memory[PC / 4];
    end

    // 2. Decode Instruction (译码)
    opcode = current_instruction_word[31:26];
    rs = current_instruction_word[25:21];
    rt = current_instruction_word[20:16];
    rd = current_instruction_word[15:11];
    shamt = current_instruction_word[10:6];
    func = current_instruction_word[5:0];
    immediate_raw = current_instruction_word[15:0];
    jump_target_raw = current_instruction_word[25:0];

    // 符号扩展立即数 (行为级直接处理)
    immediate_ext = {{16{immediate_raw[15]}}, immediate_raw}; // SystemVerilog 符号扩展语法

    // JUMP地址计算 (行为级直接处理)
    // MIPS J型指令是PC的31:28位 + (target << 2)
    jump_target_addr = {PC[31:28], jump_target_raw, 2'b00}; 
  end

  // 时序逻辑部分：PC和寄存器的更新
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
      
      logic [31:0] next_PC = PC + 4; // 默认PC更新
      logic [31:0] alu_result;
      logic [31:0] mem_read_data;
      logic write_reg_en = 0;
      logic [4:0] write_reg_addr = 0;
      logic [31:0] write_reg_data = 0;

      // 行为级执行指令
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
            $stop; // 仿真停止
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
          next_PC = jump_target_addr; // 直接更新PC
          $display("  J 0x%h -> PC = 0x%h", jump_target_raw, next_PC);
        end
        default: begin
          $display("  UNKNOWN instruction opcode 0x%h at 0x%h. Halting simulation.", opcode, PC);
          $stop; // 仿真停止
        end
      endcase

      // 寄存器写回
      if (write_reg_en && write_reg_addr != 0) begin // R0 不能被写入
        regfile[write_reg_addr] = write_reg_data;
      end else if (write_reg_en && write_reg_addr == 0) begin
        $display("  Warning: Attempted to write to R0. Write ignored.");
      end

      // 更新PC (J指令已在上面更新，这里只处理非J指令的PC+4)
      if (opcode != 6'h02) begin // Not a J instruction
        PC = next_PC;
      end else begin
        PC = next_PC; // J指令已计算好新的PC
      end

      // 打印当前CPU状态
      $display("  Current Registers:");
      for (int i = 0; i < 32; i += 4) begin
          $display("    R%02d: %h  R%02d: %h  R%02d: %h  R%02d: %h", 
                   i, regfile[i], i+1, regfile[i+1], i+2, regfile[i+2], i+3, regfile[i+3]);
      end
      $display("  Memory Word 0x00: %h", memory[0]);

      // 仿真终止条件
      if (cycle_count >= 10) begin // 限制最大执行周期数
        $display("\n--- Max cycles reached. Halting simulation. ---");
        $finish;
      end
    end // else (!rst_n)
  end // always_ff

endmodule