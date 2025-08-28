`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/08/16 10:36:44
// Design Name: 
// Module Name: instruct_mem
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


module instruct_mem(
    input [31:0] instruct_addr, //ָ���ַ
    output [31:0] instruct_data //��ȡ����ָ��
);
reg [31:0] IM [0:1023]; //1024��ָ������ָ��洢��
assign instruct_data = IM[instruct_addr[11:2]]; //ѡ��1024����ָ�����������2λһֱ��00��û����
endmodule
