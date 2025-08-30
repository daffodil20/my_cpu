`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/08/16 11:11:20
// Design Name: 
// Module Name: data_mem
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


module data_mem(
    input clk,
    input [11:0] read_addr, write_addr, //��ȡ��д�����ݵĵ�ַ
    input [31:0] write_data, //��д�������
    input DataWrite, DataRead, //д������ź�
    output reg [31:0] read_data
);

reg [31:0] DM [0:1023];
always @(posedge clk) begin //������д������
    if (DataWrite) begin //DataWrite=1, DataRead=0ʱ����д�룬�����������ȡ����
        DM[write_addr] <= write_data;
    end else if (DataRead) begin
        read_data <= DM[read_addr];
    end
end
//assign read_data = DM[read_addr]; //�첽��ȡ����

endmodule
