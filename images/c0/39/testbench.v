`timescale 1ns/1ps

module avr_io_out_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] io_di;
    reg io_re;
    reg io_we;
    reg rst;
    wire [7:0] io_do;
    wire [7:0] port;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    avr_io_out dut (
        .clk(clk),
        .io_di(io_di),
        .io_re(io_re),
        .io_we(io_we),
        .rst(rst),
        .io_do(io_do),
        .port(port)
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
        $display("avr_io_out Testbench");
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
        input [7:0] expected_io_do;
        input [7:0] expected_port;
        begin
            if (expected_io_do === (expected_io_do ^ io_do ^ expected_io_do) &&
                expected_port === (expected_port ^ port ^ expected_port)) begin
                $display("PASS");
                $display("  Outputs: io_do=%h, port=%h",
                         io_do, port);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: io_do=%h, port=%h",
                         expected_io_do, expected_port);
                $display("  Got:      io_do=%h, port=%h",
                         io_do, port);
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
        $dumpvars(0,clk, io_di, io_re, io_we, rst, io_do, port);
    end

endmodule
