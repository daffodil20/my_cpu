`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/08/17 11:10:37
// Design Name: 
// Module Name: tb_ext_unit
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
module tb_ext_unit();

    // ����
    reg [15:0] in_data;
    reg ExtCtrl;

    // ���
    wire [31:0] out_data;

    // ʵ��������ģ��
    ext_unit ext_unit (
        .in_data(in_data),
        .ExtCtrl(ExtCtrl),
        .out_data(out_data)
    );

    initial begin
        // ��ӡ�źű仯������۲�
        $monitor("time=%0t | ExtCtrl=%b | in_data=%h | out_data=%h", 
                  $time, ExtCtrl, in_data, out_data);

        // ���� 1������չ
        in_data = 16'h1234; ExtCtrl = 1'b0; // ������0��չ
        #10;
        
        // ���� 2��������չ
        in_data = 16'h1234; ExtCtrl = 1'b1; // ������������չ
        #10;

        // ���� 3������չ
        in_data = 16'hF234; ExtCtrl = 1'b0; // ��������0��չ
        #10;

        // ���� 4��������չ
        in_data = 16'hF234; ExtCtrl = 1'b1; // ������������չ
        #10;

        $finish;
    end

endmodule
