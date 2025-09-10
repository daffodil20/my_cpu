`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/08/16 15:01:59
// Design Name: 
// Module Name: instruct_reg
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


module instruct_reg(
    input clk, rst,
    input IRRead, //读取指令的控制信号
    input [31:0] instruct, //待拆分的32位指令，指令拆分后会进入主控制器
    output reg [5:0] opcode,  // 操作码
    output reg [4:0] rs,      // 源寄存器1
    output reg [4:0] rt,      // 源寄存器2 / 目的寄存器
    output reg [4:0] rd,      // 目的寄存器（R 型）
    output reg [4:0] shamt,   // 移位量
    output reg [5:0] func,   // 功能码（R 型）
    output reg [15:0] imm,    // 立即数（I 型）
    output reg [25:0] addr    // 跳转地址（J 型） 
);

always @(posedge clk or posedge rst) begin
    if (rst) begin //复位，初始寄存器，使其状态已知
         opcode <= 6'b0;
         rs     <= 5'b0;
         rt     <= 5'b0;
         rd     <= 5'b0;
         shamt  <= 5'b0;
         func  <= 6'b0;
         imm    <= 16'b0;
         addr   <= 26'b0;
    end 
    else if (IRRead) begin //从IM读取指令到寄存器存储
        opcode <= instruct[31:26];
        rs <= instruct[25:21];
        rt <= instruct[20:16];
        rd <= instruct[15:11];
        shamt <= instruct[10:6];
        func <= instruct[5:0];
        imm  <= instruct[15:0];
        addr <= instruct[25:0];
    end
end
endmodule
