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

    // 输入信号
    reg [31:0] pc_plus_4;
    reg [31:0] branch_addr;
    reg [31:0] jump_addr;
    reg [31:0] rs;
    reg [1:0]  PCSrcCtrl;

    // 输出信号
    wire [31:0] pc_next;

    // 实例化待测模块
    PCSrc_mux PCSrc_mux (
        .pc_plus_4(pc_plus_4),
        .branch_addr(branch_addr),
        .jump_addr(jump_addr),
        .rs(rs),
        .PCSrcCtrl(PCSrcCtrl),
        .pc_next(pc_next)
    );

    // 初始化和测试过程
    initial begin
        // 初始化输入
        pc_plus_4   = 32'h00000004;
        branch_addr = 32'h00000010;
        jump_addr   = 32'h00000020;
        rs          = 32'h00000030;
        PCSrcCtrl   = 2'b00;

        // 监视信号变化
        $monitor("Time=%0t | PCSrcCtrl=%b | pc_next=%h", 
                  $time, PCSrcCtrl, pc_next);

        // 依次测试四种情况
        #10 PCSrcCtrl = 2'b00;  // 顺序执行 -> 应该输出 00000004
        #10 PCSrcCtrl = 2'b01;  // 分支 -> 应该输出 00000010
        #10 PCSrcCtrl = 2'b10;  // 跳转 -> 应该输出 00000020
        #10 PCSrcCtrl = 2'b11;  // jr -> 应该输出 00000030

        // 测试 default 情况
        #10 PCSrcCtrl = 2'bxx;  // 非法输入 -> 应该输出 pc_plus_4 (00000004)

        #10 $finish; // 结束仿真
    end

endmodule
