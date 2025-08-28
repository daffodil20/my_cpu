`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/08/18 10:43:18
// Design Name: 
// Module Name: RegDst_mux
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


module RegDst_mux( //选择写入寄存器堆的地址
    input [4:0] rd, rt, reg31,
    input RegDst,
    output reg [31:0] write_addr
);
always @* begin
   case (RegDst)
       2'b00: write_addr <= rd; 
       2'b01: write_addr <= rt; 
       2'b10: write_addr <= reg31;
       default: write_addr <= rd; //最好加个default
   endcase
end
endmodule
