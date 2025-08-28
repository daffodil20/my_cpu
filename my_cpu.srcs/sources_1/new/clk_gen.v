`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/08/19 14:12:09
// Design Name: 
// Module Name: clk_gen
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


/*module clk_gen( //ʱ�ӷ�����
    input clk, rst, //��ʱ���ź�
    output reg fetch, DM_ena //��clk��Ƶ��ȡָ�ͷô�ʱ��ϳ�
);
    // �ڲ����������������ɷ�Ƶʱ�ӺͿ����ź�
    // ������8��Ƶ����Ҫһ��������7�ļ����� (3 bits, 0-7)
    reg [2:0] fetch_counter; // ������
    reg [1:0] DM_counter;

    // always ������ͬ���߼�����ʱ�������ظ��¼����������
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // ��λʱ�����������㣬��������ź�Ҳ����
            fetch_counter <= 3'b0;
            DM_counter <= 2'b0;
        end else begin
            fetch_counter <= fetch_counter + 1'b1;
            DM_counter <= DM_counter + 1'b1;
            fetch <= (fetch_counter == 3'b0) ? 1'b0: 1'b1;
            DM_ena <= (DM_counter == 2'b0) ? 1'b0: 1'b1;
        end
     end
endmodule*/

/*module clk_gen (
    input wire clk,
    input wire rst,
    output reg fetch, DM_ena
);

    // �ڲ�������������ʵ��8��Ƶ��
    // 3λ������ (0-7)�����ø���8��clk����
    //reg [2:0]  clk_div_cnt;
    integer counter;

    // ͬ��ʱ���߼�����ʱ�������ػ�λʱ����
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // ��λʱ������������������ź�����
            //clk_div_cnt <= 3'd0;
            counter = 0;
            fetch <= 1'b0;
            DM_ena <= 1'b0;
        end else begin
            // ����������
            // ���������ﵽ 7 ʱ���Զ����Ƶ� 0
            //clk_div_cnt <= clk_div_cnt + 1'b1;
            counter = counter + 1;
            // ���ݼ�����ֵ���� fetch �ź�
            // �������� 1 �� 4 ʱ��fetch Ϊ�ߵ�ƽ��4��clk���ڣ�

            if (counter < 5) begin
                fetch <= 1'b1;
            end else begin
                fetch <= 1'b0;
            end

            // ���ݼ�����ֵ���� DM_ena �ź�
            // �������� 7 �� 8 ʱ��DM_ena Ϊ�͵�ƽ��2��clk���ڣ�
            if (counter < 9 & counter > 6) begin
                DM_ena <= 1'b1;
            end else begin
                // ����ʱ��Ϊ�͵�ƽ
                DM_ena <= 1'b0;
            end
        end
    end

endmodule*/



//********************************************************************************
// Module Name: clk_gen
// Description: Generates timing signals for a 9-cycle multi-cycle CPU instruction.
//              - 'fetch' is active for the first 4 cycles (for Instruction Fetch).
//              - 'DM_ena' is active for cycles 7-8 (for Data Memory Access).
//              - Assumes Decode, Execute, Write-Back each take 1 cycle in between.
//
// Inputs:
//   clk:       High-frequency system clock.
//   rst:       System reset signal (active high).
//
// Outputs:
//   fetch:     Signal active during instruction fetch phase (cycles 1-4).
//   DM_ena:    Signal active during data memory access phase (cycles 7-8).
//********************************************************************************
module clk_gen (
    input wire clk,
    input wire rst,
    output reg fetch,
    output reg DM_ena
);

    // �ڲ�������������ʵ��9��ʱ������ѭ����
    // ������ 0 �� 8 (��9��״̬)����Ҫ4λ����ʾ 8 (binary 1000).
    reg [3:0] cycle_counter;

    // ͬ��ʱ���߼�����ʱ�������ػ�λʱ����
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // ��λʱ������������������ź�����
            cycle_counter <= 4'd0;
            fetch         <= 1'b0;
            DM_ena        <= 1'b0;
        end else begin
            // ���������������ڴﵽ 8 ʱ���Ƶ� 0��
            // ����ʵ�� 0 �� 8 �� 9 ������ѭ����
            cycle_counter <= (cycle_counter == 4'd8) ? 4'd0 : cycle_counter + 1'b1;

            // ���ݼ�����ֵ���� fetch �ź�
            // "1-4ʱ������" ��Ӧ cycle_counter ��ֵ 0, 1, 2, 3 (��4������)
            if (cycle_counter >= 4'd0 && cycle_counter <= 4'd3) begin
                fetch <= 1'b1;
            end else begin
                fetch <= 1'b0;
            end

            // ���ݼ�����ֵ���� DM_ena �ź�
            // "7-8ʱ������" ��Ӧ cycle_counter ��ֵ 6, 7 (��2������)
            if (cycle_counter >= 4'd6 && cycle_counter <= 4'd7) begin
                DM_ena <= 1'b1;
            end else begin
                DM_ena <= 1'b0;
            end
        end
    end

endmodule


