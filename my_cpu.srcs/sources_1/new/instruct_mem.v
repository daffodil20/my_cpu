`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/08/16 10:36:44
// Design Name: 
// Module Name: instruct_mem
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


module instruct_mem(
    input [31:0] instruct_addr, //指令地址
    output [31:0] instruct_data //读取到的指令
);
reg [31:0] IM [0:1023]; //1024个指令存放在指令存储器
assign instruct_data = IM[instruct_addr[11:2]]; //选出1024条条指令的索引，低2位一直是00，没有用
endmodule
