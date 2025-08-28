`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/08/17 15:28:25
// Design Name: 
// Module Name: tb_ALUSrcB_mux
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

module tb_ALUSrcB_mux;

    // �����ź�
    reg [31:0] regB;
    reg [31:0] ext_data;
    reg [31:0] shamt;
    reg [1:0]  ALUSrcBCtrl;

    // ����ź�
    wire [31:0] ALU_in_2;

    // ʵ��������ģ��
    ALUSrcB_mux ALUSrcB_mux (
        .regB(regB),
        .ext_data(ext_data),
        .shamt(shamt),
        .ALUSrcBCtrl(ALUSrcBCtrl),
        .ALU_in_2(ALU_in_2)
    );

    initial begin
        // ��ʼ������
        regB     = 32'hAAAA_AAAA;   // 1010...1010
        ext_data = 32'h1234_5678;
        shamt    = 32'h0000_0004;   // 4
        ALUSrcBCtrl = 2'b00;

        // ��ʾ����
        $display("time\tCtrl\tALU_in_2");

        // ����źű仯
        $monitor("%0t\t%b\t%h", $time, ALUSrcBCtrl, ALU_in_2);

        // ���β��Բ�ͬѡ��
        #10 ALUSrcBCtrl = 2'b00;  // ѡ�� regB
        #10 ALUSrcBCtrl = 2'b01;  // ѡ�� ext_data
        #10 ALUSrcBCtrl = 2'b10;  // ѡ�� shamt
        #10 ALUSrcBCtrl = 2'b11;  // default -> regB

        #10 $finish;
    end

endmodule
