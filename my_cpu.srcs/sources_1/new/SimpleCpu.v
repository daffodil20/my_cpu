`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/07/22 10:47:45
// Design Name: 
// Module Name: SimpleCpu
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

// ��Ϊ��������ֻ���ǽ�������������ʵ��
module SimpleCPU(
    input clk,
    input reset
);

    // ָ���ֶν���
    reg [31:0] PC, IR;
    reg [31:0] REG [0:31]; // 32��ͨ�üĴ���
    reg [31:0] MEM [0:255]; // ���ڴ�
    reg [31:0] A, B, ALUOut, MDR;
    reg [5:0] state;

    // ״̬����
    parameter FETCH=0, DECODE=1, EXEC=2, MEM_ACCESS=3, WRITEBACK=4;

    wire [5:0] opcode = IR[31:26];
    wire [4:0] rs = IR[25:21];
    wire [4:0] rt = IR[20:16];
    wire [4:0] rd = IR[15:11];
    wire [15:0] imm = IR[15:0];
    wire [31:0] sign_ext_imm = {{16{imm[15]}}, imm}; // ������չ

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            PC <= 0;
            state <= FETCH; //�ص�ȡָ��
        end else begin
            case (state)
                FETCH: begin
                    IR <= MEM[PC >> 2]; //������λ
                    PC <= PC + 4;
                    state <= DECODE;
                end
                DECODE: begin
                    A <= REG[rs]; //�ݴ������
                    B <= REG[rt];
                    state <= EXEC;
                end
                EXEC: begin
                    case (opcode)
                        6'b000000: begin // R�� ADD
                            ALUOut <= A + B;
                            state <= WRITEBACK;
                        end
                        6'b100011: begin // LW
                            ALUOut <= A + sign_ext_imm;
                            state <= MEM_ACCESS;
                        end
                        6'b101011: begin // SW
                            ALUOut <= A + sign_ext_imm;
                            state <= MEM_ACCESS;
                        end
                        6'b000100: begin // BEQ
                            if (A == B) PC <= PC + (sign_ext_imm << 2);
                            state <= FETCH;
                        end
                        default: state <= FETCH;
                    endcase
                end
                MEM_ACCESS: begin
                    if (opcode == 6'b100011) begin // LW
                        MDR <= MEM[ALUOut >> 2]; //���ڴ�������ݵ�MDR
                        state <= WRITEBACK;
                    end else if (opcode == 6'b101011) begin // SW
                        MEM[ALUOut >> 2] <= B; //д���ڴ�����
                        state <= FETCH;
                    end
                end
                WRITEBACK: begin
                    if (opcode == 6'b000000) REG[rd] <= ALUOut;      // ADD
                    else if (opcode == 6'b100011) REG[rt] <= MDR;    // LW
                    state <= FETCH;
                end
            endcase
        end
    end

endmodule

