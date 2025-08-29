`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/08/17 15:15:32
// Design Name: 
// Module Name: ALUSrcB_mux
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


module ALUSrcB_mux(
    input [5:0] shamt, //R��ָ������6λ
    input [31:0] regB, ext_data, //�ڶ����Ĵ�������չ���imm/offset������32λ
    input [1:0] ALUSrcBCtrl,
    output reg [31:0] ALU_in_2 //����ڶ���������
);
always @* begin
   case (ALUSrcBCtrl)
       2'b00: ALU_in_2 <= regB; //(regB)
       2'b01: ALU_in_2 <= ext_data; //��չ�������
       //2'b10: ALU_in_2 <= shamt; //��λ��Ŀ
       2'b10: ALU_in_2 = {27'b0, shamt}; //��λ��Ŀ

       default: ALU_in_2 <= regB; //��üӸ�default
   endcase
end
endmodule
