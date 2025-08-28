`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/08/17 14:20:13
// Design Name: 
// Module Name: PCSrc_mux
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


module PCSrc_mux( //PC的值有4个选项，用于pc累加器的第二个运算数
    input [31:0] pc_plus_4, branch_addr, jump_addr, rs, //4种pc的值
    input [1:0] PCSrcCtrl,
    output reg [31:0] pc_next //输出下一个PC值
);
always @* begin
   case (PCSrcCtrl)
       2'b00: pc_next <= pc_plus_4; //默认是+4
       2'b01: pc_next <= branch_addr; //分支地址
       2'b10: pc_next <= jump_addr; //跳转地址
       2'b11: pc_next <= rs;
       default: pc_next <= pc_plus_4; //最好加个default
   endcase
end
endmodule
