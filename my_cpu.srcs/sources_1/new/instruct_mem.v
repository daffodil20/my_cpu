`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/08/16 10:36:44
// Design Name: 
// Module Name: instruct_mem
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


module instruct_mem(
    input [31:0] instruct_addr, //指令地址
    output [31:0] instruct_data //读取到的指令
);

reg [31:0] IM [0:1023]; //1024个指令存放在指令存储器
integer i;

 initial begin
        // 手动写几条指令，或者从文件加载
        IM[0] = 32'h20010005;  // addi $1,$0,5
        IM[1] = 32'h20020003;  // addi $2,$0,3
        IM[2] = 32'h00221820;  // add  $3,$1,$2
        IM[3] = 32'hac030000;  // sw   $3,0($0)
        IM[4] = 32'h8c040000;  // lw   $4,0($0)
        
         // BEQ 示例：如果 $1==$2，跳转到 IM[7] (偏移=2，注意 MIPS 偏移单位是指令数)
        IM[5] = 32'h10220002;  // beq $1,$2, label  (label在IM[8])

        // BNE 示例：如果 $1!=$2，跳转到 IM[8] (偏移=1)
        IM[6] = 32'h14220001;  // bne $1,$2, label2 (label2在IM[8])
        
        
        // ADDI 示例，用于修改寄存器
        IM[7] = 32'h20050001;  // addi $5,$0,1

        // J 指令示例：跳转到 IM[10]
        IM[8] = 32'h0800000a;  // j 10  (地址=10<<2)

        // NOP 或其他操作
        IM[9] = 32'h00000000;  // nop
        IM[10] = 32'h20060002; // addi $6,$0,2
        // 其余的清零
        
        for (i = 11; i < 256; i = i + 1)
            IM[i] = 32'b0;
            
end

assign instruct_data = IM[instruct_addr[11:2]]; //选出1024条条指令的索引，低2位一直是00，没有用

endmodule
