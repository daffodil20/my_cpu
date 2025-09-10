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
    input PCWrite, RegWrite, pc_acc_en,//寄存器堆读写数据
    input IRRead, ALUWrite,
    input DataWrite, DataRead, DRWrite,//内存读写
    
    input  [1:0]  PCSrcCtrl,
    input  [1:0]  RegDst,
    input  Mem2Reg, ExtCtrl,
    input  [1:0]  ALUSrcBCtrl,
    input  [3:0]  ALUCtrl,

    // 输出给控制单元
    output [31:0] instruct, pc_out, //输出当前指令和当前pc
    output zero,
    output [5:0] opcode, func, //因为控制单元需要指令字段信息
    output [31:0] reg1_val, reg2_val, reg3_val, //探测通用寄存器的内容
    output [31:0] ALU_result,
    output [31:0] op1, op2, ALUOut, read_data2, write_data,
    output [25:0] addr
);

wire [31:0] pc_next_in;
//wire [4:0] read_addr1, read_addr2;
//wire [31:0] write_data;
//wire [31:0] op1, op2; //ALU运算数
//wire [31:0] ALU_result;
//wire ALUCtrl, zero;

wire [31:0] in_data, out_data;
wire [31:0] branch_addr, jump_addr, pc_current, pc_adder, pc_plus_4; //pc多路选择器
//wire [1:0] PCSrcCtrl, ALUSrcBCtrl;
wire [31:0] pc_next;

 //实例化模块
PC_accumulator pc_acc( //pc寄存器，计算顺序执行时下一个pc
   .pc_current(pc_out),
   .pc_acc_en(pc_acc_en),
   .pc_plus_4(pc_plus_4)
   
);

PC pc( //pc寄存器，锁存pc
   .clk(clk),
   .rst(rst),
   .PCWrite(PCWrite),
   .pc_next_in(pc_next),
   .pc_out(pc_out)
);

wire [4:0] rs;    // 源寄存器1

 //branch_addr = pc_plus_4 + 
 
//reg IRRead; //读取指令的控制信号
//reg [31:0] instruct; //待拆分的32位指令，指令拆分后会进入主控制器
//wire [5:0] opcode;  // 操作码
wire [4:0] rt;      // 源寄存器2 / 目的寄存器
wire [4:0] rd;     // 目的寄存器（R 型）
wire [4:0] shamt;  // 移位量
//wire [5:0] func;   // 功能码（R 型）
wire [15:0] imm;    // 立即数（I 型）
//wire [25:0] addr;    // 跳转地址（J 型） 
reg [4:0] read_addr1;    // 源寄存器1
reg [4:0] read_addr2;

instruct_mem IM( //实例化指令存储器
   .instruct_addr(pc_out),
   .instruct_data(instruct)
);

instruct_reg IR( //IR分解指令为本不同字段
   .clk(clk),
   .rst(rst),
   .IRRead(IRRead),
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


//reg ExCtrl;
//wire [31:0] op1, op2, read_data1, read_data2;
wire [31:0] read_data1;

//imm字段符号或0扩展
ext_unit ext_unit(
    .in_data(imm),
    .ExtCtrl(ExtCtrl),
    .out_data(out_data)
);
//wire [31:0] branch_addr, jump_addr; //分支和跳转目标地址

assign branch_addr = pc_plus_4 + (out_data << 2); //beq,bne指令
assign jump_addr = {pc_plus_4[31:28], addr, 2'b00}; //jal,j指令

PCSrc_mux pcSrc_mux (
    .pc_plus_4(pc_plus_4),
    .branch_addr(branch_addr),
    .jump_addr(jump_addr),
    .rs(op1),
    .PCSrcCtrl(PCSrcCtrl), //控制单元发出的控制信号列输入到mux，成为PCSrcCtrl
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
        default: begin // I型，包括beq,bne
            read_addr1 = rs;
            read_addr2 = rt; // 寄存器堆依然读 rt，输出可能不用
        end
    endcase
end
   
wire [31:0] data_wb; //待写回寄存器的数据，来自ALU或DM。即内存
wire [4:0] write_addr;

//assign read_addr2 = rt;
register_file reg_file (
        .clk(clk),
        .rst(rst),
        .read_addr1(read_addr1),
        .read_addr2(read_addr2),
        .write_addr(write_addr),
        .write_data(data_wb),
        .RegWrite(RegWrite),
        .read_data1(read_data1),
        .read_data2(read_data2),
        .reg1_val(reg1_val),
        .reg2_val(reg2_val), 
        .reg3_val(reg3_val)       
         //Mem2Reg_mux的输出连到这里
);


// 临时寄存器存储读取的数据，然后进入mux选择
wire [31:0] regB_val;
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
     .out_data(regB_val)
);

//实例化多路选择器
ALUSrcB_mux alu_srcb_mux(
    .regB(regB_val),         // 临时寄存器B输出
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
    .zero_flag(zero)
);

wire [31:0] alu_result_final;
wire [31:0] lui_result;
//wire [31:0] ALUOut; //由模块驱动，用wire

assign lui_result = {imm, 16'b0}; //临时存储lui结果
assign alu_result_final = (opcode == 6'b001111) ? lui_result : ALU_result; //是否是lui

ALUOut aluOut( 
    .ALUResult(alu_result_final), //锁存最终结果
    .clk(clk),
    .rst(rst),
    .ALUWrite(ALUWrite),
    .ALUOut(ALUOut)
);
//lui指令 特殊处理
//wire [31:0] lui_addr; 
//assign lui_addr = {imm, 16'b0};
/*ways @* begin
    if (opcode == 6'b001111) begin
        ALUOut = {imm, 16'b0};
    end   
end*/

wire [31:0] read_data_addr, write_data_addr; //读取和写入数据的地址
//wire [31:0] write_data;
wire [31:0] read_data;
//wire [31:0] DataWrite, DataRead;
//reg [31:0] read_data_addr, write_data_addr;
//数据存储器DM
data_mem DM(
    .clk(clk),
    .read_addr(ALUOut), //读数据地址
    .write_addr(ALUOut), //写数据地址，即ALUOut
    .write_data(read_data2), //写入内存的数据，即rt内容，read_data2
    .read_data(read_data), 
    .DataWrite(DataWrite), //读取和写入控制信号
    .DataRead(DataRead)
);
//wire Mem2Reg; //控制信号

//slt,sltu(R
/*if (opcode = 6'b000000 && (func = 6'b101010 || func = 6'b101011) && ALUOut < 0) begin
    ALUOut = 1; //写回寄存器的是1
end
if (opcode = 6'b000000 && (func = 6'b101010 || func = 6'b101011) && ALUOut >= 0) begin
    ALUOut = 0; //写回寄存器的是0
end

//slti,sltiu(I)
if (opcode == 6'b001010 && ALUOut < 0) begin
    assign ALUOut = 1; //写回寄存器的是1
end
if (opcode = 6'b001011 && ALUOut >= 0) begin
    ALUOut = 0; //写回寄存器的是1
end*/

Mem2Reg_mux mem2reg_mux( //写回的数据来自ALU还是内存
    .ALUOut(ALUOut),
    .MDR_data(write_data),
    .Mem2Reg(Mem2Reg),
    .write_data(data_wb)
);

data_reg DR(
    .clk(clk),
    .rst(rst),
    .DRWrite(DRWrite),
    .in_data(read_data), //从内存加载的数据
    .out_data(write_data) //输入到mux
);




//case (opcode)
   // 6b'100011: write_addr = read_addr2; //写入rt
        
RegDst_mux RegDst_mux(  //选择写入寄存器堆的地址
    .rd(rd),
    .rt(rt),
    .RegDst(RegDst),
    .write_addr(write_addr) //写入内存的数据的地址，即rt
);


endmodule