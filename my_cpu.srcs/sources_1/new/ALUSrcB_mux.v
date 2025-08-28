`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/08/17 15:15:32
// Design Name: 
// Module Name: ALUSrcB_mux
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


module ALUSrcB_mux(
    input [5:0] regB, shamt, //R型指令
    input [31:0] ext_data, //扩展后的imm/offset
    input [1:0] ALUSrcBCtrl,
    output reg [31:0] ALU_in_2 //输出第二个运算数
);
always @* begin
   case (ALUSrcBCtrl)
       2'b00: ALU_in_2 <= regB; //(regB)
       2'b01: ALU_in_2 <= ext_data; //扩展后的数据
       2'b10: ALU_in_2 <= shamt; //移位数目
       default: ALU_in_2 <= regB; //最好加个default
   endcase
end
endmodule
