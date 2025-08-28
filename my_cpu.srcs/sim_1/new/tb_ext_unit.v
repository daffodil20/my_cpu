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

    // 输入
    reg [15:0] in_data;
    reg ExtCtrl;

    // 输出
    wire [31:0] out_data;

    // 实例化被测模块
    ext_unit ext_unit (
        .in_data(in_data),
        .ExtCtrl(ExtCtrl),
        .out_data(out_data)
    );

    initial begin
        // 打印信号变化，方便观察
        $monitor("time=%0t | ExtCtrl=%b | in_data=%h | out_data=%h", 
                  $time, ExtCtrl, in_data, out_data);

        // 测试 1：零扩展
        in_data = 16'h1234; ExtCtrl = 1'b0; // 正数，0扩展
        #10;
        
        // 测试 2：符号扩展
        in_data = 16'h1234; ExtCtrl = 1'b1; // 正数，符号扩展
        #10;

        // 测试 3：零扩展
        in_data = 16'hF234; ExtCtrl = 1'b0; // 负数，但0扩展
        #10;

        // 测试 4：符号扩展
        in_data = 16'hF234; ExtCtrl = 1'b1; // 负数，符号扩展
        #10;

        $finish;
    end

endmodule
