`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/08/17 09:24:00
// Design Name: 
// Module Name: tmp_reg
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


module tmp_reg( //临时寄存器A,B,C
    input clk, rst, //时钟和复位端
    input [31:0] in_data,
    output reg [31:0] out_data
);
always @(posedge clk or posedge rst) begin
    if (rst) begin
       out_data <= 5'b0;
    end else begin //上升沿读取数据
       out_data <= in_data;
    end
end
endmodule
