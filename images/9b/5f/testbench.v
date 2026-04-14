`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst_n;
    reg [7:0] shreg;
    wire a_i;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .rst_n(rst_n),
        .shreg(shreg),
        .a_i(a_i)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst_n = 0;
        shreg = 8'h00;
        @(posedge clk);
        #1;
        rst_n = 1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Running Testcase 001: Reset Check...");
        reset_dut();

        #1;


        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Running Testcase 002: Sample LSB=1...");
        reset_dut();
        shreg = 8'hA1;
        @(posedge clk);
        @(posedge clk);
        #2;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Running Testcase 003: Sample LSB=0...");
        reset_dut();
        shreg = 8'h32;
        @(posedge clk);
        @(posedge clk);
        #2;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Running Testcase 004: Sequential Bits (1 -> 0)...");
        reset_dut();

        shreg = 8'h01;
        @(posedge clk);

        shreg = 8'h00;
        @(posedge clk);

        @(posedge clk);
        #2;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Running Testcase 005: Mid-operation Reset...");
        reset_dut();

        shreg = 8'hFF;
        @(posedge clk);
        @(posedge clk);


        rst_n = 0;
        #2;
        #1;

        check_outputs(1'b0);
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
        input expected_a_i;
        begin
            if (expected_a_i === (expected_a_i ^ a_i ^ expected_a_i)) begin
                $display("PASS");
                $display("  Outputs: a_i=%b",
                         a_i);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: a_i=%b",
                         expected_a_i);
                $display("  Got:      a_i=%b",
                         a_i);
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
        $dumpvars(0,clk, rst_n, shreg, a_i);
    end

endmodule
