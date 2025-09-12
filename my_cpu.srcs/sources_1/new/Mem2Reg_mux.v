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
      input [31:0] ALUOut, MDR_data, pc_plus_4, //包括jal指令的(pc)+4
      input [1:0] Mem2Reg, //控制信号
      output reg [31:0] write_data
);

always @* begin
    case(Mem2Reg)
        2'b00: write_data <= ALUOut;
        2'b01: write_data <= MDR_data;
        2'b10: write_data <= pc_plus_4;
        default: write_data <= ALUOut;
    endcase
end
//assign write_data = (Mem2Reg == 0) ? ALUOut: MDR_data;
endmodule
