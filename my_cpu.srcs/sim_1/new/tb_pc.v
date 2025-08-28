//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/08/15 19:59:21
// Design Name: 
// Module Name: tb_pc
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

//********************************************************************************
// Module Name: pc_tb
// Description: Testbench for the PC (Program Counter) module.
//              This testbench verifies the functionality of the PC module
//              by applying clock, reset, and various pc_next_in values,
//              then monitoring the pc_out.
//********************************************************************************

`timescale 1ns / 1ps

module tb_pc;

    // Testbench signals (reg for inputs to the DUT, wire for outputs from the DUT)
    reg clk, rst, PCWrite;
    reg [31:0] pc_next_in;
    wire [31:0] pc_out;

    // Instantiate the Unit Under Test (DUT): PC module
    PC dut_pc (
        .clk(clk),
        .rst(rst),
        .PCWrite(PCWrite),
        .pc_next_in(pc_next_in),
        .pc_out(pc_out)
    );

    // Clock generation
    // Generates a clock signal with a period of 10ns (5ns high, 5ns low)
    always #5 clk = ~clk; // Toggle clock every 5 time units (ns)

    // Initial block for test stimulus
    initial begin
        // Initialize inputs
        clk = 1'b0;  // Start with clock low
        rst = 1'b1;  // Assert reset initially
        pc_next_in = 32'b0; // Default next PC value

        // Display header for waveform output
        $display("Time\t\tclk\trst\tpc_next_in\tpc_out");
        // Monitor key signals for changes
        $monitor("%0t\t\t%b\t%b\t%h\t\t%h", $time, clk, rst, pc_next_in, pc_out);

        // --- Test Sequence ---

        // 1. Apply reset
        #10 rst = 1'b0; // Deassert reset after 10ns (PC should remain 0)
        #10;            // Wait for another 10ns

        // 2. Test sequential PC update (PC = PC + 4 type behavior)
        // First instruction address (e.g., address 0)
        PCWrite = 1;
        pc_next_in = 32'h0000_0000;
        #10; // Wait for one clock cycle to load 0x0

        // Next sequential instruction (e.g., address 4)
        PCWrite = 1;
        pc_next_in = 32'h0000_0004;
        #10; // Wait for one clock cycle to load 0x4

        // Next sequential instruction (e.g., address 8)
        PCWrite = 0;
        pc_next_in = 32'h0000_0008;
        #10; // Wait for one clock cycle to load 0x8

        // 3. Test a jump/branch scenario (loading an arbitrary address)
        PCWrite = 1;
        pc_next_in = 32'h0000_1000; // Simulate a jump to address 0x1000
        #10;
        
        PCWrite = 0;
        pc_next_in = 32'h0000_1004; // Simulate next sequential after jump
        #10;

        // 4. Re-apply reset to check behavior
        rst = 1'b1; // Assert reset again
        #10;
        rst = 1'b0; // Deassert reset

        // 5. Final test
        PCWrite = 1;
        pc_next_in = 32'h0000_0010;
        #10;

        // End simulation
        $display("---------------------------------------");
        $display("Simulation finished at time %0t", $time);
        $finish; // Terminate simulation
    end

endmodule

