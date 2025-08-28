`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/08/16 13:57:18
// Design Name: 
// Module Name: tb_data_mem
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
module tb_data_mem;

    // Testbench signals for DUT inputs
    reg clk;
    reg [31:0] read_addr;
    reg [31:0] write_addr;
    reg [31:0] write_data;
    reg DataWrite, DataRead;

    // Testbench wire for DUT output
    wire [31:0] read_data;

    // Instantiate the Unit Under Test (DUT): data_mem
    data_mem DM (
        .clk(clk),
        .read_addr(read_addr),
        .write_addr(write_addr),
        .write_data(write_data),
        .DataWrite(DataWrite),
        .DataRead(DataRead),
        .read_data(read_data)
    );

    // Clock generation: 10ns period (5ns high, 5ns low)
    always #5 clk = ~clk;

    // Initial block for test stimulus
    initial begin
        // Initialize all inputs
        clk        = 1'b0;
        read_addr  = 32'h0;
        write_addr = 32'h0;
        write_data = 32'h0;
        DataWrite  = 1'b0;
        DataRead = 1'b0;

        // --- Test Sequence ---

        // 1. Initial state (memory might be 'x' or 0 depending on simulator)
        #10; // Wait for one clock cycle

        // 2. Write to memory locations (synchronous write)
        // Write 0xAAAA_AAAA to DM[0]
        write_addr = 32'h0000_0000; // Address 0
        write_data = 32'hAAAA_AAAA;
        DataWrite  = 1'b1;
        DataRead = 1'b0;
        #10; // Wait for one clock cycle. Data written at posedge clk.

        // Write 0xBBBB_BBBB to DM[4] (simulating PC+4 addressing)
        write_addr = 32'h0000_0004; // Address 4
        write_data = 32'hBBBB_BBBB;
        DataWrite  = 1'b1;
        DataRead = 1'b0;
        #10;

        // Write 0xCCCC_CCCC to DM[100]
        write_addr = 32'h0000_0064; // Address 100 (0x64)
        write_data = 32'hCCCC_CCCC;
        DataWrite  = 1'b1;
        DataRead = 1'b0;
        #10;

        // Stop writing
        DataWrite = 1'b0;

        // 3. Read from memory locations (asynchronous read)
        // Read from DM[0]
        DataRead = 1'b1;
        read_addr = 32'h0000_0000;
        #10; // Read is asynchronous, data should appear quickly

        // Read from DM[4]
        DataRead = 1'b1;
        read_addr = 32'h0000_0004;
        #10;

        // Read from DM[100]
        DataRead = 1'b1;
        read_addr = 32'h0000_0064;
        #10;

        // 4. Try reading an unwritten address (should be 'x' or 0)
        DataRead = 1'b1;
        read_addr = 32'h0000_0008; // Address 8, which we didn't write to
        #10;

        // End simulation
        $display("---------------------------------------");
        $display("Simulation finished at time %0t", $time);
        $finish; // Terminate simulation
    end

endmodule
