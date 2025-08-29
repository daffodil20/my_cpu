`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/08/28 09:05:16
// Design Name: 
// Module Name: data_path
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


module data_path(
    input clk, rst,
    // 输入控制信号
    input         PCWrite, RegWrite, WriteData, //寄存器堆读写数据
    input         MemRead, MemWrite, //内存读写
    
    input  [1:0]  PCSrc,
    input         MemtoReg, RegDst,
    input  [1:0]  ALUSrcBCtrl,
    input  [3:0]  ALUCtrl,

    // 输出给控制单元
    output [31:0] instruct, //输出当前指令
    output zero
    
);

wire [31:0] pc_next_in, pc_out;
//wire [4:0] read_addr1, read_addr2;
wire [31:0] write_data;
//wire [31:0] op1, op2; //ALU运算数
wire [31:0] ALU_result;
//wire ALUCtrl, zero;

reg [15:0] in_data, out_data;
wire [31:0] branch_addr, jump_addr, pc_current, pc_adder, pc_plus_4; //pc多路选择器
//wire [1:0] PCSrcCtrl, ALUSrcBCtrl;
reg [31:0] pc_next;

 //实例化模块
pc_acc PC_accumulator ( //pc寄存器，计算顺序执行时下一个pc
   .pc_current(pc_out),
   .pc_plus_4(pc_plus_4)
);

 
PC pc( //pc寄存器，锁存pc
   .clk(clk),
   .PCWrite(PCWrite),
   .pc_next_in(pc_next),
   .pc_out(pc_out)
);

reg [4:0] rs;    // 源寄存器1



 //branch_addr = pc_plus_4 + 
 
reg IRRead; //读取指令的控制信号
//reg [31:0] instruct; //待拆分的32位指令，指令拆分后会进入主控制器
reg [5:0] opcode;  // 操作码

reg [4:0] rt;      // 源寄存器2 / 目的寄存器
reg [4:0] rd;     // 目的寄存器（R 型）
reg [4:0] shamt;  // 移位量
reg [5:0] func;   // 功能码（R 型）
reg [15:0] imm;    // 立即数（I 型）
reg [25:0] addr;    // 跳转地址（J 型） 
reg [4:0] read_addr1;    // 源寄存器1
reg [4:0] read_addr2;

instruct_reg IR( //IR分解指令为本不同字段
   .instruct(instruct),
   .opcode(opcode),
   .rs(rs),
   .rt(rt),
   .rd(rd),
   .shamt(shamt),
   .func(func),
   .imm(imm),
   .addr(addr)
);




reg ExCtrl;
wire [31:0] op1, op2, read_data1, read_data2;

//imm字段符号或0扩展
ext_unit ext_unit(
    .in_data(imm),
    .ExCtrl(ExCtrl),
    .out_data(out_data)
);
//wire [31:0] branch_addr, jump_addr; //分支和跳转目标地址

assign branch_addr = pc_plus_4 + out_data << 2; //beq,bne指令
assign jump_addr = {pc_plus_4[31:28], instruct[25:0], 2'b00}; //jal,j指令

PCSrc_mux pcSrc_mux (
    .pc_plus_4(pc_plus_4),
    .branch_addr(branch_addr),
    .jump_addr(jump_addr),
    .rs(rs),
    .PCSrcCtrl(PCSrc), //控制单元发出的控制信号列输入到mux，成为PCSrcCtrl
    .pc_next(pc_next) //输出下一个pc，送回pc寄存器
 );

//input [15:0] in_data,
   // input ExtCtrl, //扩展方式的控制信号
    //output wire [31:0] out_data
    
    
   
//assign pcSrc_mux.pc_next = pc_next;  //mux选择pcnext
//assign pc.pc_next_in = pcSrc_mux.pc_next; //所存下一个pc

// 寄存器堆
//assign read_addr1 = 0;
//assign read_addr2 = 0; //地址默认是0
/*always @* begin
    case (opcode)
        6'b000000: begin 
            if (rs == 5'b00000) begin //R型指令2个地址
                read_addr1 = rs;
                read_addr2 = rt; 
            end else begin //srl,sra,sll
                read_addr1 = rs; //
                op2 = shamt; //第二个运算数是shamt
                //assign read_addr2 = rt; 
            end
        end
        6'b000010: begin
            op1 = address;
            op2 = 2;
        
            
        default: begin //I型指令
            assign read_addr1 = rs;
            assign op2 = out_data; //第二个运算数是扩展后的imm
        end
     endcase
end*/

always @* begin
    case (opcode)
        6'b000000: begin // R型
             if (func == 6'b000000 || func == 6'b000010 || func == 6'b000011 || //sll,srl,sra,sllv,srlv,srav
                 func == 6'b000100 || func == 6'b000110 || func == 6'b000111) begin
                 read_addr1 = rt;
                 read_addr2 = rs;
             end else begin //其他情况第一个地址是rs
                read_addr1 = rs;
                read_addr2 = rt;
             end
            /*case (func)
                6'000000,
                6'000010,
                6'000011,
                6'000100,
                6'000110,
                6'000111: begin
                    read_addr1 = rt;
                    read_addr2 = rs;
                end
                default: begin //其他情况第一个地址是rs
                    read_addr1 = rs;
                    read_addr2 = rt;
                end
            endcase*/
        end
        default: begin // I型
            read_addr1 = rs;
            read_addr2 = rt; // 寄存器堆依然读 rt，输出可能不用
        end
    endcase
end
   

//assign read_addr2 = rt;
register_file reg_file (
        .clk(clk),
        .rst(rst),
        .read_addr1(read_addr1),
        .read_addr2(read_addr2),
        .RegWrite(RegWrite),
        .read_data1(read_data1),
        .read_data2(read_data2),       
        .write_data(write_data)
);


// 临时寄存器存储读取的数据，然后进入mux选择
tmp_reg reg_A(
     .clk(clk),
     .rst(rst),
     .in_data(read_data1),
     .out_data(op1)
);

tmp_reg reg_B(
     .clk(clk),
     .rst(rst),
     .in_data(read_data2),
     .out_data(op2)
);

//实例化多路选择器
ALUSrcB_mux alu_srcb_mux(
    .regB(read_data2),         // 临时寄存器B输出
    .shamt(shamt),
    .ext_data(out_data), // 扩展后的立即数
    .ALUSrcBCtrl(ALUSrcBCtrl),
    .ALU_in_2(op2)       // ALU 第二个操作数
);

// ALU
ALU alu(
    .a(op1),
    .b(op2),
    .ALUCtrl(ALUCtrl),
    .result(ALU_result),
    .zero(zero)
);


endmodule