`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/08/17 14:20:13
// Design Name: 
// Module Name: PCSrc_mux
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


module PCSrc_mux( //PC��ֵ��4��ѡ�����pc�ۼ����ĵڶ���������
    input [31:0] pc_plus_4, branch_addr, jump_addr, rs, //4��pc��ֵ
    input [1:0] PCSrcCtrl,
    output reg [31:0] pc_next //�����һ��PCֵ
);
always @* begin
   case (PCSrcCtrl)
       2'b00: pc_next <= pc_plus_4; //Ĭ����+4
       2'b01: pc_next <= branch_addr; //��֧��ַ
       2'b10: pc_next <= jump_addr; //��ת��ַ
       2'b11: pc_next <= rs;
       default: pc_next <= pc_plus_4; //��üӸ�default
   endcase
end
endmodule
