`timescale 1ns/1ps

module reg_file_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [2:0] raddr1;
    reg [2:0] raddr2;
    reg rst_n;
    reg [2:0] waddr;
    reg [31:0] wdata;
    reg we;
    wire [31:0] rdata1;
    wire [31:0] rdata2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    reg_file dut (
        .clk(clk),
        .raddr1(raddr1),
        .raddr2(raddr2),
        .rst_n(rst_n),
        .waddr(waddr),
        .wdata(wdata),
        .we(we),
        .rdata1(rdata1),
        .rdata2(rdata2)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    task reset_dut;
    //define reset task
    endtask
    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("reg_file Testbench");
        $display("========================================");


        
        
// Print summary
        $display("\n========================================");
        $display("Test Summary");
        $display("========================================");
        $display("Tests Passed: %0d", pass_count);
        $display("Tests Failed: %0d", fail_count);
        $display("Total Tests:  %0d", pass_count + fail_count);
        $display("========================================");

        if (fail_count == 0)
            $display("ALL TESTS PASSED!");
        else
            $display("SOME TESTS FAILED!");

        $display("\nSimulation completed at time %0t", $time);
        $finish;
    end

    // Task to check outputs
    task check_outputs;
        input [31:0] expected_rdata1;
        input [31:0] expected_rdata2;
        begin
            if (expected_rdata1 === (expected_rdata1 ^ rdata1 ^ expected_rdata1) &&
                expected_rdata2 === (expected_rdata2 ^ rdata2 ^ expected_rdata2)) begin
                $display("PASS");
                $display("  Outputs: rdata1=%h, rdata2=%h",
                         rdata1, rdata2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rdata1=%h, rdata2=%h",
                         expected_rdata1, expected_rdata2);
                $display("  Got:      rdata1=%h, rdata2=%h",
                         rdata1, rdata2);
                fail_count = fail_count + 1;
            end
        end
    endtask

    // Timeout watchdog
    initial begin
        #1000000; // 1ms timeout
        $display("\nERROR: Simulation timeout!");
        $finish;
    end

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,clk, raddr1, raddr2, rst_n, waddr, wdata, we, rdata1, rdata2);
    end

endmodule
