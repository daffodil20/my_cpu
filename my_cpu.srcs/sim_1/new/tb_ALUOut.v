`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/08/18 15:04:22
// Design Name: 
// Module Name: tb_ALUOut
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

module tb_ALUOut;
    // 输入信号
    reg clk;
    reg rst;
    reg ALUWrite;
    reg [31:0] ALUResult;
    // 输出信号
    wire [31:0] ALUOut;

    // 实例化待测模块
    ALUOut uut (
        .ALUResult(ALUResult),
        .rst(rst),
        .clk(clk),
        .ALUWrite(ALUWrite),
        .ALUOut(ALUOut)
    );

    // 产生时钟，周期 10ns
    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        // 初始化
        rst = 1; ALUWrite = 0; ALUResult = 32'h0000_0000;
        #12;           // 等待一段时间，跨过一个时钟边沿

        // 释放复位
        rst = 0;

        // case1: ALUWrite = 1，写入 ALUResult
        ALUWrite = 1; ALUResult = 32'hAAAA_BBBB;
        #10;   // 一个时钟上升沿
        $display("Time=%0t, ALUOut=%h (期望=AAAA_BBBB)", $time, ALUOut);

        // case2: ALUWrite = 0，不更新 ALUOut，保持之前的值
        ALUWrite = 0; ALUResult = 32'h1234_5678;
        #10;
        $display("Time=%0t, ALUOut=%h (期望=AAAA_BBBB)", $time, ALUOut);

        // case3: 再次写入新值
        ALUWrite = 1; ALUResult = 32'hDEAD_BEEF;
        #10;
        $display("Time=%0t, ALUOut=%h (期望=DEAD_BEEF)", $time, ALUOut);

        // case4: 再次复位
        rst = 1;
        #10;
        $display("Time=%0t, ALUOut=%h (期望=0000_0000)", $time, ALUOut);

        $finish;
    end
endmodule
