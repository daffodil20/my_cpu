`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/07/22 11:20:56
// Design Name: 
// Module Name: tb_simple_cpu
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
module tb_simple_cpu;

    reg clk, reset;
    integer i;

    // ʵ����CPU
    SimpleCPU uut (
        .clk(clk),
        .reset(reset)
    );

    // ʱ������
    always #5 clk = ~clk;

    initial begin
        // ��ʼ��
        clk = 0;
        reset = 1;
        #10;
        reset = 0;

        // ��ʼ���ڴ��е�ָ��ֶ�д��Machine Code��
        // ע�⣺��Щ�Ǽ򻯵�32λMIPS���루��������ʾ��
        
        // add $1, $2, $3
        uut.MEM[0] = 32'b000000_00010_00011_00001_00000_100000;
        // lw $4, 4($2)
        uut.MEM[1] = 32'b100011_00010_00100_0000000000000100;
        // sw $4, 8($2)
        uut.MEM[2] = 32'b101011_00010_00100_0000000000001000;
        // beq $1, $2, -1
        uut.MEM[3] = 32'b000100_00001_00010_1111111111111111;

        // ��ʼ���Ĵ���
        uut.REG[2] = 10; // $2 = 10
        uut.REG[3] = 20; // $3 = 20
        uut.REG[4] = 999; // $4 = 999

        // ��ʼ���ڴ�
        uut.MEM[3] = 32'hdeadbeef; // ����lw����

        // ����һ��ʱ��
        #200;

        // ����Ĵ������ڴ����ݽ�����֤
        $display("==== �Ĵ���״̬ ====");
        for (i = 1; i < 5; i = i + 1)
            $display("REG[%0d] = %d", i, uut.REG[i]);

        $display("==== �ڴ�״̬ ====");
        $display("MEM[3] = %h", uut.MEM[3]);
        $display("MEM[4] = %h", uut.MEM[4]);
        //$display("MEM[5] = %h", uut.MEM[5]);

        $stop;
    end
endmodule

