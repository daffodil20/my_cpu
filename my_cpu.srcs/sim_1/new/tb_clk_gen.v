`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/08/19 15:08:21
// Design Name: 
// Module Name: tb_clk_gen
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
/*module tb_clk_gen;
    // �����ź�
    reg clk;
    reg rst;

    // ����ź�
    wire fetch;
    wire DM_ena;

    // ʵ��������ģ��
    clk_gen clk_gen (
        .clk(clk),
        .rst(rst),
        .fetch(fetch),
        .DM_ena(DM_ena)
    );

    // ������ʱ�� (���� 10ns = 100MHz)
    always #5 clk = ~clk;

    initial begin
        // ��ʼ��
        clk = 0;
        rst = 1;

        // ���ָ�λһ��ʱ��
        #20;
        rst = 0;

        // ����һ��ʱ�䣬�۲����
        #200;

        // �ٴθ�λ
        rst = 1;
        #10;
        rst = 0;

        // ������һ��ʱ��
        #200;

        // �������
        $stop;
    end

endmodule*/

module tb_clk_gen;

    // ����������ģ����ź�
    wire clk;
    
    // ʵ���� clk_gen ģ��
    clk_gen clk_gen (
        .clk(clk)
    );

    // �������
    initial begin

        // �������� 200ns �����
        #200;
        $finish;
    end

endmodule

