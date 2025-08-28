`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/08/23 11:01:17
// Design Name: 
// Module Name: tb_instruct_mem
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


module tb_instruct_mem;

    reg  [31:0] instruct_addr;
    wire [31:0] instruct_data;

    // ʵ����ָ��洢��
    instruct_mem im (
        .instruct_addr(instruct_addr),
        .instruct_data(instruct_data)
    );

    initial begin
        // ��ʼ��ָ��洢�� (����ֱ�Ӹ�ֵ��ʵ�ʿ��� $readmemh)
        im.IM[0] = 32'h00000001;
        im.IM[1] = 32'h11111111;
        im.IM[2] = 32'h22222222;
        im.IM[3] = 32'h33333333;

        // ��ӡ��ʾ
        $display("��ʼ����ָ��洢��...");

        // ���ʵ�ַ 0
        instruct_addr = 0;
        #10 $display("Addr=%d, Data=%h", instruct_addr, instruct_data);

        // ���ʵ�ַ 1
        instruct_addr = 1;
        #10 $display("Addr=%d, Data=%h", instruct_addr, instruct_data);

        // ���ʵ�ַ 2
        instruct_addr = 2;
        #10 $display("Addr=%d, Data=%h", instruct_addr, instruct_data);

        // ���ʵ�ַ 3
        instruct_addr = 3;
        #10 $display("Addr=%d, Data=%h", instruct_addr, instruct_data);
        
        // ���ʵ�ַ 4
        instruct_addr = 4;
        #10 $display("Addr=%d, Data=%h", instruct_addr, instruct_data);

        // ���ʵ�ַ 5
        instruct_addr = 5;
        #10 $display("Addr=%d, Data=%h", instruct_addr, instruct_data);

        // ���ʵ�ַ 6
        instruct_addr = 6;
        #10 $display("Addr=%d, Data=%h", instruct_addr, instruct_data);

        // ���ʵ�ַ 7
        instruct_addr = 7;
        #10 $display("Addr=%d, Data=%h", instruct_addr, instruct_data);

        $display("�������.");
        $stop;
    end
endmodule
