`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/08/16 20:04:07
// Design Name: 
// Module Name: sign_ext_unit
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


module sign_ext_unit(
    input [15:0] x,
    output [31:0] y
);
//integer i;
/*always @* begin
    if (x[15] == 1) begin//����
        for (i = 31; i >= 16; i = i - 1) begin
            y[i] = 1'b1;
        end
        for (i = 15; i >= 0; i = i - 1) begin
            y[i] = x[i];
        end
     end
    else begin //����
        for (i = 31; i >=16; i = i - 1) begin
            y[i] = 1'b0;
        end
        for (i = 15; i >= 0; i = i - 1) begin
            y[i] = x[i];
        end
    end
end*/
 // ������չ����x�ĵ�15λ������λ����չ��31��16λ
assign y = {{16{x[15]}}, x};        
endmodule
