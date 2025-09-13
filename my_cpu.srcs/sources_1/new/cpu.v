`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/09/12 15:42:35
// Design Name: 
// Module Name: cpu
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


module cpu(
    input  wire clk,
    input  wire rst,
    output wire [31:0] pc_out, ALU_result,
    //output wire [31:0] alu_result
    output wire [31:0] instruct,
    output wire [31:0] reg1_val, reg2_val, reg3_val, reg5_val, reg6_val, reg7_val, reg8_val, reg9_val, reg10_val, reg31_val,//探测寄存器的内容
    output wire [31:0] op1, op2, ALUOut, write_data, read_data2, pc_plus_4, read_data1, pc_acc_en,
    output wire [5:0] opcode, func,
    output wire [4:0] rs, shamt,
    output wire [1:0] RegDst, PCSrcCtrl, Mem2Reg,
    output wire [3:0] ALUCtrl,
    output wire IRRead, PCWrite, ALUWrite, RegWrite, DataRead, DataWrite,
    output wire zero,
    output wire [25:0] addr
);


wire PCWrite, RegWrite;//寄存器堆读写数据
wire IRRead, ALUWrite;//寄存器堆读写数据
//wire zero;
//wire [4:0] rs;
wire [5:0] opcode, func;
wire DataWrite, DataRead; 
wire DRWrite;//内存读写
//wire [1:0]  PCSrcCtrl;
//wire [1:0]  RegDst;
//wire [1:0] Mem2Reg;
wire ExtCtrl;
wire [1:0]  ALUSrcBCtrl;
//wire [3:0]  ALUCtrl;
//wire [31:0] ALU_result, instruct;
//wire [31:0] instruct;
//wire [25:0] addr;
//wire [31:0] pc_acc_en, op1, op2, ALUOut, write_data, read_data2, pc_plus_4, read_data1; //0标志
//wire [31:0] reg1_val, reg2_val, reg3_val, reg31_val;



// 分频器：24MHz → 1kHz 扫描频率
 reg [14:0] div_cnt = 0;   // 2^15 / 24M ≈ 1.3ms
 reg scan_clk = 0;
 always @(posedge clk or posedge rst) begin
     if (rst) begin
         div_cnt <= 0;
         scan_clk <= 0;
     end else begin
         if (div_cnt == 24_000-1) begin  // 24MHz / 24k = 1kHz
             div_cnt <= 0;
             scan_clk <= ~scan_clk;
         end else begin
             div_cnt <= div_cnt + 1;
         end
     end
 end


// 实例化数据通路，输出当前指令和当前pc
data_path dp(
    .clk(clk),
    .rst(rst), // 添加时钟和复位端口
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
    .reg3_val(reg3_val), //探测寄存器的内容
    .reg5_val(reg5_val),
    .reg6_val(reg6_val), 
    .reg7_val(reg7_val),
    .reg8_val(reg8_val),
    .reg9_val(reg9_val), 
    .reg10_val(reg10_val),
    .reg31_val(reg31_val), 
    .ALU_result(ALU_result),
    .pc_plus_4(pc_plus_4),
    //.pc_plus_4(pc_out+3'ssdss
    .read_data1(read_data1),
    .rs(rs),
    .shamt(shamt),
    .op1(op1),
    .op2(op2),
    .ALUOut(ALUOut),
    .read_data2(read_data2),
    .write_data(write_data),
    .addr(addr)
);


//实例化控制单元，输出控制信号
ctrl_unit ctrl_unit(
    .clk(clk),
    .rst(rst), // 添加时钟和复位端口
    .opcode(instruct[31:26]),
    //.func(instruct[25:20]),
    .func(instruct[5:0]),
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

