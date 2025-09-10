`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/09/05 18:51:27
// Design Name: 
// Module Name: tb_top_cpu
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

module tb_top_cpu;

    reg clk;
    reg rst;
    wire [31:0] pc_out, instruct;
    wire [31:0] reg1_val, reg2_val, reg3_val;
    wire [31:0] ALU_result, op1, op2, ALUOut, write_data, read_data2;
    wire [5:0] opcode, func;
    wire IRRead, PCWrite, ALUWrite, Mem2Reg, RegWrite, DataWrite, DataRead;
    wire [1:0] RegDst, PCSrcCtrl;
    wire zero;
    wire [25:0] addr;

    // 实例化 top_cpu
    top_cpu top_cpu (
        .clk(clk),
        .rst(rst),
        .pc_out(pc_out),
        .zero(zero),
        .instruct(instruct),
        .reg1_val(reg1_val),
        .reg2_val(reg2_val),
        .reg3_val(reg3_val),
        .ALU_result(ALU_result),
        .op1(op1),
        .op2(op2),
        .RegDst(RegDst),
        .PCSrcCtrl(PCSrcCtrl),
        .ALUOut(ALUOut),
        .write_data(write_data),
        .read_data2(read_data2),
        .opcode(opcode),
        .func(func),
        .IRRead(IRRead),
        .PCWrite(PCWrite),
        .ALUWrite(ALUWrite),
        .RegWrite(RegWrite),
        .Mem2Reg(Mem2Reg),
        .DataRead(DataRead),
        .DataWrite(DataWrite),
        .addr(addr)
    );
    
   //assign top_cpu.dp.pc_next = 32'b0;  //仿真初期初始化pc
    
    //输入的指令
    /*initial begin
    #5;  // 稍微等一下，保证模块已经建立
    // 假设 IM 在顶层是 IM0
    top_cpu.dp.IM.IM[0] = 32'h20010005;  // addi $1,$0,5
    top_cpu.dp.IM.IM[1] = 32'h20020003;  // addi $2,$0,3
    top_cpu.dp.IM.IM[2] = 32'h00221820;  // add  $3,$1,$2
    top_cpu.dp.IM.IM[3] = 32'hac030000;  // sw   $3,0($0)
    top_cpu.dp.IM.IM[4] = 32'h8c040000;  // lw   $4,0($0)
    // ……
    end*/
   
    //assign top_cpu.dp.PCWrite = 1; //pc写使能


    // 产生时钟：周期 20ns (50MHz)
    initial begin
        clk = 0;
        forever #10 clk = ~clk;
    end

    // 产生复位
    initial begin
        rst = 0;
        #5
        rst = 1;
        #20;          // 复位保持 50ns
        rst = 0;      // 释放复位
    end

    // 仿真结束时间
    initial begin
        #2000;  // 仿真 2000ns
        $stop;  // 停止仿真
    end
    
    initial begin
        $monitor("time=%0t, DM[0]=%h, regs[4]=%h, regs[6]=%h", $time, top_cpu.dp.DM.DM[0], top_cpu.dp.reg_file.regs[4], top_cpu.dp.reg_file.regs[6]);
    end
    
endmodule
