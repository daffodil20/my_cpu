`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/08/17 15:03:36
// Design Name: 
// Module Name: tb_ALUSrcB_mux
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


module tb_ALUSrcB_mux(
    input [31:0] regB, ext_addr, shamt, //
    input [1:0] ALUSrcBCtrl,
    output reg [31:0] pc_next //输出下一个PC值
);
always @* begin
   case (ALUSrcBCtrl)
       2'b00: pc_next <= regB;
       2'b01: pc_next <= ext_addr; //扩展地址
       2'b10: pc_next <= shamt; //移位位数
   endcase
end
endmodule
