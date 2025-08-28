`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/08/17 09:54:43
// Design Name: 
// Module Name: data_reg
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


module data_reg(
      input clk, rst,
      input DRWrite,               // 写使能
      input [31:0] in_data,   // 写入数据
      output reg [31:0] out_data // 输出数据
);
always @(posedge clk or posedge rst) begin
    if (rst) begin
       out_data <= 32'b0;
    end else if (DRWrite) begin //写使能，锁存输入数据
        out_data <= in_data;
    end
end
endmodule
