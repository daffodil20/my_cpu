`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/08/23 13:52:20
// Design Name: 
// Module Name: tb_instruct_reg
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


module tb_instruct_reg;
     // 信号声明
    reg clk;
    reg rst;
    reg IRRead;
    reg [31:0] instruct;

    wire [5:0] opcode;
    wire [4:0] rs, rt, rd, shamt;
    wire [5:0] func;
    wire [15:0] imm;
    wire [25:0] addr;

    // 实例化被测模块
    instruct_reg ir (
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

    // 时钟生成：周期 10ns
    initial clk = 0;
    always #5 clk = ~clk;

    // 测试流程
    initial begin
        // 初始化
        rst = 1;
        IRRead = 0;
        instruct = 32'b0;

        #10;  // 等一个时钟
        rst = 0;

        // --- 测试 R 型指令 ---
        // 例如 add $1, $2, $3 -> opcode=000000, rs=2, rt=3, rd=1, shamt=0, func=32
        instruct = {6'b000000, 5'd2, 5'd3, 5'd1, 5'd0, 6'b100000};
        IRRead = 1;
        #10;  // 一个时钟
        IRRead = 0;
        #10;

        $display("R-type instruction test:");
        $display("opcode=%b, rs=%d, rt=%d, rd=%d, shamt=%d, func=%b, imm=%h, addr=%h",
                  opcode, rs, rt, rd, shamt, func, imm, addr);

        // --- 测试 I 型指令 ---
        // 例如 lw $1, 4($2) -> opcode=100011, rs=2, rt=1, imm=4
        instruct = {6'b100011, 5'd2, 5'd1, 16'd4};
        IRRead = 1;
        #10;
        IRRead = 0;
        #10;

        $display("I-type instruction test:");
        $display("opcode=%b, rs=%d, rt=%d, imm=%d",
                  opcode, rs, rt, imm);

        // --- 测试 J 型指令 ---
        // 例如 j 0x3FF -> opcode=000010, addr=0x3FF
        instruct = {6'b000010, 26'h3FF};
        IRRead = 1;
        #10;
        IRRead = 0;
        #10;

        $display("J-type instruction test:");
        $display("opcode=%b, rs=%d, rt=%d, addr=%h",
                  opcode, rs, rt, addr);

        $stop; // 停止仿真
    end
endmodule
