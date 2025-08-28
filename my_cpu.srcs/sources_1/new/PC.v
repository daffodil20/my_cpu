`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/08/15 15:30:09
// Design Name: 
// Module Name: PC
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


module PC(
     input wire clk, rst,
     input wire PCWrite, //дPC�Ŀ����ź�
     input wire [31:0] pc_next_in,
     output wire [31:0] pc_out
);
reg [31:0] pc_reg;
always @(posedge clk or posedge rst) begin
     if (rst) begin
        pc_reg <= 32'b0; //�첽��λ����PC����
     end else if (PCWrite) begin //д��Чʱ��ʱ�������ظ���PC������PC��ַ��reg��
        pc_reg <= pc_next_in;
     end
end
// ���ڲ��Ĵ���Ѹ�����ӵ�����˿ڣ� ���ȴ�ʱ���źţ���ʱ�������
// ����һ������߼���ֵ
assign pc_out = pc_reg;
endmodule