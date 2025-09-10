`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/09/04 08:31:03
// Design Name: 
// Module Name: top_cpu
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


module top_cpu(
    input clk, rst,    //����û��������۲�pc,aluout����
    output [31:0] pc_out, //�����һ��ָ���pc
    output [31:0] instruct,
    output [31:0] reg1_val, reg2_val, reg3_val, //̽��Ĵ���������
    output [31:0] ALU_result, op1, op2, ALUOut, write_data, read_data2,
    output [5:0] opcode, func,
    output [1:0] RegDst, PCSrcCtrl,
    output IRRead, PCWrite, ALUWrite, RegWrite, Mem2Reg, DataRead, DataWrite,
    output zero,
    output [25:0] addr
);

//wire PCWrite, RegWrite;//�Ĵ����Ѷ�д����
//wire RegWrite;//�Ĵ����Ѷ�д����
//wire ALUWrite;
//wire DataWrite, DataRead, 
wire DRWrite;//�ڴ��д
//wire [1:0]  PCSrcCtrl;
//wire [1:0]  RegDst;
//wire Mem2Reg, ExtCtrl;
wire ExtCtrl;
wire [1:0]  ALUSrcBCtrl;
wire [3:0]  ALUCtrl;
wire pc_acc_en; //0��־

// ʵ��������ͨ·�������ǰָ��͵�ǰpc
data_path dp(
    .clk(clk),
    .rst(rst), // ���ʱ�Ӻ͸�λ�˿�
    .PCWrite(PCWrite),
    .pc_acc_en(pc_acc_en),
    .RegWrite(RegWrite),
    .IRRead(IRRead),
    .ALUWrite(ALUWrite),
    .DataWrite(DataWrite),
    .DataRead(DataRead),
    .DRWrite(DRWrite),
    .PCSrcCtrl(PCSrcCtrl),
    .RegDst(RegDst),
    .Mem2Reg(Mem2Reg),
    .ExtCtrl(ExtCtrl),
    .ALUSrcBCtrl(ALUSrcBCtrl),
    .ALUCtrl(ALUCtrl),
    .instruct(instruct),
    .pc_out(pc_out),
    .zero(zero),
    .opcode(opcode),
    .func(func),
    .reg1_val(reg1_val), 
    .reg2_val(reg2_val), 
    .reg3_val(reg3_val), //̽��Ĵ���������
    .ALU_result(ALU_result),
    .op1(op1),
    .op2(op2),
    .ALUOut(ALUOut),
    .read_data2(read_data2),
    .write_data(write_data),
    .addr(addr)
);

//assign pc_out = dp.pc_out; //��������˿�

//ʵ�������Ƶ�Ԫ����������ź�
ctrl_unit ctrl_unit(
    .clk(clk),
    .rst(rst), // ���ʱ�Ӻ͸�λ�˿�
    .opcode(instruct[31:26]),
    .func(instruct[25:20]),
    .zero(zero),
    .PCWrite(PCWrite),
    .pc_acc_en(pc_acc_en),
    .RegWrite(RegWrite),
    .IRRead(IRRead),
    .ALUWrite(ALUWrite),
    .DataWrite(DataWrite),
    .DataRead(DataRead),
    .DRWrite(DRWrite),
    .PCSrcCtrl(PCSrcCtrl),
    .RegDst(RegDst),
    .Mem2Reg(Mem2Reg),
    .ExtCtrl(ExtCtrl),
    .ALUSrcBCtrl(ALUSrcBCtrl),
    .ALUCtrl(ALUCtrl)
);

endmodule
