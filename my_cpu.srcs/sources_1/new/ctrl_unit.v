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
//����״̬����
/*parameter S1_IF1  = 5'd1, //����IM
           S2_IF2  = 5'd2,
           S3_IF3  = 5'd3,
           S4_ID   = 5'd4,
           S5_EX_R = 5'd5,
           S6_WB_R = 5'd6,
           S7_EX_I_ALU = 5'd7, //I������ָ�����lw,sw
           S8_WB_I_ALU = 5'd8,
           //S9_EX_LS = d9, //lw,swִ��
           S9_LS_LW = 5'd9, //lw�ô�
           S10_LS_LW = 5'd10, //lw�ô�
           S11_LS_SW = 5'd11, //sw�ô�
           S12_LS_SW = 5'd12, //sw�ô�
           S13_WB_LW = 5'd13,
           S14_EX_BR = 5'd14, //��ָ֧��beq,bneִ��
           S15_EX_J = 5'd15,
           S16_EX_JAL = 5'd16, //jalִ��
           S17_EX_JR = 5'd17,
           S18_WB_JAL = 5'd18 //jalд��*/
           
/*module ctrl_unit #(
     parameter S1_IF_ID1 = 5'd1, //����IM
     parameter S2_IF2  = 5'd2,
     parameter S3_ID  = 5'd3,
     //parameter S4_ID   = 5'd4,
     parameter S4_EX_R = 5'd4,
     parameter S5_WB_R = 5'd5,
     parameter S6_EX_I_ALU = 5'd6, //I������ָ�����lw,sw
     parameter S7_WB_I_ALU = 5'd7,
           //S9_EX_LS = d9, //lw,swִ��
     parameter S8_LS_LW = 5'd8,//lw�ô�
     parameter S9_LS_LW = 5'd9, //lw�ô�
     //parameter      S10_LS_SW = 5'd10, //sw�ô�
     
     parameter S10_WB_LW = 5'd10, //lwд��
     parameter S11_LS_SW = 5'd11, //sw�ô�
     parameter S12_EX_BR = 5'd12, //��ָ֧��beq,bneִ��
     parameter S13_EX_JAL_J = 5'd13, //jal,jִ��
     //parameter      S15_EX_JAL = 5'd15, //jalִ��
     parameter      S14_WB_JAL = 5'd14, //jalд��$31
     parameter      S15_EX_JR = 5'd15, //jrָ��ִ��
     parameter      S16_PC_JAL = 5'd16 //jalgengxin PC
) (input clk, rst,
     input [4:0] opcode, func,
     output IMRead, IRWrite, PCWrite, RegWrite, DataRead, DataWrite, ALUWrite, Mem2Reg, ExtCtrl, zero,
     output [1:0] PCSrcCtrl, ALUSrcBCtrl, RegDst,
     output [3:0] ALUCtrl
);     

reg [4:0] state, next_state; //���嵱ǰ״̬����һ��״̬
always @(posedge clk or posedge rst) begin //״̬�Ĵ���
    if (rst) begin
        state <= S1_IF_ID1;
    end else begin
        state <= next_state; //״̬�ı�
    end
end

//����state��opcode/func����next_state
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
            case (opcode) //����op��func����
            
                6'b000000: begin
                    if (func != 6'b001000) begin
                        next_state = S4_EX_R; //��jr������R��ָ��ִ��
                    end else begin 
                        next_state = S15_EX_JR; //jrִ��
                    end
                end
                
                //6'b100011: next_state = S9_EX_LS, //lwִ��
                //6'b101011: next_state = S9_EX_LS, //swִ��
                6'b100011, //lw
                6'b101011, //sw
                6'b001000, //���I������ָ��ִ�У�����lw,sw��������bne,beq
                6'b001001,
                6'b001100,
                6'b001101,
                6'b001111,
                6'b001010,
                6'b001011: 
                    next_state = S6_EX_I_ALU;
                
                6'b000100,
                6'b000101:
                    next_state = S12_EX_BR; //��ִ֧��beq,bne
                6'b000010,
                6'b000011:
                    next_state = S13_EX_JAL_J; //j,jalָ��ִ��
                
                    //next_state = S13_EX_JAL; //jalָ��ִ��
                default: next_state = S4_EX_R;
            endcase
         end
         
         S4_EX_R: next_state = S5_WB_R; //R��ָ��д��rd
         S5_WB_R: next_state = S1_IF_ID1;
         
         S6_EX_I_ALU: begin //I������ִ�У�������bne,beq
             if (opcode == 6'b100011) begin
                 next_state = S8_LS_LW; //lw�ô��һ��ʱ������
             end else if (opcode == 6'b101011) begin
                 //6'b100011:  
                 next_state = S11_LS_SW; //sw�ô��һ��ʱ������
                 //next_state = S0_IF0; 
             end else begin
                 next_state = S1_IF_ID1; //����I������ָ��ص�ȡָ
             end
         end        
         //next_state = S8_WB_I_ALU;
         S7_WB_I_ALU: next_state = S1_IF_ID1; //I��ָ��д��rt
         S8_LS_LW: next_state = S9_LS_LW; //lw�ô� 2T
         S9_LS_LW: next_state = S10_WB_LW; //lwд��rt
         //S11_LS_SW: next_state = S1_IF_ID1; //sw�ô�ڶ���ʱ������

         S10_WB_LW: next_state = S1_IF_ID1;         
         //next_state = S0_IF1; //�ص�ȡָ״̬
         
         /*S9_EX_LS: begin
             if (opcode == 100011) begin
                 next_state = S10_LS_LW; //lw�ô�
             end
             else if (opcode == 101011) begin
                 next_state = S12_LS_SW; //sw�ô�
             end
         end*/
         
         //S9_WB_W: next_state = S1_IF_ID1; //lwд��
         //S11_LS_LW: next_state = S13_WB_LW; 
         /*S11_LS_SW: next_state = S1_IF_ID1; //sw�ô�ڶ���ʱ������

         //S12_WB_LW: next_state = S0_IF0;
         //S13_LS_SW: next_state = S0_IF0;
         S12_EX_BR: begin
             case (zero)
                 1'b1: next_state = S16_PC_JAL;
                 1'b0: next_state = S1_IF_ID1;
             endcase
         end
         //next_state = S1_IF_ID1;    //��ִ֧�к�ص�ȡָ״̬
         S13_EX_JAL_J: next_state = S1_IF_ID1;
         //S16_EX_JAL: next_state = S18_WB_JAL; //jalд��$31
         
         S14_WB_JAL: next_state = S1_IF_ID1; 
         S15_EX_JR: next_state = S1_IF_ID1; 
         S16_PC_JAL: next_state = S1_IF_ID1; 
          
         default: next_state = S1_IF_ID1;
   endcase
end
 
//���ɿ����ź�
always @(*) begin
    case (state)
        /*S0_IF0: begin
            IMRead = 1; //��IM��ȡָ��
            IRWrite = 0;*/
        //end
        /*S1_IF_ID1: begin
            //IMRead = 1; //
            IRWrite = 1'b1; //��IM��ȡָ�����IR��ͬ���������ֶΣ����룩��
        end
        S2_IF2: begin   
            //IMRead = 0; //
            IRWrite = 0;
            PCWrite = 1; //PC����
        end
        S3_ID: begin//ȡָ��д��IR
            
            PCSrcCtrl = 00;
            ALUSrcACtrl = 0;
            ALUSrcBCtrl = 00;
            //pc_plus_4 = PC; //pc_plus_
            //(PC) = (PC) + 4�����Ƶڶ�����������+4
            PCSrcCtrl = 2'b00; //PC�ӷ����ĵ�һ��ѡ��
        end*/
        /*S3_ID: begin //�첽��ȡreg file�ļĴ�����ͬ�����������reg A,B ;��
            case (opcode) //��ǰ��չimm/offset
                
                6'b100011,
                6'b101011,
                6'b000100,
                6'b000101,
                6'b001010: begin
                    ExtCtrl = 1; //������չ
                end
                6'b001000,
                6'b001001: begin
                    PCSrcCtrl = 2'b01; //��ָ֧��pc���ƣ�branch_addr�洢��֧Ŀ���ַ
                    ExtCtrl = 1; //������չ
                end
                6'b001100,
                6'b001101,
                6'b001110,
                6'b001011,
                6'b000010:
                //jal
                    ExtCtrl = 0; //0��չ 
                6'b000011: begin
                    PCSrcCtrl = 2'b00; //jalָ��pc����
                    ExtCtrl = 0; //0��չ
                end
                default: ExtCtrl = 0;
            endcase
            
                      
        end
        
        S4_EX_R: begin //R��ָ������
           PCWrite = 0;
           IRWrte = 0;
           case (func) //����func�ж��������ͣ����������ź�
               6'b100000,
               6'b100001: begin
                   ALUCtrl = 4'b0000; //add
                   ALUSrcBCtrl = 2'b00; //��2����������(rt)
               end
               6'b100010,
               6'b100011: begin
                   ALUCtrl = 4'b0001; //sub
                   ALUSrcBCtrl = 2'b00; //��2����������(rt)
               end  
               6'b100100: begin
                   ALUCtrl = 4'b0010; //and
                   ALUSrcBCtrl = 2'b00; //��2����������(rt)
               end
               6'b100101: begin
                   ALUCtrl = 4'b0011; //or
                   ALUSrcBCtrl = 2'b00; //��2����������(rt)
               end
               6'b100110: begin
                   ALUCtrl = 4'b0100; //xor
                   ALUSrcBCtrl = 2'b00; //��2����������(rt)  
               end    
               6'b100111: begin
                   ALUCtrl = 4'b0101; //nor    
                   ALUSrcBCtrl = 2'b00; //��2����������(rt)
               end
               6'b000000: begin
                   ALUCtrl = 4'b0110; //����
                   ALUSrcBCtrl = 2'b10; //��2����������shamt
               end
               6'b000100: begin
                   ALUCtrl = 4'b0110; //����
                   ALUSrcBCtrl = 2'b10;
               end    
               6'b000010,
               6'b000110: begin
                   ALUCtrl = 4'b0111; //�߼�����
               end
               6'b000011,
               6'b000111: begin
                   ALUCtrl = 4'b1000; //��������
               end
               default: ALUCtrl = 4'b0000; 
           endcase
           ALUWrite = 1; //ALUOut
         end
              
         S5_WB_R: begin //R��ָ��д��
            RegWrite = 1; //д�Ĵ���ʹ��         
            RegDst = 2'b00; //д�ص�rd
            Mem2Reg = 0; //д����������ALU
            ALUWrite = 0;  
         end
            
         S6_EX_I_ALU: begin
           PCWrite = 0;
           IRWrte = 0;
           ALUSrcBCtrl = 2'b01; //��2����������ext_imm
           case (opcode) //����func�ж��������ͣ����������ź�
               6'b001000,
               6'b001001,
               6'b100011, //lw,sw
               6'b101011,
               6'b100011,
               6'b101011: //����lw,sw
                   ALUCtrl = 4'b0000; //addi,addiu
                   
               6'b001100: ALUCtrl = 4'b0010; //andi
               6'b001101: ALUCtrl = 4'b0011; //ori
               6'b001110: ALUCtrl = 4'b0100; //xori
               
               6'b001010,
               6'b001011: ALUCtrl = 4'b0001; //slti,sltiu
               default: ALUCtrl = 4'b0000; 
           endcase
           ALUWrite = 1; //ALUOut��ʱ�洢���
         end
         
         
         S7_WB_I_ALU: begin
            RegWrite = 1; //д�Ĵ���ʹ��
            RegDst = 2'b01; //д�ص�rt
            Mem2Reg = 0; //��ALUOutд�Ĵ���
         end
         
         S8_LS_LW: begin //lw 1T
             DataRead = 0; //���ڴ�ʹ��
             DataWrite = 1;
         end
             
         S9_LS_LW: begin //lw 2T
             DataRead = 0; 
             DataWrite = 0;
             DRWrite = 1; //����DR�����
         end
         S10_LS_LW: begin //lw�ô�
             DataRead = 1; //���ڴ�ʹ��
             DataWrite = 0; 
             DataRead = 1; //�Ӵ洢�����
         end
         
         S10_WB_LW: begin
             DRWrite = 0;
             RegWrite = 1;
             RegDst = 2'b01;
             Mem2Reg = 1; //д����������MDR
         end
            
         S11_LS_SW: begin //sw
             DataRead = 0; 
             DataWrite = 1; //ֻ��׼����δд������
             RegDst = 0; //��ȡrt
             //ALUSrcBCtrl = 2'b01; //ALU�ĵڶ�������������չ�������
         end
         
         S12_LS_SW: begin //sw�ô�
             DataRead = 0; 
             DataWrite = 1; //д�ڴ�ʹ��
             //ALUSrcBCtrl = 2'b01; //ALU�ĵڶ�������������չ�������
         end
         
       
         S12_EX_BR: begin
             ALUCtrl = 4'b0001; //sub
             case (opcode)
                 6'b000100: begin //beq
                     if (zero == 1) begin //���
                         PCSrcCtrl = 2'b01;
                     end 
                     else if (zero == 0) begin
                         PCSrcCtrl = 2'b00;
                     end
                 end
                 6'b000101: begin //bne
                     if (zero == 0) begin //�����
                         PCSrcCtrl = 2'b01;
                     end 
                     else if (zero == 1) begin
                         PCSrcCtrl = 2'b00;
                     end
                 end
             endcase
         end
         
         S13_EX_J: begin
             //ALUCtrl = 4'b0110; //����
             PCSrcCtrl = 2'b10; //jump��ַ             
         end
         
         S13_EX_JAL_J: begin
             //ALUCtrl = 4'b0110; //����
             PCSrcCtrl = 2'b10; //jump��ַ
             PCWrite = 1;           
         end
         
         S14_WB_JAL: begin
             RegDst = 2'b10; //jalд��$31�Ĵ���
             RegWrite = 1; //дregʹ��                           
         end
         
         S15_EX_JR: begin            
             RegWrite = 0; //��ȡrs
             PCWrite = 1;  //����PC
             PCSrcCtrl = 2'b11; //(rs)
                                       
         end    
         
         S16_PC_JAL: begin
             PCWrite = 1; //ͬ������PC
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
//����״̬����
/*parameter S1_IF1  = 5'd1, //����IM
           S2_IF2  = 5'd2,
           S3_IF3  = 5'd3,
           S4_ID   = 5'd4,
           S5_EX_R = 5'd5,
           S6_WB_R = 5'd6,
           S7_EX_I_ALU = 5'd7, //I������ָ�����lw,sw
           S8_WB_I_ALU = 5'd8,
           //S9_EX_LS = d9, //lw,swִ��
           S9_LS_LW = 5'd9, //lw�ô�
           S10_LS_LW = 5'd10, //lw�ô�
           S11_LS_SW = 5'd11, //sw�ô�
           S12_LS_SW = 5'd12, //sw�ô�
           S13_WB_LW = 5'd13,
           S14_EX_BR = 5'd14, //��ָ֧��beq,bneִ��
           S15_EX_J = 5'd15,
           S16_EX_JAL = 5'd16, //jalִ��
           S17_EX_JR = 5'd17,
           S18_WB_JAL = 5'd18 //jalд��*/
           
module ctrl_unit #(
     parameter S1_IF_ID1 = 5'd1, //����IM
     parameter S2_IF2  = 5'd2,
     parameter S3_ID  = 5'd3,
     //parameter S4_ID   = 5'd4,
     parameter S4_EX_R = 5'd4,
     parameter S5_WB_R = 5'd5,
     parameter S6_EX_I_ALU = 5'd6, //I������ָ�����lw,sw
     parameter S7_WB_I_ALU = 5'd7,
           //S9_EX_LS = d9, //lw,swִ��
     parameter S8_LS_LW = 5'd8,//lw�ô�
     parameter S9_LS_LW = 5'd9, //lw�ô�
     //parameter      S10_LS_SW = 5'd10, //sw�ô�
     
     parameter S10_WB_LW = 5'd10, //lwд��
     parameter S11_LS_SW = 5'd11, //sw�ô�
     parameter S12_EX_BR = 5'd12, //��ָ֧��beq,bneִ��
     parameter S13_EX_JAL_J = 5'd13, //jal,jִ��
     //parameter      S15_EX_JAL = 5'd15, //jalִ��
     parameter      S14_WB_JAL = 5'd14, //jalд��$31
     parameter      S15_EX_JR = 5'd15, //jrָ��ִ��
     parameter      S16_PC_JAL = 5'd16 //jalgengxin PC
) (input clk, rst,
     input [4:0] opcode, func,
     output reg IMRead, IRRead, PCWrite, RegWrite, DataRead, DataWrite, ALUWrite, Mem2Reg, ExtCtrl, zero, DRWrite, IRWrite,
     output reg [1:0] PCSrcCtrl, ALUSrcBCtrl, RegDst,
     output reg [3:0] ALUCtrl
);     

reg [4:0] state, next_state; //���嵱ǰ״̬����һ��״̬
always @(posedge clk or posedge rst) begin //״̬�Ĵ���
    if (rst) begin
        state <= S1_IF_ID1;
    end else begin
        state <= next_state; //״̬�ı�
    end
end

//����state��opcode/func����next_state
always @(*) begin
    IMRead    = 0; //�����ź�����
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
            case (opcode) //����op��func����
            
                6'b000000: begin
                    if (func != 6'b001000) begin
                        next_state = S4_EX_R; //��jr������R��ָ��ִ��
                    end else begin 
                        next_state = S15_EX_JR; //jrִ��
                    end
                end
                
                //6'b100011: next_state = S9_EX_LS, //lwִ��
                //6'b101011: next_state = S9_EX_LS, //swִ��
                6'b100011, //lw
                6'b101011, //sw
                6'b001000, //���I������ָ��ִ�У�����lw,sw��������bne,beq
                6'b001001,
                6'b001100,
                6'b001101,
                6'b001111,
                6'b001010,
                6'b001011: 
                    next_state = S6_EX_I_ALU;
                
                6'b000100,
                6'b000101:
                    next_state = S12_EX_BR; //��ִ֧��beq,bne
                6'b000010,
                6'b000011:
                    next_state = S13_EX_JAL_J; //j,jalָ��ִ��
                
                    //next_state = S13_EX_JAL; //jalָ��ִ��
                default: next_state = S4_EX_R;
            endcase
         end
         
         S4_EX_R: next_state = S5_WB_R; //R��ָ��д��rd
         S5_WB_R: next_state = S1_IF_ID1;
         
         S6_EX_I_ALU: begin //I������ִ�У�������bne,beq
             if (opcode == 6'b100011) begin
                 next_state = S8_LS_LW; //lw�ô��һ��ʱ������
             end else if (opcode == 6'b101011) begin
                 //6'b100011:  
                 next_state = S11_LS_SW; //sw�ô��һ��ʱ������
                 //next_state = S0_IF0; 
             end else begin
                 next_state = S1_IF_ID1; //����I������ָ��ص�ȡָ
             end
         end        
         //next_state = S8_WB_I_ALU;
         S7_WB_I_ALU: next_state = S1_IF_ID1; //I��ָ��д��rt
         S8_LS_LW: next_state = S9_LS_LW; //lw�ô� 2T
         S9_LS_LW: next_state = S10_WB_LW; //lwд��rt
         //S11_LS_SW: next_state = S1_IF_ID1; //sw�ô�ڶ���ʱ������

         S10_WB_LW: next_state = S1_IF_ID1;         
         //next_state = S0_IF1; //�ص�ȡָ״̬
         
         /*S9_EX_LS: begin
             if (opcode == 100011) begin
                 next_state = S10_LS_LW; //lw�ô�
             end
             else if (opcode == 101011) begin
                 next_state = S12_LS_SW; //sw�ô�
             end
         end*/
         
         //S9_WB_W: next_state = S1_IF_ID1; //lwд��
         //S11_LS_LW: next_state = S13_WB_LW; 
         S11_LS_SW: next_state = S1_IF_ID1; //sw�ô�ڶ���ʱ������

         //S12_WB_LW: next_state = S0_IF0;
         //S13_LS_SW: next_state = S0_IF0;
         S12_EX_BR: begin
             case (zero)
                 1'b1: next_state = S16_PC_JAL;
                 1'b0: next_state = S1_IF_ID1;
             endcase
         end
         //next_state = S1_IF_ID1;    //��ִ֧�к�ص�ȡָ״̬
         S13_EX_JAL_J: next_state = S1_IF_ID1;
         //S16_EX_JAL: next_state = S18_WB_JAL; //jalд��$31
         
         S14_WB_JAL: next_state = S1_IF_ID1; 
         S15_EX_JR: next_state = S1_IF_ID1; 
         S16_PC_JAL: next_state = S1_IF_ID1; 
          
         default: next_state = S1_IF_ID1;
   endcase
end
 
//���ɿ����ź�
always @(*) begin
    case (state)
        /*S0_IF0: begin
            IMRead = 1; //��IM��ȡָ��
            IRWrite = 0;*/
        //end
        S1_IF_ID1: begin
            //IMRead = 1; //
            IRWrite = 1'b1; //��IM��ȡָ�����IR��ͬ���������ֶΣ����룩��
        end
        S2_IF2: begin   
            //IMRead = 0; //
            IRWrite = 0;
            PCWrite = 1; //PC����
        end
        /*S3_ID: begin//ȡָ��д��IR
            
            PCSrcCtrl = 00;
            ALUSrcACtrl = 0;
            ALUSrcBCtrl = 00;
            //pc_plus_4 = PC; //pc_plus_
            //(PC) = (PC) + 4�����Ƶڶ�����������+4
            PCSrcCtrl = 2'b00; //PC�ӷ����ĵ�һ��ѡ��
        end*/
        S3_ID: begin //�첽��ȡreg file�ļĴ�����ͬ�����������reg A,B ;��
            case (opcode) //��ǰ��չimm/offset
                
                6'b100011,
                6'b101011,
                6'b000100,
                6'b000101,
                6'b001010: begin
                    ExtCtrl = 1; //������չ
                end
                6'b001000,
                6'b001001: begin
                    PCSrcCtrl = 2'b01; //��ָ֧��pc���ƣ�branch_addr�洢��֧Ŀ���ַ
                    ExtCtrl = 1; //������չ
                end
                6'b001100,
                6'b001101,
                6'b001110,
                6'b001011,
                6'b000010:
                //jal
                    ExtCtrl = 0; //0��չ 
                6'b000011: begin
                    PCSrcCtrl = 2'b00; //jalָ��pc����
                    ExtCtrl = 0; //0��չ
                end
                default: ExtCtrl = 0;
            endcase
            
            
            /*case (func) //����func�ж��������ͣ����������ź�
               6'b100000,
               6'b100001: begin
                   ALUCtrl = 4'b0000; //add
                   ALUSrcBCtrl = 2'b00; //��2����������(rt)
               end
               6'b100010,
               6'b100011: begin
                   ALUCtrl = 4'b0001; //sub
                   ALUSrcBCtrl = 2'b00; //��2����������(rt)
               end
               6'b100100: begin
                   ALUCtrl = 4'b0010; //and
                   ALUSrcBCtrl = 2'b00; //��2����������(rt)
               end
               6'b100101: begin
                   ALUCtrl = 4'b0011; //or
                   ALUSrcBCtrl = 2'b00; //��2����������(rt)
               end
               6'b100110: 
                   ALUCtrl = 4'b0100; //xor
                   ALUSrcBCtrl = 2'b00; //��2����������(rt)  
                   
               6'b100111: 
                   ALUCtrl = 4'b0101; //nor    
                   ALUSrcBCtrl = 2'b00; //��2����������(rt)
               6'b000000:
                   ALUCtrl = 4'b0110; //����
                   ALUSrcBCtrl = 2'b10; //��2����������shamt
               6'b000100: 
                   ALUCtrl = 4'b0110; //����
                   ALUSrcBCtrl = 2'b10;
                   
               6'b000010,
               6'b000110: 
                   ALUCtrl = 4'b0111; //�߼�����
               6'b000011
               6'b000111:
                   ALUCtrl = 4'b1000; //��������
               defa  */             
        end
        
        S4_EX_R: begin //R��ָ������
           PCWrite = 0;
           IRWrite = 0;
           case (func) //����func�ж��������ͣ����������ź�
               6'b100000,
               6'b100001: begin
                   ALUCtrl = 4'b0000; //add
                   ALUSrcBCtrl = 2'b00; //��2����������(rt)
               end
               6'b100010,
               6'b100011: begin
                   ALUCtrl = 4'b0001; //sub
                   ALUSrcBCtrl = 2'b00; //��2����������(rt)
               end  
               6'b100100: begin
                   ALUCtrl = 4'b0010; //and
                   ALUSrcBCtrl = 2'b00; //��2����������(rt)
               end
               6'b100101: begin
                   ALUCtrl = 4'b0011; //or
                   ALUSrcBCtrl = 2'b00; //��2����������(rt)
               end
               6'b100110: begin
                   ALUCtrl = 4'b0100; //xor
                   ALUSrcBCtrl = 2'b00; //��2����������(rt)  
               end    
               6'b100111: begin
                   ALUCtrl = 4'b0101; //nor    
                   ALUSrcBCtrl = 2'b00; //��2����������(rt)
               end
               6'b000000: begin
                   ALUCtrl = 4'b0110; //����
                   ALUSrcBCtrl = 2'b10; //��2����������shamt
               end
               6'b000100: begin
                   ALUCtrl = 4'b0110; //����
                   ALUSrcBCtrl = 2'b10;
               end    
               6'b000010,
               6'b000110: begin
                   ALUCtrl = 4'b0111; //�߼�����
               end
               6'b000011,
               6'b000111: begin
                   ALUCtrl = 4'b1000; //��������
               end
               default: ALUCtrl = 4'b0000; 
           endcase
           ALUWrite = 1; //ALUOut
         end
              
         S5_WB_R: begin //R��ָ��д��
            RegWrite = 1; //д�Ĵ���ʹ��         
            RegDst = 2'b00; //д�ص�rd
            Mem2Reg = 0; //д����������ALU
            ALUWrite = 0;  
         end
            
         S6_EX_I_ALU: begin
           PCWrite = 0;
           IRWrite = 0;
           ALUSrcBCtrl = 2'b01; //��2����������ext_imm
           case (opcode) //����func�ж��������ͣ����������ź�
               6'b001000,
               6'b001001,
               6'b100011, //lw,sw
               6'b101011,
               6'b100011,
               6'b101011: //����lw,sw
                   ALUCtrl = 4'b0000; //addi,addiu
                   
               6'b001100: ALUCtrl = 4'b0010; //andi
               6'b001101: ALUCtrl = 4'b0011; //ori
               6'b001110: ALUCtrl = 4'b0100; //xori
               
               6'b001010,
               6'b001011: ALUCtrl = 4'b0001; //slti,sltiu
               default: ALUCtrl = 4'b0000; 
           endcase
           ALUWrite = 1; //ALUOut��ʱ�洢���
         end
         
         
         S7_WB_I_ALU: begin
            RegWrite = 1; //д�Ĵ���ʹ��
            RegDst = 2'b01; //д�ص�rt
            Mem2Reg = 0; //��ALUOutд�Ĵ���
         end
         
         S8_LS_LW: begin //lw 1T
             DataRead = 0; //���ڴ�ʹ��
             DataWrite = 1;
         end
             
         S9_LS_LW: begin //lw 2T
             DataRead = 0; 
             DataWrite = 0;
             DRWrite = 1; //����DR�����
         end
         /*S10_LS_LW: begin //lw�ô�
             DataRead = 1; //���ڴ�ʹ��
             DataWrite = 0; 
             DataRead = 1; //�Ӵ洢�����
         end*/
         
         S10_WB_LW: begin
             DRWrite = 0;
             RegWrite = 1;
             RegDst = 2'b01;
             Mem2Reg = 1; //д����������MDR
         end
            
         S11_LS_SW: begin //sw
             DataRead = 0; 
             DataWrite = 1; //ֻ��׼����δд������
             RegDst = 0; //��ȡrt
             //ALUSrcBCtrl = 2'b01; //ALU�ĵڶ�������������չ�������
         end
         
         /*S12_LS_SW: begin //sw�ô�
             DataRead = 0; 
             DataWrite = 1; //д�ڴ�ʹ��
             //ALUSrcBCtrl = 2'b01; //ALU�ĵڶ�������������չ�������
         end*/
         
       
         S12_EX_BR: begin
             ALUCtrl = 4'b0001; //sub
             case (opcode)
                 6'b000100: begin //beq
                     if (zero == 1) begin //���
                         PCSrcCtrl = 2'b01;
                     end 
                     else if (zero == 0) begin
                         PCSrcCtrl = 2'b00;
                     end
                 end
                 6'b000101: begin //bne
                     if (zero == 0) begin //�����
                         PCSrcCtrl = 2'b01;
                     end 
                     else if (zero == 1) begin
                         PCSrcCtrl = 2'b00;
                     end
                 end
             endcase
         end
         
         /*S13_EX_J: begin
             //ALUCtrl = 4'b0110; //����
             PCSrcCtrl = 2'b10; //jump��ַ             
         end*/
         
         S13_EX_JAL_J: begin
             //ALUCtrl = 4'b0110; //����
             PCSrcCtrl = 2'b10; //jump��ַ
             PCWrite = 1;           
         end
         
         S14_WB_JAL: begin
             RegDst = 2'b10; //jalд��$31�Ĵ���
             RegWrite = 1; //дregʹ��                           
         end
         
         S15_EX_JR: begin            
             RegWrite = 0; //��ȡrs
             PCWrite = 1;  //����PC
             PCSrcCtrl = 2'b11; //(rs)
                                       
         end    
         
         S16_PC_JAL: begin
             PCWrite = 1; //ͬ������PC
         end
   endcase     
end                            
endmodule
