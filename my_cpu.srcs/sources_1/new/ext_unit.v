`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/08/17 08:41:16
// Design Name: 
// Module Name: ext_unit
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


module ext_unit( //��չ��Ԫ
    input [15:0] in_data,
    input ExtCtrl, //��չ��ʽ�Ŀ����ź�
    output wire [31:0] out_data
);
wire [31:0] zero_ext_data; //0��չ
assign zero_ext_data = {16'b0, in_data};
wire [31:0] sign_ext_data; //������չ
assign sign_ext_data = {{16{in_data[15]}}, in_data};
assign out_data = (ExtCtrl == 1'b0) ? zero_ext_data : sign_ext_data;

endmodule
