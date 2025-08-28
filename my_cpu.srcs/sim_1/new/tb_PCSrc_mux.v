`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/08/17 14:37:47
// Design Name: 
// Module Name: tb_PCSrc_mux
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

module tb_PCSrc_mux;

    // �����ź�
    reg [31:0] pc_plus_4;
    reg [31:0] branch_addr;
    reg [31:0] jump_addr;
    reg [31:0] rs;
    reg [1:0]  PCSrcCtrl;

    // ����ź�
    wire [31:0] pc_next;

    // ʵ��������ģ��
    PCSrc_mux PCSrc_mux (
        .pc_plus_4(pc_plus_4),
        .branch_addr(branch_addr),
        .jump_addr(jump_addr),
        .rs(rs),
        .PCSrcCtrl(PCSrcCtrl),
        .pc_next(pc_next)
    );

    // ��ʼ���Ͳ��Թ���
    initial begin
        // ��ʼ������
        pc_plus_4   = 32'h00000004;
        branch_addr = 32'h00000010;
        jump_addr   = 32'h00000020;
        rs          = 32'h00000030;
        PCSrcCtrl   = 2'b00;

        // �����źű仯
        $monitor("Time=%0t | PCSrcCtrl=%b | pc_next=%h", 
                  $time, PCSrcCtrl, pc_next);

        // ���β����������
        #10 PCSrcCtrl = 2'b00;  // ˳��ִ�� -> Ӧ����� 00000004
        #10 PCSrcCtrl = 2'b01;  // ��֧ -> Ӧ����� 00000010
        #10 PCSrcCtrl = 2'b10;  // ��ת -> Ӧ����� 00000020
        #10 PCSrcCtrl = 2'b11;  // jr -> Ӧ����� 00000030

        // ���� default ���
        #10 PCSrcCtrl = 2'bxx;  // �Ƿ����� -> Ӧ����� pc_plus_4 (00000004)

        #10 $finish; // ��������
    end

endmodule
