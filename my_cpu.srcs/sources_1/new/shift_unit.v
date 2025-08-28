`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/08/23 10:14:59
// Design Name: 
// Module Name: shift_unit
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


module shift_unit( //移位单元，专门左移2位，用于j,jal,beq,bne
    input [31:0] x,
    output [31:0] y
);
assign y = x << 2; //左移2位
endmodule
