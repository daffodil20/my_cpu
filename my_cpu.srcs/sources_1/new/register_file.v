`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/08/16 08:59:44
// Design Name: 
// Module Name: register_file
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


module register_file(
    input wire clk, rst,
    input [4:0] read_addr1, read_addr2, //��λ���ĸ��Ĵ���
    input [4:0] write_addr,
    input [31:0] write_data,
    input RegWrite, //���ƼĴ����ѵĶ�д
    output [31:0] read_data1, read_data2,
    output [31:0] reg1_val, reg2_val, reg3_val, reg5_val, reg6_val, reg7_val, reg8_val, reg9_val, reg10_val, reg31_val //̽��Ĵ���������
);
// �����ڲ��Ĵ�����
// һ������ 32 �� 32 λ�Ĵ���������
reg [31:0] regs [0:31];
integer i;
// ** 1. ͬ��д���߼�
always @(posedge clk or posedge rst) begin
    if (rst) begin //��λ
       for (i = 0; i < 32; i = i + 1) begin
           regs[i] = 32'b0; //�Ĵ�������
       end
    end else if (RegWrite) begin
        if (write_addr != 5'b0) begin //������0��reg����д������
            regs[write_addr] <= write_data;
        end
    end
end
 // ** 2. �첽��ȡ�߼� **
 // ��ȡ����������߼���������ʱ�ӣ���������
 // ���ǵ� 0 �żĴ�����������
assign read_data1 = (read_addr1 == 5'b0) ? 32'b0 : regs[read_addr1];
assign read_data2 = (read_addr2 == 5'b0) ? 32'b0 : regs[read_addr2];

assign reg1_val = regs[1];
assign reg2_val = regs[2];
assign reg3_val = regs[3];
assign reg5_val = regs[5];
assign reg6_val = regs[6];
assign reg7_val = regs[7];
assign reg8_val = regs[8];
assign reg9_val = regs[9];
assign reg10_val = regs[10];
assign reg31_val = regs[31];

endmodule
