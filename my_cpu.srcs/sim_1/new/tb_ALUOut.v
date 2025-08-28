`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/08/18 15:04:22
// Design Name: 
// Module Name: tb_ALUOut
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

module tb_ALUOut;
    // �����ź�
    reg clk;
    reg rst;
    reg ALUWrite;
    reg [31:0] ALUResult;
    // ����ź�
    wire [31:0] ALUOut;

    // ʵ��������ģ��
    ALUOut uut (
        .ALUResult(ALUResult),
        .rst(rst),
        .clk(clk),
        .ALUWrite(ALUWrite),
        .ALUOut(ALUOut)
    );

    // ����ʱ�ӣ����� 10ns
    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        // ��ʼ��
        rst = 1; ALUWrite = 0; ALUResult = 32'h0000_0000;
        #12;           // �ȴ�һ��ʱ�䣬���һ��ʱ�ӱ���

        // �ͷŸ�λ
        rst = 0;

        // case1: ALUWrite = 1��д�� ALUResult
        ALUWrite = 1; ALUResult = 32'hAAAA_BBBB;
        #10;   // һ��ʱ��������
        $display("Time=%0t, ALUOut=%h (����=AAAA_BBBB)", $time, ALUOut);

        // case2: ALUWrite = 0�������� ALUOut������֮ǰ��ֵ
        ALUWrite = 0; ALUResult = 32'h1234_5678;
        #10;
        $display("Time=%0t, ALUOut=%h (����=AAAA_BBBB)", $time, ALUOut);

        // case3: �ٴ�д����ֵ
        ALUWrite = 1; ALUResult = 32'hDEAD_BEEF;
        #10;
        $display("Time=%0t, ALUOut=%h (����=DEAD_BEEF)", $time, ALUOut);

        // case4: �ٴθ�λ
        rst = 1;
        #10;
        $display("Time=%0t, ALUOut=%h (����=0000_0000)", $time, ALUOut);

        $finish;
    end
endmodule
