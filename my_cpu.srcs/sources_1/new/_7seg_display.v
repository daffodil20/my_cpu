`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/09/12 20:43:51
// Design Name: 
// Module Name: _7seg_display
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


module _7seg_display(
    input clk,        // 板载时钟
    input rst,        // 复位
    input [15:0] result, // 要显示的16位数（每4位显示1个十六进制数）
    output reg [7:0] seg, // 段选（abcdefg）
    output reg [2:0] sel   // 位选（哪一位亮）
);

 // 分频，让数码管扫描频率在1kHz左右
    reg [15:0] div_cnt = 0;
    reg scan_clk = 0;
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            div_cnt <= 0;
            scan_clk <= 0;
        end else begin
            if (div_cnt == 50_000-1) begin  // 50MHz时钟 -> 1kHz (改成你的实际板载时钟)
                div_cnt <= 0;
                scan_clk <= ~scan_clk;
            end else begin
                div_cnt <= div_cnt + 1;
            end
        end
    end

    // 当前扫描的位
    reg [1:0] digit_sel = 0;
    always @(posedge scan_clk or posedge rst) begin
        if (rst) digit_sel <= 0;
        else digit_sel <= digit_sel + 1;
    end

    // 从输入值里取出要显示的4bit，共4个
    reg [3:0] hex_digit;
    always @(*) begin
        case (digit_sel)
            2'b00: hex_digit = result[3:0];
            2'b01: hex_digit = result[7:4];
            2'b10: hex_digit = result[11:8];
            2'b11: hex_digit = result[15:12];
            default: hex_digit = result[3:0];
            
            /*2'b000: bin_digit = result[0];
            2'b001: bin_digit = result[1];
            2'b010: bin_digit = result[2];
            2'b011: bin_digit = result[3];
            2'b100: bin_digit = result[4];
            2'b101: bin_digit = result[5];
            2'b110: bin_digit = result[6];
            2'b111: bin_digit = result[7];*/
            //default: bin_digit = 0;
        endcase
    end

    // 数码管段选编码 (abcdefg)
    always @(*) begin
        case (hex_digit) 
        
            4'd0: seg = 8'b1111_1100;
            4'd1: seg = 8'b0000_1100;
            4'd2: seg = 8'b1101_1010;
            4'd3: seg = 8'b1111_0100;
            4'd4: seg = 8'b0110_0110;
            4'd5: seg = 8'b1011_0110;
            4'd6: seg = 8'b1011_1110;
            4'd7: seg = 8'b1110_0000;
            4'd8: seg = 8'b1111_1110;
            4'd9: seg = 8'b1111_0110;
             
            /*4'h0: seg = 7'b1000000;
            4'h1: seg = 7'b1111001;
            4'h2: seg = 7'b0100100;
            4'h3: seg = 7'b0110000;
            4'h4: seg = 7'b0011001;
            4'h5: seg = 7'b0010010;
            4'h6: seg = 7'b0000010;
            4'h7: seg = 7'b1111000;
            4'h8: seg = 7'b0000000;
            4'h9: seg = 7'b0010000;*/
            4'hA: seg = 8'b1110_1110;
            4'hB: seg = 8'b0011_1110;
            4'hC: seg = 8'b1001_1100;
            4'hD: seg = 8'b0111_1010;
            4'hE: seg = 8'b1001_1110;
            4'hF: seg = 8'b1000_1110;
            default: seg = 8'b0000_0000; // 全灭
        endcase
    end

    // 位选 (低有效，哪个为0哪一位亮)，共4个数码管需要亮
    always @(*) begin
        case (digit_sel)
            /*2'b00: sel = 3'b111;
            2'b01: sel = 3'b110;
            2'b10: sel = 3'b101;
            2'b11: sel = 3'b100;*/
            
            2'b00: sel = 3'b100;
            2'b01: sel = 3'b101;
            2'b10: sel = 3'b110;
            2'b11: sel = 3'b111;
            default: sel = 3'b100;
        endcase
    end
endmodule
