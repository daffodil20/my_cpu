`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/08/24 12:05:21
// Design Name: 
// Module Name: tb_PC_accumulator
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

module tb_PC_accumulator;

    // Testbench signals for DUT inputs
    reg [31:0] pc_current; // Current PC value (or PC+4 for branch calculations)
    reg [31:0] pc_adder;   // Value to add (e.g., 4, or signed_extended_offset << 2)
    reg        PCCtrl;     // Control signal (currently unused in DUT, for future use/clarity)

    // Testbench wire for DUT output
    wire [31:0] pc_next;   // Result of pc_current + pc_adder

    // Instantiate the Unit Under Test (DUT): PC_accumulator
    PC_accumulator pc_acc (
        .pc_current(pc_current),
        .pc_adder(pc_adder),
        .PCCtrl(PCCtrl), // Connect for completeness, though it's unused in DUT
        .pc_next(pc_next)
    );

    // Initial block for test stimulus
    initial begin
        // Initialize all inputs
        pc_current = 32'h0000_0000;
        pc_adder   = 32'h0000_0000;
        PCCtrl     = 1'b0; // Default value, as it's unused in current DUT logic

        // Display header for waveform output
        $display("Time\tpc_current\tpc_adder\tpc_next\tExpected");
        // Monitor key signals for changes
        // %h for hexadecimal display
        $monitor("%0t\t%h\t%h\t%h\t%h", $time, pc_current, pc_adder, pc_next, pc_current + pc_adder);

        // --- Test Sequence ---

        // 1. Test PC + 4 (sequential execution)
        $display("--- Testing PC + 4 ---");
        pc_current = 32'h0000_0000;
        pc_adder   = 32'h0000_0004; // Add 4
        #10; // Wait for combinational logic to propagate

        pc_current = 32'h0000_1000;
        pc_adder   = 32'h0000_0004; // Add 4
        #10;

        pc_current = 32'hFFFF_FFFC; // -4 (2's complement)
        pc_adder   = 32'h0000_0004; // Add 4
        #10;                       // Expected: 0x0000_0000

        // 2. Test branch address calculation (PC_plus_4 + offset)
        // Here, pc_current represents (PC+4), and pc_adder represents (offset << 2)
        $display("--- Testing Branch Address Calculation ---");
        pc_current = 32'h0000_0008; // (PC+4)
        pc_adder   = 32'h0000_0010; // offset * 4 (e.g., offset is 4)
        #10;                       // Expected: 0x0000_0018

        pc_current = 32'h0000_2004; // (PC+4)
        pc_adder   = 32'hFFFF_FFFC; // offset * 4 (e.g., offset is -1, so -4)
        #10;                       // Expected: 0x0000_2000

        pc_current = 32'h0000_0020; // (PC+4)
        pc_adder   = 32'h0000_0100; // Large positive offset
        #10;                       // Expected: 0x0000_0120

        // 3. Test edge cases (large values, potential overflow in arithmetic)
        // Note: For address calculations, typical overflow detection logic is handled by the ALU
        // in the context of general arithmetic, not usually for PC updates directly.
        $display("--- Testing Edge Cases ---");
        pc_current = 32'h7FFF_FFFF; // Largest positive 32-bit signed
        pc_adder   = 32'h0000_0004;
        #10;                       // Expected: 0x8000_0003 (Overflow if signed, but PC is usually unsigned)

        pc_current = 32'hFFFF_FFFF; // All ones (-1)
        pc_adder   = 32'hFFFF_FFFF; // All ones (-1)
        #10;                       // Expected: 0xFFFF_FFFE (-2)

        // End simulation
        $display("---------------------------------------");
        $display("Simulation finished at time %0t", $time);
        $finish; // Terminate simulation
    end
endmodule
