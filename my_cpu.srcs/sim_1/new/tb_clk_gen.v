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
    // 输入信号
    reg clk;
    reg rst;

    // 输出信号
    wire fetch;
    wire DM_ena;

    // 实例化待测模块
    clk_gen clk_gen (
        .clk(clk),
        .rst(rst),
        .fetch(fetch),
        .DM_ena(DM_ena)
    );

    // 产生主时钟 (周期 10ns = 100MHz)
    always #5 clk = ~clk;

    initial begin
        // 初始化
        clk = 0;
        rst = 1;

        // 保持复位一段时间
        #20;
        rst = 0;

        // 运行一段时间，观察输出
        #200;

        // 再次复位
        rst = 1;
        #10;
        rst = 0;

        // 再运行一段时间
        #200;

        // 仿真结束
        $stop;
    end

endmodule*/

module tb_clk_gen;

    // 声明被测试模块的信号
    wire clk;
    
    // 实例化 clk_gen 模块
    clk_gen clk_gen (
        .clk(clk)
    );

    // 仿真控制
    initial begin

        // 仿真运行 200ns 后结束
        #200;
        $finish;
    end

endmodule

