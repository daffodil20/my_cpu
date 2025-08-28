`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/08/17 09:37:08
// Design Name: 
// Module Name: tb_tmp_reg
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

module tb_tmp_reg;

    // Testbench signals for DUT inputs (declared as reg)
    reg clk;
    reg rst;
    reg [31:0] in_data;

    // Testbench wire for DUT output (declared as wire)
    wire [31:0] out_data;

    // Instantiate the Unit Under Test (DUT): tmp_reg
    // 实例化待测试单元 (DUT): tmp_reg
    tmp_reg tmp_reg (
        .clk(clk),
        .rst(rst),
        .in_data(in_data),
        .out_data(out_data)
    );

    // Clock generation: 10ns period (5ns high, 5ns low)
    // 时钟生成: 10ns 周期 (5ns 高电平, 5ns 低电平)
    always #5 clk = ~clk;

    // Initial block for test stimulus
    // initial 块用于测试激励
    initial begin
        // Initialize all inputs at time 0
        // 在时间 0 初始化所有输入
        clk     = 1'b0;
        rst     = 1'b1;  // Assert reset initially
        in_data = 32'b0; // Default input data

        // Display header for waveform output
        // 为波形输出显示标题
        $display("Time\tclk\trst\tin_data\tout_data");
        // Monitor key signals for changes
        // 监控关键信号的变化
        $monitor("%0t\t%b\t%b\t%h\t%h", $time, clk, rst, in_data, out_data);

        // --- Test Sequence ---

        // 1. Assert reset: out_data should immediately become 0
        // 1. 断言复位: out_data 应该立即变为 0
        #10; // Wait 10ns while reset is active

        // 2. Deassert reset and load first data
        // 2. 撤销复位并加载第一个数据
        rst     = 1'b0;
        in_data = 32'hAAAA_AAAA;
        #10; // Wait for one clock cycle. At next posedge clk, out_data should be 0xAAAA_AAAA

        // 3. Load second data
        // 3. 加载第二个数据
        in_data = 32'hBBBB_BBBB;
        #10; // out_data should become 0xBBBB_BBBB

        // 4. Change input data, but no clock edge yet - out_data should remain old value
        // 4. 改变输入数据，但尚未到时钟沿 - out_data 应该保持旧值
        in_data = 32'hCCCC_CCCC;
        #5; // Wait halfway through the cycle. out_data should still be 0xBBBB_BBBB

        // 5. Next clock edge, out_data updates
        // 5. 下一个时钟沿，out_data 更新
        #5; // out_data should become 0xCCCC_CCCC

        // 6. Assert reset again
        // 6. 再次断言复位
        rst = 1'b1;
        #10; // out_data should immediately become 0

        // 7. Deassert reset and load final data
        // 7. 撤销复位并加载最终数据
        rst     = 1'b0;
        in_data = 32'hDDDD_DDDD;
        #10; // out_data should become 0xDDDD_DDDD

        // End simulation
        // 结束仿真
        $display("---------------------------------------");
        $display("Simulation finished at time %0t", $time);
        $finish; // Terminate simulation
    end

endmodule
