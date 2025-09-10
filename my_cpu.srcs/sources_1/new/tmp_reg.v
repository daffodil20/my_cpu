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


module tmp_reg( //��ʱ�Ĵ���A,B,C
    input clk, rst, //ʱ�Ӻ͸�λ��
    input [31:0] in_data,
    output reg [31:0] out_data
);
always @(posedge clk or posedge rst) begin
    if (rst) begin
       out_data <= 5'b0;
    end else begin //�����ض�ȡ����
       out_data <= in_data;
    end
end
endmodule
