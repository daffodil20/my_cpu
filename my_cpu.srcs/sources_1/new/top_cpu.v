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
    input clk, rst,    //仿真没有输出，观察pc,aluout即可
    //output [31:0] pc_out, //输出下一个指令和pc
    output [7:0] led, //低8位pc
    //output [15:0] ALU_result,
    output [7:0] seg,  // 七段管段选
    output [2:0] sel   // 七段管位选
    /*output [31:0] instruct,
    output [31:0] reg1_val, reg2_val, reg3_val, reg31_val,//探测寄存器的内容
    output [31:0] ALU_result, op1, op2, ALUOut, write_data, read_data2, pc_plus_4, read_data1,
    output [5:0] opcode, func,
    output [4:0] rs,
    output [1:0] RegDst, PCSrcCtrl, Mem2Reg,
    output IRRead, PCWrite, ALUWrite, RegWrite, DataRead, DataWrite,
    output zero,
    output [25:0] addr*/
);

/*wire PCWrite, RegWrite;//寄存器堆读写数据
wire RegWrite, IRRead, PCWrite, ALUWrite;//寄存器堆读写数据
wire zero;
wire [4:0] rs;
wire [5:0] opcode, func;
wire DataWrite, DataRead; 
wire DRWrite;//内存读写
wire [1:0]  PCSrcCtrl;
wire [1:0]  RegDst;
wire [1:0] Mem2Reg;
wire ExtCtrl;
wire [1:0]  ALUSrcBCtrl;
wire [3:0]  ALUCtrl;
wire [31:0] pc_out, ALU_result, instruct;
wire [25:0] addr;
wire [31:0] pc_acc_en, op1, op2, ALUOut, write_data, read_data2, pc_plus_4, read_data1; //0标志
wire [31:0] reg1_val, reg2_val, reg3_val, reg31_val;*/

wire [31:0] pc_out;
wire [31:0] alu_val;
//wire [7:0] seg;
//wire [2:0] sel;

// 分频器：24MHz → 1kHz 扫描频率
 reg [14:0] div_cnt = 0;   // 2^15 / 24M ≈ 1.3ms
 reg scan_clk = 0;
 always @(posedge clk or posedge rst) begin
     if (rst) begin
         div_cnt <= 0;
         scan_clk <= 0;
     end else begin
         //if (div_cnt == 24_000_000-1) begin  // 24MHz / 24k = 1kHz
         //if (div_cnt == 24_000-1) begin  // 24MHz / 24k = 1kHz
         if (div_cnt == 4999) begin  //板载时钟是10kHZ
             div_cnt <= 0;
             scan_clk <= ~scan_clk;
         end else begin
             div_cnt <= div_cnt + 1;
         end
     end
 end

 // 实例化CPU
cpu cpu(
    .clk(scan_clk),   // 给CPU一个慢时钟，方便肉眼看变化
    .rst(rst),
    .pc_out(pc_out),
    .ALU_result(alu_val) //输出alu_val，送入seg7
);

// 实例化数码管驱动
_7seg_display seg7(
    .clk(clk),
    .rst(rst),
    .result(alu_val[15:0]),  // 先显示低 16 位
    .seg(seg),              // 七段管段选
    .sel(sel)                 // 七段管位选
);

// 让LED显示PC低8位
assign led = pc_out[7:0];

//assign ALU_result = alu_val;  // 仿真对外保留完整的32位结果

// 实例化数据通路，输出当前指令和当前pc
/*data_path dp(
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
    .reg31_val(reg31_val), 
    .ALU_result(ALU_result),
    .pc_plus_4(pc_plus_4),
    //.pc_plus_4(pc_out+3'd4),
    .read_data1(read_data1),
    .rs(rs),
    .op1(op1),
    .op2(op2),
    .ALUOut(ALUOut),
    .read_data2(read_data2),
    .write_data(write_data),
    .addr(addr)
);

assign led = pc_out[7:0]; //led只取pc的低8位
//assign pc_out = dp.pc_out; //连接输出端口

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
);*/

endmodule
