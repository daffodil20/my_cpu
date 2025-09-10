`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/08/16 15:01:59
// Design Name: 
// Module Name: instruct_reg
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


module instruct_reg(
    input clk, rst,
    input IRRead, //��ȡָ��Ŀ����ź�
    input [31:0] instruct, //����ֵ�32λָ�ָ���ֺ�������������
    output reg [5:0] opcode,  // ������
    output reg [4:0] rs,      // Դ�Ĵ���1
    output reg [4:0] rt,      // Դ�Ĵ���2 / Ŀ�ļĴ���
    output reg [4:0] rd,      // Ŀ�ļĴ�����R �ͣ�
    output reg [4:0] shamt,   // ��λ��
    output reg [5:0] func,   // �����루R �ͣ�
    output reg [15:0] imm,    // ��������I �ͣ�
    output reg [25:0] addr    // ��ת��ַ��J �ͣ� 
);

always @(posedge clk or posedge rst) begin
    if (rst) begin //��λ����ʼ�Ĵ�����ʹ��״̬��֪
         opcode <= 6'b0;
         rs     <= 5'b0;
         rt     <= 5'b0;
         rd     <= 5'b0;
         shamt  <= 5'b0;
         func  <= 6'b0;
         imm    <= 16'b0;
         addr   <= 26'b0;
    end 
    else if (IRRead) begin //��IM��ȡָ��Ĵ����洢
        opcode <= instruct[31:26];
        rs <= instruct[25:21];
        rt <= instruct[20:16];
        rd <= instruct[15:11];
        shamt <= instruct[10:6];
        func <= instruct[5:0];
        imm  <= instruct[15:0];
        addr <= instruct[25:0];
    end
end
endmodule
