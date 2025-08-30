`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/08/21 08:44:47
// Design Name: 
// Module Name: ctrl_unit
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
//定义状态编码
/*parameter S1_IF1  = 5'd1, //访问IM
           S2_IF2  = 5'd2,
           S3_IF3  = 5'd3,
           S4_ID   = 5'd4,
           S5_EX_R = 5'd5,
           S6_WB_R = 5'd6,
           S7_EX_I_ALU = 5'd7, //I型运算指令，包括lw,sw
           S8_WB_I_ALU = 5'd8,
           //S9_EX_LS = d9, //lw,sw执行
           S9_LS_LW = 5'd9, //lw访存
           S10_LS_LW = 5'd10, //lw访存
           S11_LS_SW = 5'd11, //sw访存
           S12_LS_SW = 5'd12, //sw访存
           S13_WB_LW = 5'd13,
           S14_EX_BR = 5'd14, //分支指令beq,bne执行
           S15_EX_J = 5'd15,
           S16_EX_JAL = 5'd16, //jal执行
           S17_EX_JR = 5'd17,
           S18_WB_JAL = 5'd18 //jal写回*/
           
/*module ctrl_unit #(
     parameter S1_IF_ID1 = 5'd1, //访问IM
     parameter S2_IF2  = 5'd2,
     parameter S3_ID  = 5'd3,
     //parameter S4_ID   = 5'd4,
     parameter S4_EX_R = 5'd4,
     parameter S5_WB_R = 5'd5,
     parameter S6_EX_I_ALU = 5'd6, //I型运算指令，包括lw,sw
     parameter S7_WB_I_ALU = 5'd7,
           //S9_EX_LS = d9, //lw,sw执行
     parameter S8_LS_LW = 5'd8,//lw访存
     parameter S9_LS_LW = 5'd9, //lw访存
     //parameter      S10_LS_SW = 5'd10, //sw访存
     
     parameter S10_WB_LW = 5'd10, //lw写回
     parameter S11_LS_SW = 5'd11, //sw访存
     parameter S12_EX_BR = 5'd12, //分支指令beq,bne执行
     parameter S13_EX_JAL_J = 5'd13, //jal,j执行
     //parameter      S15_EX_JAL = 5'd15, //jal执行
     parameter      S14_WB_JAL = 5'd14, //jal写回$31
     parameter      S15_EX_JR = 5'd15, //jr指令执行
     parameter      S16_PC_JAL = 5'd16 //jalgengxin PC
) (input clk, rst,
     input [4:0] opcode, func,
     output IMRead, IRWrite, PCWrite, RegWrite, DataRead, DataWrite, ALUWrite, Mem2Reg, ExtCtrl, zero,
     output [1:0] PCSrcCtrl, ALUSrcBCtrl, RegDst,
     output [3:0] ALUCtrl
);     

reg [4:0] state, next_state; //定义当前状态和下一个状态
always @(posedge clk or posedge rst) begin //状态寄存器
    if (rst) begin
        state <= S1_IF_ID1;
    end else begin
        state <= next_state; //状态改变
    end
end

//根据state和opcode/func决定next_state
always @(*) begin
/*    IMRead    = 0;
    IRWrite   = 0;
    PCWrite   = 0;
    RegWrite  = 0;
    DataRead  = 0;
    DataWrite = 0;
    ALUWrite  = 0;*/
    /*case (state)
        //S0_IF0:  next_state = S1_IF1;
        S1_IF_ID1:  next_state = S2_IF2;
        S2_IF2:  next_state = S3_ID;
        //S3_ID:  next_state = S4_ID;
        
        S3_ID: begin
            case (opcode) //根据op和func译码
            
                6'b000000: begin
                    if (func != 6'b001000) begin
                        next_state = S4_EX_R; //非jr的其他R型指令执行
                    end else begin 
                        next_state = S15_EX_JR; //jr执行
                    end
                end
                
                //6'b100011: next_state = S9_EX_LS, //lw执行
                //6'b101011: next_state = S9_EX_LS, //sw执行
                6'b100011, //lw
                6'b101011, //sw
                6'b001000, //多个I型运算指令执行，包括lw,sw，不包括bne,beq
                6'b001001,
                6'b001100,
                6'b001101,
                6'b001111,
                6'b001010,
                6'b001011: 
                    next_state = S6_EX_I_ALU;
                
                6'b000100,
                6'b000101:
                    next_state = S12_EX_BR; //分支执行beq,bne
                6'b000010,
                6'b000011:
                    next_state = S13_EX_JAL_J; //j,jal指令执行
                
                    //next_state = S13_EX_JAL; //jal指令执行
                default: next_state = S4_EX_R;
            endcase
         end
         
         S4_EX_R: next_state = S5_WB_R; //R型指令写回rd
         S5_WB_R: next_state = S1_IF_ID1;
         
         S6_EX_I_ALU: begin //I型运算执行，不包括bne,beq
             if (opcode == 6'b100011) begin
                 next_state = S8_LS_LW; //lw访存第一个时钟周期
             end else if (opcode == 6'b101011) begin
                 //6'b100011:  
                 next_state = S11_LS_SW; //sw访存第一个时钟周期
                 //next_state = S0_IF0; 
             end else begin
                 next_state = S1_IF_ID1; //其他I型运算指令回到取指
             end
         end        
         //next_state = S8_WB_I_ALU;
         S7_WB_I_ALU: next_state = S1_IF_ID1; //I型指令写回rt
         S8_LS_LW: next_state = S9_LS_LW; //lw访存 2T
         S9_LS_LW: next_state = S10_WB_LW; //lw写回rt
         //S11_LS_SW: next_state = S1_IF_ID1; //sw访存第二个时钟周期

         S10_WB_LW: next_state = S1_IF_ID1;         
         //next_state = S0_IF1; //回到取指状态
         
         /*S9_EX_LS: begin
             if (opcode == 100011) begin
                 next_state = S10_LS_LW; //lw访存
             end
             else if (opcode == 101011) begin
                 next_state = S12_LS_SW; //sw访存
             end
         end*/
         
         //S9_WB_W: next_state = S1_IF_ID1; //lw写回
         //S11_LS_LW: next_state = S13_WB_LW; 
         /*S11_LS_SW: next_state = S1_IF_ID1; //sw访存第二个时钟周期

         //S12_WB_LW: next_state = S0_IF0;
         //S13_LS_SW: next_state = S0_IF0;
         S12_EX_BR: begin
             case (zero)
                 1'b1: next_state = S16_PC_JAL;
                 1'b0: next_state = S1_IF_ID1;
             endcase
         end
         //next_state = S1_IF_ID1;    //分支执行后回到取指状态
         S13_EX_JAL_J: next_state = S1_IF_ID1;
         //S16_EX_JAL: next_state = S18_WB_JAL; //jal写回$31
         
         S14_WB_JAL: next_state = S1_IF_ID1; 
         S15_EX_JR: next_state = S1_IF_ID1; 
         S16_PC_JAL: next_state = S1_IF_ID1; 
          
         default: next_state = S1_IF_ID1;
   endcase
end
 
//生成控制信号
always @(*) begin
    case (state)
        /*S0_IF0: begin
            IMRead = 1; //从IM读取指令
            IRWrite = 0;*/
        //end
        /*S1_IF_ID1: begin
            //IMRead = 1; //
            IRWrite = 1'b1; //从IM读取指令存入IR，同步输出多个字段（译码），
        end
        S2_IF2: begin   
            //IMRead = 0; //
            IRWrite = 0;
            PCWrite = 1; //PC自增
        end
        S3_ID: begin//取指令写回IR
            
            PCSrcCtrl = 00;
            ALUSrcACtrl = 0;
            ALUSrcBCtrl = 00;
            //pc_plus_4 = PC; //pc_plus_
            //(PC) = (PC) + 4，控制第二个运算数是+4
            PCSrcCtrl = 2'b00; //PC加法器的第一个选择
        end*/
        /*S3_ID: begin //异步读取reg file的寄存器，同步存放数据入reg A,B ;生
            case (opcode) //提前扩展imm/offset
                
                6'b100011,
                6'b101011,
                6'b000100,
                6'b000101,
                6'b001010: begin
                    ExtCtrl = 1; //符号扩展
                end
                6'b001000,
                6'b001001: begin
                    PCSrcCtrl = 2'b01; //分支指令pc控制，branch_addr存储分支目标地址
                    ExtCtrl = 1; //符号扩展
                end
                6'b001100,
                6'b001101,
                6'b001110,
                6'b001011,
                6'b000010:
                //jal
                    ExtCtrl = 0; //0扩展 
                6'b000011: begin
                    PCSrcCtrl = 2'b00; //jal指令pc控制
                    ExtCtrl = 0; //0扩展
                end
                default: ExtCtrl = 0;
            endcase
            
                      
        end
        
        S4_EX_R: begin //R型指令运算
           PCWrite = 0;
           IRWrte = 0;
           case (func) //根据func判断运算类型，决定控制信号
               6'b100000,
               6'b100001: begin
                   ALUCtrl = 4'b0000; //add
                   ALUSrcBCtrl = 2'b00; //第2个运算数是(rt)
               end
               6'b100010,
               6'b100011: begin
                   ALUCtrl = 4'b0001; //sub
                   ALUSrcBCtrl = 2'b00; //第2个运算数是(rt)
               end  
               6'b100100: begin
                   ALUCtrl = 4'b0010; //and
                   ALUSrcBCtrl = 2'b00; //第2个运算数是(rt)
               end
               6'b100101: begin
                   ALUCtrl = 4'b0011; //or
                   ALUSrcBCtrl = 2'b00; //第2个运算数是(rt)
               end
               6'b100110: begin
                   ALUCtrl = 4'b0100; //xor
                   ALUSrcBCtrl = 2'b00; //第2个运算数是(rt)  
               end    
               6'b100111: begin
                   ALUCtrl = 4'b0101; //nor    
                   ALUSrcBCtrl = 2'b00; //第2个运算数是(rt)
               end
               6'b000000: begin
                   ALUCtrl = 4'b0110; //左移
                   ALUSrcBCtrl = 2'b10; //第2个运算数是shamt
               end
               6'b000100: begin
                   ALUCtrl = 4'b0110; //左移
                   ALUSrcBCtrl = 2'b10;
               end    
               6'b000010,
               6'b000110: begin
                   ALUCtrl = 4'b0111; //逻辑右移
               end
               6'b000011,
               6'b000111: begin
                   ALUCtrl = 4'b1000; //算术右移
               end
               default: ALUCtrl = 4'b0000; 
           endcase
           ALUWrite = 1; //ALUOut
         end
              
         S5_WB_R: begin //R型指令写回
            RegWrite = 1; //写寄存器使能         
            RegDst = 2'b00; //写回到rd
            Mem2Reg = 0; //写入数据来自ALU
            ALUWrite = 0;  
         end
            
         S6_EX_I_ALU: begin
           PCWrite = 0;
           IRWrte = 0;
           ALUSrcBCtrl = 2'b01; //第2个运算数是ext_imm
           case (opcode) //根据func判断运算类型，决定控制信号
               6'b001000,
               6'b001001,
               6'b100011, //lw,sw
               6'b101011,
               6'b100011,
               6'b101011: //包括lw,sw
                   ALUCtrl = 4'b0000; //addi,addiu
                   
               6'b001100: ALUCtrl = 4'b0010; //andi
               6'b001101: ALUCtrl = 4'b0011; //ori
               6'b001110: ALUCtrl = 4'b0100; //xori
               
               6'b001010,
               6'b001011: ALUCtrl = 4'b0001; //slti,sltiu
               default: ALUCtrl = 4'b0000; 
           endcase
           ALUWrite = 1; //ALUOut临时存储结果
         end
         
         
         S7_WB_I_ALU: begin
            RegWrite = 1; //写寄存器使能
            RegDst = 2'b01; //写回到rt
            Mem2Reg = 0; //从ALUOut写寄存器
         end
         
         S8_LS_LW: begin //lw 1T
             DataRead = 0; //读内存使能
             DataWrite = 1;
         end
             
         S9_LS_LW: begin //lw 2T
             DataRead = 0; 
             DataWrite = 0;
             DRWrite = 1; //存入DR并输出
         end
         S10_LS_LW: begin //lw访存
             DataRead = 1; //读内存使能
             DataWrite = 0; 
             DataRead = 1; //从存储器输出
         end
         
         S10_WB_LW: begin
             DRWrite = 0;
             RegWrite = 1;
             RegDst = 2'b01;
             Mem2Reg = 1; //写入数据来自MDR
         end
            
         S11_LS_SW: begin //sw
             DataRead = 0; 
             DataWrite = 1; //只是准备，未写入数据
             RegDst = 0; //读取rt
             //ALUSrcBCtrl = 2'b01; //ALU的第二个运算数是扩展后的数据
         end
         
         S12_LS_SW: begin //sw访存
             DataRead = 0; 
             DataWrite = 1; //写内存使能
             //ALUSrcBCtrl = 2'b01; //ALU的第二个运算数是扩展后的数据
         end
         
       
         S12_EX_BR: begin
             ALUCtrl = 4'b0001; //sub
             case (opcode)
                 6'b000100: begin //beq
                     if (zero == 1) begin //相等
                         PCSrcCtrl = 2'b01;
                     end 
                     else if (zero == 0) begin
                         PCSrcCtrl = 2'b00;
                     end
                 end
                 6'b000101: begin //bne
                     if (zero == 0) begin //不相等
                         PCSrcCtrl = 2'b01;
                     end 
                     else if (zero == 1) begin
                         PCSrcCtrl = 2'b00;
                     end
                 end
             endcase
         end
         
         S13_EX_J: begin
             //ALUCtrl = 4'b0110; //左移
             PCSrcCtrl = 2'b10; //jump地址             
         end
         
         S13_EX_JAL_J: begin
             //ALUCtrl = 4'b0110; //左移
             PCSrcCtrl = 2'b10; //jump地址
             PCWrite = 1;           
         end
         
         S14_WB_JAL: begin
             RegDst = 2'b10; //jal写回$31寄存器
             RegWrite = 1; //写reg使能                           
         end
         
         S15_EX_JR: begin            
             RegWrite = 0; //读取rs
             PCWrite = 1;  //更新PC
             PCSrcCtrl = 2'b11; //(rs)
                                       
         end    
         
         S16_PC_JAL: begin
             PCWrite = 1; //同步更新PC
         end
   endcase     
end                            
endmodule*/
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/08/21 08:44:47
// Design Name: 
// Module Name: ctrl_unit
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
//定义状态编码
/*parameter S1_IF1  = 5'd1, //访问IM
           S2_IF2  = 5'd2,
           S3_IF3  = 5'd3,
           S4_ID   = 5'd4,
           S5_EX_R = 5'd5,
           S6_WB_R = 5'd6,
           S7_EX_I_ALU = 5'd7, //I型运算指令，包括lw,sw
           S8_WB_I_ALU = 5'd8,
           //S9_EX_LS = d9, //lw,sw执行
           S9_LS_LW = 5'd9, //lw访存
           S10_LS_LW = 5'd10, //lw访存
           S11_LS_SW = 5'd11, //sw访存
           S12_LS_SW = 5'd12, //sw访存
           S13_WB_LW = 5'd13,
           S14_EX_BR = 5'd14, //分支指令beq,bne执行
           S15_EX_J = 5'd15,
           S16_EX_JAL = 5'd16, //jal执行
           S17_EX_JR = 5'd17,
           S18_WB_JAL = 5'd18 //jal写回*/
           
module ctrl_unit #(
     parameter S1_IF_ID1 = 5'd1, //访问IM
     parameter S2_IF2  = 5'd2,
     parameter S3_ID  = 5'd3,
     //parameter S4_ID   = 5'd4,
     parameter S4_EX_R = 5'd4,
     parameter S5_WB_R = 5'd5,
     parameter S6_EX_I_ALU = 5'd6, //I型运算指令，包括lw,sw
     parameter S7_WB_I_ALU = 5'd7,
           //S9_EX_LS = d9, //lw,sw执行
     parameter S8_LS_LW = 5'd8,//lw访存
     parameter S9_LS_LW = 5'd9, //lw访存
     //parameter      S10_LS_SW = 5'd10, //sw访存
     
     parameter S10_WB_LW = 5'd10, //lw写回
     parameter S11_LS_SW = 5'd11, //sw访存
     parameter S12_EX_BR = 5'd12, //分支指令beq,bne执行
     parameter S13_EX_JAL_J = 5'd13, //jal,j执行
     //parameter      S15_EX_JAL = 5'd15, //jal执行
     parameter      S14_WB_JAL = 5'd14, //jal写回$31
     parameter      S15_EX_JR = 5'd15, //jr指令执行
     parameter      S16_PC_JAL = 5'd16 //jalgengxin PC
) (input clk, rst,
     input [4:0] opcode, func,
     output reg IMRead, IRRead, PCWrite, RegWrite, DataRead, DataWrite, ALUWrite, Mem2Reg, ExtCtrl, zero, DRWrite, IRWrite,
     output reg [1:0] PCSrcCtrl, ALUSrcBCtrl, RegDst,
     output reg [3:0] ALUCtrl
);     

reg [4:0] state, next_state; //定义当前状态和下一个状态
always @(posedge clk or posedge rst) begin //状态寄存器
    if (rst) begin
        state <= S1_IF_ID1;
    end else begin
        state <= next_state; //状态改变
    end
end

//根据state和opcode/func决定next_state
always @(*) begin
    IMRead    = 0; //控制信号重置
    IRWrite   = 0;
    PCWrite   = 0;
    RegWrite  = 0;
    DataRead  = 0;
    DataWrite = 0;
    ALUWrite  = 0;
    Mem2Reg = 0; ExtCtrl, zero
    case (state)
        //S0_IF0:  next_state = S1_IF1;
        S1_IF_ID1:  next_state = S2_IF2;
        S2_IF2:  next_state = S3_ID;
        //S3_ID:  next_state = S4_ID;
        
        S3_ID: begin
            case (opcode) //根据op和func译码
            
                6'b000000: begin
                    if (func != 6'b001000) begin
                        next_state = S4_EX_R; //非jr的其他R型指令执行
                    end else begin 
                        next_state = S15_EX_JR; //jr执行
                    end
                end
                
                //6'b100011: next_state = S9_EX_LS, //lw执行
                //6'b101011: next_state = S9_EX_LS, //sw执行
                6'b100011, //lw
                6'b101011, //sw
                6'b001000, //多个I型运算指令执行，包括lw,sw，不包括bne,beq
                6'b001001,
                6'b001100,
                6'b001101,
                6'b001111,
                6'b001010,
                6'b001011: 
                    next_state = S6_EX_I_ALU;
                
                6'b000100,
                6'b000101:
                    next_state = S12_EX_BR; //分支执行beq,bne
                6'b000010,
                6'b000011:
                    next_state = S13_EX_JAL_J; //j,jal指令执行
                
                    //next_state = S13_EX_JAL; //jal指令执行
                default: next_state = S4_EX_R;
            endcase
         end
         
         S4_EX_R: next_state = S5_WB_R; //R型指令写回rd
         S5_WB_R: next_state = S1_IF_ID1;
         
         S6_EX_I_ALU: begin //I型运算执行，不包括bne,beq
             if (opcode == 6'b100011) begin
                 next_state = S8_LS_LW; //lw访存第一个时钟周期
             end else if (opcode == 6'b101011) begin
                 //6'b100011:  
                 next_state = S11_LS_SW; //sw访存第一个时钟周期
                 //next_state = S0_IF0; 
             end else begin
                 next_state = S1_IF_ID1; //其他I型运算指令回到取指
             end
         end        
         //next_state = S8_WB_I_ALU;
         S7_WB_I_ALU: next_state = S1_IF_ID1; //I型指令写回rt
         S8_LS_LW: next_state = S9_LS_LW; //lw访存 2T
         S9_LS_LW: next_state = S10_WB_LW; //lw写回rt
         //S11_LS_SW: next_state = S1_IF_ID1; //sw访存第二个时钟周期

         S10_WB_LW: next_state = S1_IF_ID1;         
         //next_state = S0_IF1; //回到取指状态
         
         /*S9_EX_LS: begin
             if (opcode == 100011) begin
                 next_state = S10_LS_LW; //lw访存
             end
             else if (opcode == 101011) begin
                 next_state = S12_LS_SW; //sw访存
             end
         end*/
         
         //S9_WB_W: next_state = S1_IF_ID1; //lw写回
         //S11_LS_LW: next_state = S13_WB_LW; 
         S11_LS_SW: next_state = S1_IF_ID1; //sw访存第二个时钟周期

         //S12_WB_LW: next_state = S0_IF0;
         //S13_LS_SW: next_state = S0_IF0;
         S12_EX_BR: begin
             case (zero)
                 1'b1: next_state = S16_PC_JAL;
                 1'b0: next_state = S1_IF_ID1;
             endcase
         end
         //next_state = S1_IF_ID1;    //分支执行后回到取指状态
         S13_EX_JAL_J: next_state = S1_IF_ID1;
         //S16_EX_JAL: next_state = S18_WB_JAL; //jal写回$31
         
         S14_WB_JAL: next_state = S1_IF_ID1; 
         S15_EX_JR: next_state = S1_IF_ID1; 
         S16_PC_JAL: next_state = S1_IF_ID1; 
          
         default: next_state = S1_IF_ID1;
   endcase
end
 
//生成控制信号
always @(*) begin
    case (state)
        /*S0_IF0: begin
            IMRead = 1; //从IM读取指令
            IRWrite = 0;*/
        //end
        S1_IF_ID1: begin
            //IMRead = 1; //
            IRWrite = 1'b1; //从IM读取指令存入IR，同步输出多个字段（译码），
        end
        S2_IF2: begin   
            //IMRead = 0; //
            IRWrite = 0;
            PCWrite = 1; //PC自增
        end
        /*S3_ID: begin//取指令写回IR
            
            PCSrcCtrl = 00;
            ALUSrcACtrl = 0;
            ALUSrcBCtrl = 00;
            //pc_plus_4 = PC; //pc_plus_
            //(PC) = (PC) + 4，控制第二个运算数是+4
            PCSrcCtrl = 2'b00; //PC加法器的第一个选择
        end*/
        S3_ID: begin //异步读取reg file的寄存器，同步存放数据入reg A,B ;生
            case (opcode) //提前扩展imm/offset
                
                6'b100011,
                6'b101011,
                6'b000100,
                6'b000101,
                6'b001010: begin
                    ExtCtrl = 1; //符号扩展
                end
                6'b001000,
                6'b001001: begin
                    PCSrcCtrl = 2'b01; //分支指令pc控制，branch_addr存储分支目标地址
                    ExtCtrl = 1; //符号扩展
                end
                6'b001100,
                6'b001101,
                6'b001110,
                6'b001011,
                6'b000010:
                //jal
                    ExtCtrl = 0; //0扩展 
                6'b000011: begin
                    PCSrcCtrl = 2'b00; //jal指令pc控制
                    ExtCtrl = 0; //0扩展
                end
                default: ExtCtrl = 0;
            endcase
            
            
            /*case (func) //根据func判断运算类型，决定控制信号
               6'b100000,
               6'b100001: begin
                   ALUCtrl = 4'b0000; //add
                   ALUSrcBCtrl = 2'b00; //第2个运算数是(rt)
               end
               6'b100010,
               6'b100011: begin
                   ALUCtrl = 4'b0001; //sub
                   ALUSrcBCtrl = 2'b00; //第2个运算数是(rt)
               end
               6'b100100: begin
                   ALUCtrl = 4'b0010; //and
                   ALUSrcBCtrl = 2'b00; //第2个运算数是(rt)
               end
               6'b100101: begin
                   ALUCtrl = 4'b0011; //or
                   ALUSrcBCtrl = 2'b00; //第2个运算数是(rt)
               end
               6'b100110: 
                   ALUCtrl = 4'b0100; //xor
                   ALUSrcBCtrl = 2'b00; //第2个运算数是(rt)  
                   
               6'b100111: 
                   ALUCtrl = 4'b0101; //nor    
                   ALUSrcBCtrl = 2'b00; //第2个运算数是(rt)
               6'b000000:
                   ALUCtrl = 4'b0110; //左移
                   ALUSrcBCtrl = 2'b10; //第2个运算数是shamt
               6'b000100: 
                   ALUCtrl = 4'b0110; //左移
                   ALUSrcBCtrl = 2'b10;
                   
               6'b000010,
               6'b000110: 
                   ALUCtrl = 4'b0111; //逻辑右移
               6'b000011
               6'b000111:
                   ALUCtrl = 4'b1000; //算术右移
               defa  */             
        end
        
        S4_EX_R: begin //R型指令运算
           PCWrite = 0;
           IRWrite = 0;
           case (func) //根据func判断运算类型，决定控制信号
               6'b100000,
               6'b100001: begin
                   ALUCtrl = 4'b0000; //add
                   ALUSrcBCtrl = 2'b00; //第2个运算数是(rt)
               end
               6'b100010,
               6'b100011: begin
                   ALUCtrl = 4'b0001; //sub
                   ALUSrcBCtrl = 2'b00; //第2个运算数是(rt)
               end  
               6'b100100: begin
                   ALUCtrl = 4'b0010; //and
                   ALUSrcBCtrl = 2'b00; //第2个运算数是(rt)
               end
               6'b100101: begin
                   ALUCtrl = 4'b0011; //or
                   ALUSrcBCtrl = 2'b00; //第2个运算数是(rt)
               end
               6'b100110: begin
                   ALUCtrl = 4'b0100; //xor
                   ALUSrcBCtrl = 2'b00; //第2个运算数是(rt)  
               end    
               6'b100111: begin
                   ALUCtrl = 4'b0101; //nor    
                   ALUSrcBCtrl = 2'b00; //第2个运算数是(rt)
               end
               6'b000000: begin
                   ALUCtrl = 4'b0110; //左移
                   ALUSrcBCtrl = 2'b10; //第2个运算数是shamt
               end
               6'b000100: begin
                   ALUCtrl = 4'b0110; //左移
                   ALUSrcBCtrl = 2'b10;
               end    
               6'b000010,
               6'b000110: begin
                   ALUCtrl = 4'b0111; //逻辑右移
               end
               6'b000011,
               6'b000111: begin
                   ALUCtrl = 4'b1000; //算术右移
               end
               default: ALUCtrl = 4'b0000; 
           endcase
           ALUWrite = 1; //ALUOut
         end
              
         S5_WB_R: begin //R型指令写回
            RegWrite = 1; //写寄存器使能         
            RegDst = 2'b00; //写回到rd
            Mem2Reg = 0; //写入数据来自ALU
            ALUWrite = 0;  
         end
            
         S6_EX_I_ALU: begin
           PCWrite = 0;
           IRWrite = 0;
           ALUSrcBCtrl = 2'b01; //第2个运算数是ext_imm
           case (opcode) //根据func判断运算类型，决定控制信号
               6'b001000,
               6'b001001,
               6'b100011, //lw,sw
               6'b101011,
               6'b100011,
               6'b101011: //包括lw,sw
                   ALUCtrl = 4'b0000; //addi,addiu
                   
               6'b001100: ALUCtrl = 4'b0010; //andi
               6'b001101: ALUCtrl = 4'b0011; //ori
               6'b001110: ALUCtrl = 4'b0100; //xori
               
               6'b001010,
               6'b001011: ALUCtrl = 4'b0001; //slti,sltiu
               default: ALUCtrl = 4'b0000; 
           endcase
           ALUWrite = 1; //ALUOut临时存储结果
         end
         
         
         S7_WB_I_ALU: begin
            RegWrite = 1; //写寄存器使能
            RegDst = 2'b01; //写回到rt
            Mem2Reg = 0; //从ALUOut写寄存器
         end
         
         S8_LS_LW: begin //lw 1T
             DataRead = 0; //读内存使能
             DataWrite = 1;
         end
             
         S9_LS_LW: begin //lw 2T
             DataRead = 0; 
             DataWrite = 0;
             DRWrite = 1; //存入DR并输出
         end
         /*S10_LS_LW: begin //lw访存
             DataRead = 1; //读内存使能
             DataWrite = 0; 
             DataRead = 1; //从存储器输出
         end*/
         
         S10_WB_LW: begin
             DRWrite = 0;
             RegWrite = 1;
             RegDst = 2'b01;
             Mem2Reg = 1; //写入数据来自MDR
         end
            
         S11_LS_SW: begin //sw
             DataRead = 0; 
             DataWrite = 1; //只是准备，未写入数据
             RegDst = 0; //读取rt
             //ALUSrcBCtrl = 2'b01; //ALU的第二个运算数是扩展后的数据
         end
         
         /*S12_LS_SW: begin //sw访存
             DataRead = 0; 
             DataWrite = 1; //写内存使能
             //ALUSrcBCtrl = 2'b01; //ALU的第二个运算数是扩展后的数据
         end*/
         
       
         S12_EX_BR: begin
             ALUCtrl = 4'b0001; //sub
             case (opcode)
                 6'b000100: begin //beq
                     if (zero == 1) begin //相等
                         PCSrcCtrl = 2'b01;
                     end 
                     else if (zero == 0) begin
                         PCSrcCtrl = 2'b00;
                     end
                 end
                 6'b000101: begin //bne
                     if (zero == 0) begin //不相等
                         PCSrcCtrl = 2'b01;
                     end 
                     else if (zero == 1) begin
                         PCSrcCtrl = 2'b00;
                     end
                 end
             endcase
         end
         
         /*S13_EX_J: begin
             //ALUCtrl = 4'b0110; //左移
             PCSrcCtrl = 2'b10; //jump地址             
         end*/
         
         S13_EX_JAL_J: begin
             //ALUCtrl = 4'b0110; //左移
             PCSrcCtrl = 2'b10; //jump地址
             PCWrite = 1;           
         end
         
         S14_WB_JAL: begin
             RegDst = 2'b10; //jal写回$31寄存器
             RegWrite = 1; //写reg使能                           
         end
         
         S15_EX_JR: begin            
             RegWrite = 0; //读取rs
             PCWrite = 1;  //更新PC
             PCSrcCtrl = 2'b11; //(rs)
                                       
         end    
         
         S16_PC_JAL: begin
             PCWrite = 1; //同步更新PC
         end
   endcase     
end                            
endmodule
