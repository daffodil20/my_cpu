`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/08/16 08:28:17
// Design Name: 
// Module Name: ALU
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


module ALU(
    input [31:0] a,
    input [31:0] b,
    input [3:0] ALUCtrl,//øÿ÷∆‘ÀÀ„÷÷¿‡
    output reg [31:0] result,
    output wire zero_flag //0±Í÷æ
);
always @* begin
    case (ALUCtrl)
        4'b0000: result = a + b;
        4'b0001: result = a - b;
        4'b0010: result  = a & b;
        4'b0011: result  = a | b;
        4'b0100: result  = a ^ b;
        4'b0101: result  = ~(a | b); //neg
        4'b0110: result  = a << b; //¬ﬂº≠◊Û“∆
        4'b0111: result  = a >> b; //¬ﬂº≠”““∆
        4'b1000: result = $signed(a) >> b; //À„ ı”““∆
        4'b1001: result = ($signed(a) < $signed(b)) ? 32'd1 : 32'd0;
        4'b1010: result = (a < b) ? 32'd1 : 32'd0;
        default: result = a + b;
    endcase
end
assign zero_flag = (result == 32'b0);
endmodule
