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
    input         PCWrite, RegWrite, WriteData, //�Ĵ����Ѷ�д����
    input         MemRead, MemWrite, //�ڴ��д
    
    input  [1:0]  PCSrc,
    input         MemtoReg, RegDst,
    input  [1:0]  ALUSrcA, ALUSrcB,
    input  [3:0]  ALUCtrl,

    // ��������Ƶ�Ԫ
    output [31:0] instruct, //�����ǰָ��
    output zero
    
);

wire [31:0] pc_next_in, pc_out;
wire [4:0] read_addr1, read_addr2;
wire [31:0] read_data1, read_data2, write_data;
wire [4:0] op1, op2; //ALU������
wire [31:0] ALU_result;
wire ALUCtrl, zero;

wire [31:0] branch_addr, jump_addr, rs, pc_current, pc_adder, pc_plus_4; //pc��·ѡ����
wire [1:0] PCSrcCtrl, ALUSrcBCtrl;
reg [31:0] pc_next;

 //ʵ����ģ��
pc_acc PC_accumulator ( //pc�Ĵ���������˳��ִ��ʱ��һ��pc
   .pc_current(pc_out),
   .pc_plus_4(pc_plus_4)
);

 
pc PC ( //pc�Ĵ���������pc
   .clk(clk),
   .PCWrite(PCWrite),
   .pc_next_in(pc_next),
   .pc_out(pc_out)
);


pcSrc_mux PCSrc_mux(
    .pc_plus_4(pc_plus_4),
    .branch_addr(branch_addr),
    .jump_addr(jump_addr),
    .rs(rs),
    .PCSrcCtrl(PCSrc), //���Ƶ�Ԫ�����Ŀ����ź������뵽mux����ΪPCSrcCtrl
    .pc_next(pc_next) //�����һ��pc���ͻ�pc�Ĵ���
 );
 //branch_addr = pc_plus_4 + 
 


reg IRRead, //��ȡָ��Ŀ����ź�
[31:0] instruct, //����ֵ�32λָ�ָ���ֺ�������������
wire [5:0] opcode,  // ������
    output reg [4:0] rs,      // Դ�Ĵ���1
    output reg [4:0] rt,      // Դ�Ĵ���2 / Ŀ�ļĴ���
    output reg [4:0] rd,      // Ŀ�ļĴ�����R �ͣ�
    output reg [4:0] shamt,   // ��λ��
    output reg [5:0] func,   // �����루R �ͣ�
    output reg [15:0] imm,    // ��������I �ͣ�
    output reg [25:0] addr    // ��ת��ַ��J �ͣ� 

instruct_reg IR( //IR�ֽ�ָ��Ϊ����ͬ�ֶ�
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

reg [15:0] in_data, out_data;
reg ExCtrl;

//���Ϻ�0��չ
ext_unit ext_unit(
    .in_data(in_data),
    .ExCtrl(ExCtrl),
    .out_data(out_data)
);
//input [15:0] in_data,
   // input ExtCtrl, //��չ��ʽ�Ŀ����ź�
    //output wire [31:0] out_data
    
    
   
//assign pcSrc_mux.pc_next = pc_next;  //muxѡ��pcnext
//assign pc.pc_next_in = pcSrc_mux.pc_next; //������һ��pc

// �Ĵ�����
reg_file register_file(
        .clk(clk),
        .rst(rst),
        .read_addr1(read_addr1),
        .read_addr2(read_addr1),
        .RegWrite(RegWrite),
        .read_data1(read_data1),
        .read_data2(read_data2),       
        .write_data(write_data)
);

wire [4:0] out_data1, out_data2, read_data1, read_data2;
// ��ʱ�Ĵ����洢��ȡ������
tmp_reg reg_A(
     .clk(clk),
     .rst(rst),
     .in_data(read_data1),
     .out_data(out_data1)
);

if read
tmp_reg reg_B(
     .clk(clk),
     .rst(rst),
     .in_data(read_data2),
     .out_data(out_data2)
);

// ALU
ALU alu(
    .a(op1),
    .b(op2),
    .ALUCtrl(ALUCtrl),
    .result(ALU_result),
    .zero(zero)
);


endmodule