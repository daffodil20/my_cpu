`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/08/15 15:30:09
// Design Name: 
// Module Name: PC
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


module PC(
     input wire clk, rst,
     input wire PCWrite, //写PC的控制信号
     input wire [31:0] pc_next_in,
     output wire [31:0] pc_out
);
reg [31:0] pc_reg;
always @(posedge clk or posedge rst) begin
     if (rst) begin
        pc_reg <= 32'b0; //异步复位，把PC清零
     end else if (PCWrite) begin //写有效时，时钟上升沿更新PC，加载PC地址到reg中
        pc_reg <= pc_next_in;
     end
end
// 将内部寄存器迅速连接到输出端口， 不等待时钟信号，随时更新输出
// 这是一个组合逻辑赋值
assign pc_out = pc_reg;
endmodule