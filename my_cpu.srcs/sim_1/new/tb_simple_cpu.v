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

    // 实例化CPU
    SimpleCPU uut (
        .clk(clk),
        .reset(reset)
    );

    // 时钟生成
    always #5 clk = ~clk;

    initial begin
        // 初始化
        clk = 0;
        reset = 1;
        #10;
        reset = 0;

        // 初始化内存中的指令（手动写入Machine Code）
        // 注意：这些是简化的32位MIPS编码（仅用于演示）
        
        // add $1, $2, $3
        uut.MEM[0] = 32'b000000_00010_00011_00001_00000_100000;
        // lw $4, 4($2)
        uut.MEM[1] = 32'b100011_00010_00100_0000000000000100;
        // sw $4, 8($2)
        uut.MEM[2] = 32'b101011_00010_00100_0000000000001000;
        // beq $1, $2, -1
        uut.MEM[3] = 32'b000100_00001_00010_1111111111111111;

        // 初始化寄存器
        uut.REG[2] = 10; // $2 = 10
        uut.REG[3] = 20; // $3 = 20
        uut.REG[4] = 999; // $4 = 999

        // 初始化内存
        uut.MEM[3] = 32'hdeadbeef; // 用于lw测试

        // 仿真一段时间
        #200;

        // 输出寄存器和内存内容进行验证
        $display("==== 寄存器状态 ====");
        for (i = 1; i < 5; i = i + 1)
            $display("REG[%0d] = %d", i, uut.REG[i]);

        $display("==== 内存状态 ====");
        $display("MEM[3] = %h", uut.MEM[3]);
        $display("MEM[4] = %h", uut.MEM[4]);
        //$display("MEM[5] = %h", uut.MEM[5]);

        $stop;
    end
endmodule

