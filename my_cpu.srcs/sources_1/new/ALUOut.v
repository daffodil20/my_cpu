`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/08/18 14:48:49
// Design Name: 
// Module Name: ALUOut
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


module ALUOut(
    input [31:0] ALUResult, 
    input clk, rst,
    input ALUWrite, //写ALU的控制信号
    output reg [31:0] ALUOut
);
always @(posedge clk or posedge rst) begin
    if (rst) begin
        ALUOut = 32'b0;
    end else if (ALUWrite) begin//上升沿写入ALUOut
        ALUOut <= ALUResult;
    end
end
endmodule
