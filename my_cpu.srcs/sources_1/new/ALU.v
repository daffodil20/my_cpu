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
    input [3:0] ALUCtrl,//控制运算种类
    output reg [31:0] result,
    output wire zero_flag, //0标志
    output reg overflow_flag //溢出标志
);
always @* begin
    case (ALUCtrl)
        4'b0000: begin 
            result = a + b; //add
            overflow_flag = (a[31] == b[31]) & (result[31] != a[31]);
        end
        4'b0001: result = a - b;
        4'b0010: result  = a & b;
        4'b0011: result  = a | b;
        4'b0100: result  = a ^ b;
        4'b0101: result  = ~(a | b); //neg
        4'b0110: result  = a << b; //逻辑左移
        4'b0111: result  = a >> b; //逻辑右移
        4'b1000: result = $signed(a) >> b; //算术右移
        4'b1001: result = ($signed(a) < $signed(b)) ? 32'd1 : 32'd0;
        4'b1010: result = (a < b) ? 32'd1 : 32'd0;
        4'b1011: result = a + b; //addu，不处理溢出
        //default: result = a + b;
        default: result = 0;
    endcase
end
assign zero_flag = (result == 32'b0);
endmodule
