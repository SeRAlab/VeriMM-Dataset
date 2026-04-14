`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg ena;
    reg [2:0] rra;
    reg rst;
    reg [2:0] rwa;
    reg [15:0] rwd;
    reg rwe;
    wire [15:0] rrd;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .ena(ena),
        .rra(rra),
        .rst(rst),
        .rwa(rwa),
        .rwd(rwd),
        .rwe(rwe),
        .rrd(rrd)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            ena = 0;
            rra = 0;
            rwa = 0;
            rwd = 0;
            rwe = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
            $display("DUT Reset Asserted");
        end
        endtask
    task testcase001;

        begin
            $display("\nTestcase 001: Basic Write and Read");
            reset_dut();


            ena = 1;
            rwe = 1;
            rwa = 3'd3;
            rwd = 16'hABCD;
            @(posedge clk);


            rwe = 0;
            rra = 3'd3;
            @(posedge clk);


            #1;



            check_outputs(16'hABCD);
        end
        endtask

    task testcase002;

        begin
            $display("\nTestcase 002: Enable Signal Check");
            reset_dut();


            ena = 0;
            rwe = 1;
            rwa = 3'd5;
            rwd = 16'h5555;
            @(posedge clk);


            ena = 1;
            rwe = 0;
            rra = 3'd5;
            @(posedge clk);


            #1;



            check_outputs(16'h0000);
        end
        endtask

    task testcase003;

        begin
            $display("\nTestcase 003: Write Enable Check");
            reset_dut();


            ena = 1;
            rwe = 1;
            rwa = 3'd2;
            rwd = 16'h1111;
            @(posedge clk);


            rwe = 0;
            rwa = 3'd2;
            rwd = 16'hEEEE;
            @(posedge clk);


            rra = 3'd2;
            @(posedge clk);

            #1;


            check_outputs(16'h1111);
        end
        endtask

    task testcase004;

        begin
            $display("\nTestcase 004: Multiple Registers");
            reset_dut();
            ena = 1;
            rwe = 1;


            rwa = 3'd0; rwd = 16'hA000; @(posedge clk);

            rwa = 3'd7; rwd = 16'hA007; @(posedge clk);


            rwe = 0;
            rra = 3'd0;
            @(posedge clk);
            #1;
            if (rrd !== 16'hA000) $display("Subtest Reg0 Failed");


            rra = 3'd7;
            @(posedge clk);
            #1;

            check_outputs(16'hA007);
        end
        endtask

    task testcase005;

        begin
            $display("\nTestcase 005: Simultaneous Read and Write");
            reset_dut();
            ena = 1;


            rwe = 1; rwa = 3'd1; rwd = 16'h1234;
            @(posedge clk);


            rwe = 1; rwa = 3'd2; rwd = 16'h5678;
            rra = 3'd1;
            @(posedge clk);


            rra = 3'd2;
            rwe = 0;
            @(posedge clk);

            #1;


            check_outputs(16'h5678);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        
        
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
        input [15:0] expected_rrd;
        begin
            if (expected_rrd === (expected_rrd ^ rrd ^ expected_rrd)) begin
                $display("PASS");
                $display("  Outputs: rrd=%h",
                         rrd);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rrd=%h",
                         expected_rrd);
                $display("  Got:      rrd=%h",
                         rrd);
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
        $dumpvars(0,clk, ena, rra, rst, rwa, rwd, rwe, rrd);
    end

endmodule
