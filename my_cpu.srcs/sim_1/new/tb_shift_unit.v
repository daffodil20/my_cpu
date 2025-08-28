`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/08/24 10:56:51
// Design Name: 
// Module Name: tb_shift_unit
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


module tb_shift_unit;
    // Testbench signals (reg for inputs to the DUT, wire for outputs from the DUT)
    reg [31:0] x;    // Input to the shift_unit
    wire [31:0] y;   // Output from the shift_unit

    // Instantiate the Unit Under Test (DUT): shift_unit module
    shift_unit dut_shifter (
        .x(x),
        .y(y)
    );

    // Initial block for test stimulus
    initial begin
        // Display header for waveform output
        $display("Time\tx_in\ty_out\tExpected_y");
        // Monitor key signals for changes
        // %h for hexadecimal display
        $monitor("%0t\t%h\t%h\t%h", $time, x, y, (x << 2));

        // --- Test Sequence ---

        // 1. Test with zero
        x = 32'h0000_0000;
        #10; // Wait for combinational logic to propagate

        // 2. Test with a small positive number
        x = 32'h0000_0001; // 1
        #10;               // Expected: 4 (0x0000_0004)

        x = 32'h0000_000A; // 10
        #10;               // Expected: 40 (0x0000_0028)

        // 3. Test with a larger positive number
        x = 32'h0000_1234;
        #10;               // Expected: 0x0000_48D0

        // 4. Test with a number that will shift into the next nibble
        x = 32'h0000_000F; // 15
        #10;               // Expected: 60 (0x0000_003C)

        // 5. Test with a negative number (two's complement)
        // Note: Verilog handles signed operations for `<<` implicitly for signed regs/wires.
        // For unsigned, it just shifts bits. Addresses are typically unsigned.
        x = 32'hFFFF_FFFF; // -1
        #10;               // Expected: 0xFFFF_FFFC (-4)

        x = 32'hFFFF_FFFE; // -2
        #10;               // Expected: 0xFFFF_FFF8 (-8)

        x = 32'h8000_0000; // Smallest negative number
        #10;               // Expected: 0x0000_0000 (effectively shifted out if unsigned or wrapped)
                           // For unsigned, 0x8000_0000 << 2 = 0x0000_0000 (high bits shifted out)

        // 6. Test a value where high bits might shift out
        x = 32'h4000_0000; // 0100...0000
        #10;               // Expected: 0x0000_0000 (after shifting out the two MSBs)

        x = 32'h2000_0000; // 0010...0000
        #10;               // Expected: 0x8000_0000 (after shifting, MSB becomes 1)

        x = 32'h7FFF_FFFF; // Largest positive number
        #10;               // Expected: 0x1FFF_FFFC (shifted out top 2 bits)

        // End simulation
        $display("---------------------------------------");
        $display("Simulation finished at time %0t", $time);
        $finish; // Terminate simulation
    end

endmodule

