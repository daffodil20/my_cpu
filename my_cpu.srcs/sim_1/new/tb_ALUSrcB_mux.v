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

    // 输入信号
    reg [31:0] regB;
    reg [31:0] ext_data;
    reg [31:0] shamt;
    reg [1:0]  ALUSrcBCtrl;

    // 输出信号
    wire [31:0] ALU_in_2;

    // 实例化待测模块
    ALUSrcB_mux ALUSrcB_mux (
        .regB(regB),
        .ext_data(ext_data),
        .shamt(shamt),
        .ALUSrcBCtrl(ALUSrcBCtrl),
        .ALU_in_2(ALU_in_2)
    );

    initial begin
        // 初始化输入
        regB     = 32'hAAAA_AAAA;   // 1010...1010
        ext_data = 32'h1234_5678;
        shamt    = 32'h0000_0004;   // 4
        ALUSrcBCtrl = 2'b00;

        // 显示标题
        $display("time\tCtrl\tALU_in_2");

        // 监控信号变化
        $monitor("%0t\t%b\t%h", $time, ALUSrcBCtrl, ALU_in_2);

        // 依次测试不同选择
        #10 ALUSrcBCtrl = 2'b00;  // 选择 regB
        #10 ALUSrcBCtrl = 2'b01;  // 选择 ext_data
        #10 ALUSrcBCtrl = 2'b10;  // 选择 shamt
        #10 ALUSrcBCtrl = 2'b11;  // default -> regB

        #10 $finish;
    end

endmodule
