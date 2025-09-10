`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/08/28 09:05:16
// Design Name: 
// Module Name: data_path
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module data_path(
    input clk, rst,
    // ��������ź�
    input PCWrite, RegWrite, pc_acc_en,//�Ĵ����Ѷ�д����
    input IRRead, ALUWrite,
    input DataWrite, DataRead, DRWrite,//�ڴ��д
    
    input  [1:0]  PCSrcCtrl,
    input  [1:0]  RegDst,
    input  Mem2Reg, ExtCtrl,
    input  [1:0]  ALUSrcBCtrl,
    input  [3:0]  ALUCtrl,

    // ��������Ƶ�Ԫ
    output [31:0] instruct, pc_out, //�����ǰָ��͵�ǰpc
    output zero,
    output [5:0] opcode, func, //��Ϊ���Ƶ�Ԫ��Ҫָ���ֶ���Ϣ
    output [31:0] reg1_val, reg2_val, reg3_val, //̽��ͨ�üĴ���������
    output [31:0] ALU_result,
    output [31:0] op1, op2, ALUOut, read_data2, write_data,
    output [25:0] addr
);

wire [31:0] pc_next_in;
//wire [4:0] read_addr1, read_addr2;
//wire [31:0] write_data;
//wire [31:0] op1, op2; //ALU������
//wire [31:0] ALU_result;
//wire ALUCtrl, zero;

wire [31:0] in_data, out_data;
wire [31:0] branch_addr, jump_addr, pc_current, pc_adder, pc_plus_4; //pc��·ѡ����
//wire [1:0] PCSrcCtrl, ALUSrcBCtrl;
wire [31:0] pc_next;

 //ʵ����ģ��
PC_accumulator pc_acc( //pc�Ĵ���������˳��ִ��ʱ��һ��pc
   .pc_current(pc_out),
   .pc_acc_en(pc_acc_en),
   .pc_plus_4(pc_plus_4)
   
);

PC pc( //pc�Ĵ���������pc
   .clk(clk),
   .rst(rst),
   .PCWrite(PCWrite),
   .pc_next_in(pc_next),
   .pc_out(pc_out)
);

wire [4:0] rs;    // Դ�Ĵ���1

 //branch_addr = pc_plus_4 + 
 
//reg IRRead; //��ȡָ��Ŀ����ź�
//reg [31:0] instruct; //����ֵ�32λָ�ָ���ֺ�������������
//wire [5:0] opcode;  // ������
wire [4:0] rt;      // Դ�Ĵ���2 / Ŀ�ļĴ���
wire [4:0] rd;     // Ŀ�ļĴ�����R �ͣ�
wire [4:0] shamt;  // ��λ��
//wire [5:0] func;   // �����루R �ͣ�
wire [15:0] imm;    // ��������I �ͣ�
//wire [25:0] addr;    // ��ת��ַ��J �ͣ� 
reg [4:0] read_addr1;    // Դ�Ĵ���1
reg [4:0] read_addr2;

instruct_mem IM( //ʵ����ָ��洢��
   .instruct_addr(pc_out),
   .instruct_data(instruct)
);

instruct_reg IR( //IR�ֽ�ָ��Ϊ����ͬ�ֶ�
   .clk(clk),
   .rst(rst),
   .IRRead(IRRead),
   .instruct(instruct),
   .opcode(opcode),
   .rs(rs),
   .rt(rt),
   .rd(rd),
   .shamt(shamt),
   .func(func),
   .imm(imm),
   .addr(addr)
);


//reg ExCtrl;
//wire [31:0] op1, op2, read_data1, read_data2;
wire [31:0] read_data1;

//imm�ֶη��Ż�0��չ
ext_unit ext_unit(
    .in_data(imm),
    .ExtCtrl(ExtCtrl),
    .out_data(out_data)
);
//wire [31:0] branch_addr, jump_addr; //��֧����תĿ���ַ

assign branch_addr = pc_plus_4 + (out_data << 2); //beq,bneָ��
assign jump_addr = {pc_plus_4[31:28], addr, 2'b00}; //jal,jָ��

PCSrc_mux pcSrc_mux (
    .pc_plus_4(pc_plus_4),
    .branch_addr(branch_addr),
    .jump_addr(jump_addr),
    .rs(op1),
    .PCSrcCtrl(PCSrcCtrl), //���Ƶ�Ԫ�����Ŀ����ź������뵽mux����ΪPCSrcCtrl
    .pc_next(pc_next) //�����һ��pc���ͻ�pc�Ĵ���
 );

//input [15:0] in_data,
   // input ExtCtrl, //��չ��ʽ�Ŀ����ź�
    //output wire [31:0] out_data
    
    
   
//assign pcSrc_mux.pc_next = pc_next;  //muxѡ��pcnext
//assign pc.pc_next_in = pcSrc_mux.pc_next; //������һ��pc

// �Ĵ�����
//assign read_addr1 = 0;
//assign read_addr2 = 0; //��ַĬ����0
/*always @* begin
    case (opcode)
        6'b000000: begin 
            if (rs == 5'b00000) begin //R��ָ��2����ַ
                read_addr1 = rs;
                read_addr2 = rt; 
            end else begin //srl,sra,sll
                read_addr1 = rs; //
                op2 = shamt; //�ڶ�����������shamt
                //assign read_addr2 = rt; 
            end
        end
        6'b000010: begin
            op1 = address;
            op2 = 2;
        
            
        default: begin //I��ָ��
            assign read_addr1 = rs;
            assign op2 = out_data; //�ڶ�������������չ���imm
        end
     endcase
end*/

always @* begin
    case (opcode)
        6'b000000: begin // R��
             if (func == 6'b000000 || func == 6'b000010 || func == 6'b000011 || //sll,srl,sra,sllv,srlv,srav
                 func == 6'b000100 || func == 6'b000110 || func == 6'b000111) begin
                 read_addr1 = rt;
                 read_addr2 = rs;
             end else begin //���������һ����ַ��rs
                read_addr1 = rs;
                read_addr2 = rt;
             end
            /*case (func)
                6'000000,
                6'000010,
                6'000011,
                6'000100,
                6'000110,
                6'000111: begin
                    read_addr1 = rt;
                    read_addr2 = rs;
                end
                default: begin //���������һ����ַ��rs
                    read_addr1 = rs;
                    read_addr2 = rt;
                end
            endcase*/
        end
        default: begin // I�ͣ�����beq,bne
            read_addr1 = rs;
            read_addr2 = rt; // �Ĵ�������Ȼ�� rt��������ܲ���
        end
    endcase
end
   
wire [31:0] data_wb; //��д�ؼĴ��������ݣ�����ALU��DM�����ڴ�
wire [4:0] write_addr;

//assign read_addr2 = rt;
register_file reg_file (
        .clk(clk),
        .rst(rst),
        .read_addr1(read_addr1),
        .read_addr2(read_addr2),
        .write_addr(write_addr),
        .write_data(data_wb),
        .RegWrite(RegWrite),
        .read_data1(read_data1),
        .read_data2(read_data2),
        .reg1_val(reg1_val),
        .reg2_val(reg2_val), 
        .reg3_val(reg3_val)       
         //Mem2Reg_mux�������������
);


// ��ʱ�Ĵ����洢��ȡ�����ݣ�Ȼ�����muxѡ��
wire [31:0] regB_val;
tmp_reg reg_A(
     .clk(clk),
     .rst(rst),
     .in_data(read_data1),
     .out_data(op1)
);

tmp_reg reg_B(
     .clk(clk),
     .rst(rst),
     .in_data(read_data2),
     .out_data(regB_val)
);

//ʵ������·ѡ����
ALUSrcB_mux alu_srcb_mux(
    .regB(regB_val),         // ��ʱ�Ĵ���B���
    .shamt(shamt),
    .ext_data(out_data), // ��չ���������
    .ALUSrcBCtrl(ALUSrcBCtrl),
    .ALU_in_2(op2)       // ALU �ڶ���������
);

// ALU
ALU alu(
    .a(op1),
    .b(op2),
    .ALUCtrl(ALUCtrl),
    .result(ALU_result),
    .zero_flag(zero)
);

wire [31:0] alu_result_final;
wire [31:0] lui_result;
//wire [31:0] ALUOut; //��ģ����������wire

assign lui_result = {imm, 16'b0}; //��ʱ�洢lui���
assign alu_result_final = (opcode == 6'b001111) ? lui_result : ALU_result; //�Ƿ���lui

ALUOut aluOut( 
    .ALUResult(alu_result_final), //�������ս��
    .clk(clk),
    .rst(rst),
    .ALUWrite(ALUWrite),
    .ALUOut(ALUOut)
);
//luiָ�� ���⴦��
//wire [31:0] lui_addr; 
//assign lui_addr = {imm, 16'b0};
/*ways @* begin
    if (opcode == 6'b001111) begin
        ALUOut = {imm, 16'b0};
    end   
end*/

wire [31:0] read_data_addr, write_data_addr; //��ȡ��д�����ݵĵ�ַ
//wire [31:0] write_data;
wire [31:0] read_data;
//wire [31:0] DataWrite, DataRead;
//reg [31:0] read_data_addr, write_data_addr;
//���ݴ洢��DM
data_mem DM(
    .clk(clk),
    .read_addr(ALUOut), //�����ݵ�ַ
    .write_addr(ALUOut), //д���ݵ�ַ����ALUOut
    .write_data(read_data2), //д���ڴ�����ݣ���rt���ݣ�read_data2
    .read_data(read_data), 
    .DataWrite(DataWrite), //��ȡ��д������ź�
    .DataRead(DataRead)
);
//wire Mem2Reg; //�����ź�

//slt,sltu(R
/*if (opcode = 6'b000000 && (func = 6'b101010 || func = 6'b101011) && ALUOut < 0) begin
    ALUOut = 1; //д�ؼĴ�������1
end
if (opcode = 6'b000000 && (func = 6'b101010 || func = 6'b101011) && ALUOut >= 0) begin
    ALUOut = 0; //д�ؼĴ�������0
end

//slti,sltiu(I)
if (opcode == 6'b001010 && ALUOut < 0) begin
    assign ALUOut = 1; //д�ؼĴ�������1
end
if (opcode = 6'b001011 && ALUOut >= 0) begin
    ALUOut = 0; //д�ؼĴ�������1
end*/

Mem2Reg_mux mem2reg_mux( //д�ص���������ALU�����ڴ�
    .ALUOut(ALUOut),
    .MDR_data(write_data),
    .Mem2Reg(Mem2Reg),
    .write_data(data_wb)
);

data_reg DR(
    .clk(clk),
    .rst(rst),
    .DRWrite(DRWrite),
    .in_data(read_data), //���ڴ���ص�����
    .out_data(write_data) //���뵽mux
);




//case (opcode)
   // 6b'100011: write_addr = read_addr2; //д��rt
        
RegDst_mux RegDst_mux(  //ѡ��д��Ĵ����ѵĵ�ַ
    .rd(rd),
    .rt(rt),
    .RegDst(RegDst),
    .write_addr(write_addr) //д���ڴ�����ݵĵ�ַ����rt
);


endmodule