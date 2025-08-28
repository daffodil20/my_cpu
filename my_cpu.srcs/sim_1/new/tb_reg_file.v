`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/08/16 09:41:31
// Design Name: 
// Module Name: tb_reg_file
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
// Module Name: register_file_tb
// Description: Testbench for the register_file module.
//              Verifies synchronous write, asynchronous read, and special
//              handling for register $0.
//********************************************************************************

module tb_register_file;

    // Testbench signals for DUT inputs
    reg clk;
    reg rst;
    reg [4:0] read_addr1;
    reg [4:0] read_addr2;
    reg [4:0] write_addr;
    reg [31:0] write_data;
    reg RegWrite;

    // Testbench wires for DUT outputs
    wire [31:0] read_data1;
    wire [31:0] read_data2;

    // Instantiate the Unit Under Test (DUT): register_file
    register_file dut_rf (
        .clk(clk),
        .rst(rst),
        .read_addr1(read_addr1),
        .read_addr2(read_addr2),
        .write_addr(write_addr),
        .write_data(write_data),
        .RegWrite(RegWrite),
        .read_data1(read_data1),
        .read_data2(read_data2)
    );

    // Clock generation: 10ns period (5ns high, 5ns low)
    always #5 clk = ~clk;

    // Initial block for test stimulus
    initial begin
        // Initialize all inputs
        clk        = 1'b0;
        rst        = 1'b1;     // Assert reset
        read_addr1 = 5'b0;
        read_addr2 = 5'b0;
        write_addr = 5'b0;
        write_data = 32'b0;
        RegWrite   = 1'b0;

        // Display header for waveform output
        $display("Time\tclk\trst\tWrEn\tWrAddr\tWrData\tRdAddr1\tRdData1\tRdAddr2\tRdData2");
        // Monitor key signals for changes
        $monitor("%0t\t%b\t%b\t%b\t%d\t%h\t%d\t%h\t%d\t%h",
                 $time, clk, rst, RegWrite, write_addr, write_data,
                 read_addr1, read_data1, read_addr2, read_data2);

        // --- Test Sequence ---

        // 1. Initial reset phase
        #10; // Wait 10ns while reset is active, all regs should be 0

        // 2. Deassert reset
        rst = 1'b0;
        #10; // Wait for one clock cycle after reset deassertion

        // 3. Test writing to various registers
        // Write 0x1111_1111 to Reg 1
        write_addr = 5'd1;
        write_data = 32'h1111_1111;
        RegWrite   = 1'b1;
        #10; // Wait for one clock cycle

        // Write 0x2222_2222 to Reg 2
        write_addr = 5'd2;
        write_data = 32'h2222_2222;
        RegWrite   = 1'b1;
        #10;

        // Write 0xAAAAAAAA to Reg 10
        write_addr = 5'd10;
        write_data = 32'hAAAAAAAA;
        RegWrite   = 1'b1;
        #10;

        // 4. Test reading from various registers (asynchronous)
        RegWrite = 1'b0; // Disable write

        // Read from Reg 1 and Reg 2
        read_addr1 = 5'd1;
        read_addr2 = 5'd2;
        #5; // Read should be instantaneous (combinational path)

        // Read from Reg 10 and Reg 1
        read_addr1 = 5'd10;
        read_addr2 = 5'd1;
        #5;

        // 5. Test Register 0 special handling
        // 5a. Try to write to Reg 0 (should be ignored)
        write_addr = 5'd0;
        write_data = 32'hFFFF_FFFF; // Try to write a non-zero value
        RegWrite   = 1'b1;
        #10; // Wait for a cycle, write should be ignored

        // 5b. Read from Reg 0 (should always output 0)
        RegWrite   = 1'b0;
        read_addr1 = 5'd0; // Read from Reg 0
        read_addr2 = 5'd1; // Read from Reg 1 (to see if other regs are fine)
        #5; // read_data1 should be 0x0000_0000

        // 6. Read and write in the same cycle (write takes effect next cycle)
        write_addr = 5'd3;
        write_data = 32'h3333_3333;
        RegWrite   = 1'b1;
        read_addr1 = 5'd3; // Reading Reg 3 (should get previous value, which is 0)
        #10; // After this cycle, Reg 3 should contain 0x3333_3333

        // Verify the write from previous cycle
        RegWrite   = 1'b0;
        read_addr1 = 5'd3;
        #5; // read_data1 should now be 0x3333_3333

        // End simulation
        $display("---------------------------------------");
        $display("Simulation finished at time %0t", $time);
        $finish; // Terminate simulation
    end

endmodule

