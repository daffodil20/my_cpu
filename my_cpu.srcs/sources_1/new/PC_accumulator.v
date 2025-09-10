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
    input pc_acc_en, //pc�ۼ�����ʹ���ź�
    output reg [31:0] pc_plus_4
    //output [31:0] pc_plus_4
);

//assign pc_plus_4 = pc_current + 3'd4 if ; //��һ��ָ���PC

always @* begin
    case (pc_acc_en)
        1'b0: pc_plus_4 = pc_current; //pc����
        1'b1: pc_plus_4 = pc_current + 3'd4;
    endcase
end

endmodule
