`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/08/23 08:19:58
// Design Name: 
// Module Name: PC_accumulator
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


module PC_accumulator( //pc�ۼ���������˳��ִ�е���һ����ַ
    input [31:0] pc_current, //��ǰPC�ͼ���
    output [31:0] pc_plus_4
);

assign pc_plus_4 = pc_current + 3'd4; //��һ��ָ���PC

endmodule
