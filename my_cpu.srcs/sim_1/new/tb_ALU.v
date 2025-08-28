`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/08/19 09:52:42
// Design Name: 
// Module Name: tb_ALU
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

module tb_ALU();

    reg [31:0] a;
    reg [31:0] b;
    reg [3:0] ALUCtrl;
    wire [32:0] result;
    wire zero_flag;

    // 实例化 ALU
    ALU uut (
        .a(a),
        .b(b),
        .ALUCtrl(ALUCtrl),
        .result(result),
        .zero_flag(zero_flag)
    );

    // 任务：显示测试结果
    task display_result;
        begin
            $display("Time=%0t | ALUCtrl=%b | a=%d (0x%h) | b=%d (0x%h) | result=%d (0x%h) | zero_flag=%b",
                      $time, ALUCtrl, a, a, b, b, result, result, zero_flag);
        end
    endtask

    initial begin
        // 打印信号变化
        $monitor("Time=%0t | ALUCtrl=%b | a=%d | b=%d | result=%d | zero_flag=%b",
                 $time, ALUCtrl, a, b, result, zero_flag);

        // 初始值
        a = 32'd0; b = 32'd0; ALUCtrl = 4'b0000;
        #10;

        // 加法
        a = 32'd10; b = 32'd20; ALUCtrl = 4'b0000; #10; display_result();
        // 减法
        a = 32'd50; b = 32'd20; ALUCtrl = 4'b0001; #10; display_result();
        // AND
        a = 32'hF0F0; b = 32'h0FF0; ALUCtrl = 4'b0010; #10; display_result();
        // OR
        a = 32'hF0F0; b = 32'h0FF0; ALUCtrl = 4'b0011; #10; display_result();
        // XOR
        a = 32'hAAAA; b = 32'h5555; ALUCtrl = 4'b0100; #10; display_result();
        // NOR
        a = 32'h0000_FFFF; b = 32'hFFFF_0000; ALUCtrl = 4'b0101; #10; display_result();
        // 逻辑左移
        a = 32'h0000_0001; b = 32'd4; ALUCtrl = 4'b0110; #10; display_result();
        // 逻辑右移
        a = 32'h8000_0000; b = 32'd4; ALUCtrl = 4'b0111; #10; display_result();
        // 算术右移
        a = -32'd128; b = 32'd2; ALUCtrl = 4'b1000; #10; display_result();
        // zero_flag 测试
        a = 32'd10; b = 32'd10; ALUCtrl = 4'b0001; #10; display_result();

        // 结束仿真
        $finish;
    end
endmodule

