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
    // 输入控制信号
    input         PCWrite, RegWrite, WriteData, //寄存器堆读写数据
    input         MemRead, MemWrite, //内存读写
    
    input  [1:0]  PCSrc,
    input         MemtoReg, RegDst,
    input  [1:0]  ALUSrcA, ALUSrcB,
    input  [3:0]  ALUCtrl,

    // 输出给控制单元
    output [31:0] instruct, //输出当前指令
    output zero
    
);

wire [31:0] pc_next_in, pc_out;
wire [4:0] read_addr1, read_addr2;
wire [31:0] read_data1, read_data2, write_data;
wire [4:0] op1, op2; //ALU运算数
wire [31:0] ALU_result;
wire ALUCtrl, zero;

wire [31:0] branch_addr, jump_addr, rs, pc_current, pc_adder, pc_plus_4; //pc多路选择器
wire [1:0] PCSrcCtrl, ALUSrcBCtrl;
reg [31:0] pc_next;

 //实例化模块
pc_acc PC_accumulator ( //pc寄存器，计算顺序执行时下一个pc
   .pc_current(pc_out),
   .pc_plus_4(pc_plus_4)
);

 
pc PC ( //pc寄存器，锁存pc
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
    .PCSrcCtrl(PCSrc), //控制单元发出的控制信号列输入到mux，成为PCSrcCtrl
    .pc_next(pc_next) //输出下一个pc，送回pc寄存器
 );
 //branch_addr = pc_plus_4 + 
 


reg IRRead, //读取指令的控制信号
[31:0] instruct, //待拆分的32位指令，指令拆分后会进入主控制器
wire [5:0] opcode,  // 操作码
    output reg [4:0] rs,      // 源寄存器1
    output reg [4:0] rt,      // 源寄存器2 / 目的寄存器
    output reg [4:0] rd,      // 目的寄存器（R 型）
    output reg [4:0] shamt,   // 移位量
    output reg [5:0] func,   // 功能码（R 型）
    output reg [15:0] imm,    // 立即数（I 型）
    output reg [25:0] addr    // 跳转地址（J 型） 

instruct_reg IR( //IR分解指令为本不同字段
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

//符合和0扩展
ext_unit ext_unit(
    .in_data(in_data),
    .ExCtrl(ExCtrl),
    .out_data(out_data)
);
//input [15:0] in_data,
   // input ExtCtrl, //扩展方式的控制信号
    //output wire [31:0] out_data
    
    
   
//assign pcSrc_mux.pc_next = pc_next;  //mux选择pcnext
//assign pc.pc_next_in = pcSrc_mux.pc_next; //所存下一个pc

// 寄存器堆
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
// 临时寄存器存储读取的数据
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