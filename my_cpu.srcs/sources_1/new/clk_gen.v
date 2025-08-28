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


/*module clk_gen( //时钟发生器
    input clk, rst, //主时钟信号
    output reg fetch, DM_ena //对clk分频，取指和访存时间较长
);
    // 内部计数器，用于生成分频时钟和控制信号
    // 由于是8分频，需要一个计数到7的计数器 (3 bits, 0-7)
    reg [2:0] fetch_counter; // 计数器
    reg [1:0] DM_counter;

    // always 块用于同步逻辑：在时钟上升沿更新计数器和输出
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // 复位时，计数器清零，所有输出信号也清零
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

    // 内部计数器，用于实现8分频。
    // 3位计数器 (0-7)，正好覆盖8个clk周期
    //reg [2:0]  clk_div_cnt;
    integer counter;

    // 同步时序逻辑：在时钟上升沿或复位时触发
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // 复位时，计数器和所有输出信号清零
            //clk_div_cnt <= 3'd0;
            counter = 0;
            fetch <= 1'b0;
            DM_ena <= 1'b0;
        end else begin
            // 计数器递增
            // 当计数器达到 7 时，自动回绕到 0
            //clk_div_cnt <= clk_div_cnt + 1'b1;
            counter = counter + 1;
            // 根据计数器值生成 fetch 信号
            // 计数器从 1 到 4 时，fetch 为高电平（4个clk周期）

            if (counter < 5) begin
                fetch <= 1'b1;
            end else begin
                fetch <= 1'b0;
            end

            // 根据计数器值生成 DM_ena 信号
            // 计数器从 7 到 8 时，DM_ena 为低电平（2个clk周期）
            if (counter < 9 & counter > 6) begin
                DM_ena <= 1'b1;
            end else begin
                // 其他时候都为低电平
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

    // 内部计数器，用于实现9个时钟周期循环。
    // 计数从 0 到 8 (共9个状态)。需要4位来表示 8 (binary 1000).
    reg [3:0] cycle_counter;

    // 同步时序逻辑：在时钟上升沿或复位时触发
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // 复位时，计数器和所有输出信号清零
            cycle_counter <= 4'd0;
            fetch         <= 1'b0;
            DM_ena        <= 1'b0;
        end else begin
            // 计数器递增，并在达到 8 时回绕到 0。
            // 这样实现 0 到 8 的 9 个周期循环。
            cycle_counter <= (cycle_counter == 4'd8) ? 4'd0 : cycle_counter + 1'b1;

            // 根据计数器值生成 fetch 信号
            // "1-4时钟周期" 对应 cycle_counter 的值 0, 1, 2, 3 (共4个周期)
            if (cycle_counter >= 4'd0 && cycle_counter <= 4'd3) begin
                fetch <= 1'b1;
            end else begin
                fetch <= 1'b0;
            end

            // 根据计数器值生成 DM_ena 信号
            // "7-8时钟周期" 对应 cycle_counter 的值 6, 7 (共2个周期)
            if (cycle_counter >= 4'd6 && cycle_counter <= 4'd7) begin
                DM_ena <= 1'b1;
            end else begin
                DM_ena <= 1'b0;
            end
        end
    end

endmodule


