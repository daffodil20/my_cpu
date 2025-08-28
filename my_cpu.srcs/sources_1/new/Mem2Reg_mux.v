`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/08/18 08:14:18
// Design Name: 
// Module Name: Mem2Reg_mux
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


module Mem2Reg_mux( //把哪里的数据写入reg file
      input [31:0] ALUOut, MDR_data,
      input Mem2Reg, //控制信号
      output [31:0] write_data
);
assign write_data = (Mem2Reg == 0) ? ALUOut: MDR_data;
endmodule
