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
integer i;

 initial begin
        // �ֶ�д����ָ����ߴ��ļ�����
        IM[0] = 32'h20010005;  // addi $1,$0,5
        IM[1] = 32'h20020003;  // addi $2,$0,3
        IM[2] = 32'h00221820;  // add  $3,$1,$2
        IM[3] = 32'hac030000;  // sw   $3,0($0)
        IM[4] = 32'h8c040000;  // lw   $4,0($0)
        
         // BEQ ʾ������� $1==$2����ת�� IM[7] (ƫ��=2��ע�� MIPS ƫ�Ƶ�λ��ָ����)
        IM[5] = 32'h10220002;  // beq $1,$2, label  (label��IM[8])

        // BNE ʾ������� $1!=$2����ת�� IM[8] (ƫ��=1)
        IM[6] = 32'h14220001;  // bne $1,$2, label2 (label2��IM[8])
        
        
        // ADDI ʾ���������޸ļĴ���
        IM[7] = 32'h20050001;  // addi $5,$0,1

        // J ָ��ʾ������ת�� IM[10]
        IM[8] = 32'h0800000a;  // j 10  (��ַ=10<<2)

        // NOP ����������
        IM[9] = 32'h00000000;  // nop
        IM[10] = 32'h20060002; // addi $6,$0,2
        // ���������
        
        for (i = 11; i < 256; i = i + 1)
            IM[i] = 32'b0;
            
end

assign instruct_data = IM[instruct_addr[11:2]]; //ѡ��1024����ָ�����������2λһֱ��00��û����

endmodule
