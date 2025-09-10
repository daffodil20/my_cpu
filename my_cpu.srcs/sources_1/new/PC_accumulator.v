`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/08/23 08:19:58
// Design Name: 
// Module Name: PC_accumulator
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


module PC_accumulator( //pc累加器，计算顺序执行的下一个地址
    input [31:0] pc_current, //当前PC和加数
    input pc_acc_en, //pc累加器的使能信号
    output reg [31:0] pc_plus_4
    //output [31:0] pc_plus_4
);

//assign pc_plus_4 = pc_current + 3'd4 if ; //下一个指令的PC

always @* begin
    case (pc_acc_en)
        1'b0: pc_plus_4 = pc_current; //pc不变
        1'b1: pc_plus_4 = pc_current + 3'd4;
    endcase
end

endmodule
