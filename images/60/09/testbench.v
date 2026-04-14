`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] parallel_data;
    reg reset;
    reg serial_data;
    wire match;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .parallel_data(parallel_data),
        .reset(reset),
        .serial_data(serial_data),
        .match(match)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        serial_data = 0;
        parallel_data = 8'h00;
        @(posedge clk);
        #1;
        reset = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        $display("Testcase 001: Initial Reset Check");
        reset_dut();

        #1;


        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        $display("Testcase 002: Matching 8'b10110011");
        reset_dut();
        parallel_data = 8'b10110011;
        shift_byte(8'b10110011);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        $display("Testcase 003: Mismatch check (8'b10110011 vs 10110010)");
        reset_dut();
        parallel_data = 8'b10110011;
        shift_byte(8'b10110010);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        $display("Testcase 004: All Zeros Match");
        reset_dut();
        parallel_data = 8'h00;
        shift_byte(8'h00);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        $display("Testcase 005: All Ones Match");
        reset_dut();
        parallel_data = 8'hFF;
        shift_byte(8'hFF);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase006;

    begin
        $display("Testcase 006: Sliding Window Pattern Match");
        reset_dut();
        parallel_data = 8'hAA;

        @(posedge clk); #1; serial_data = 1;
        shift_byte(8'hAA);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase007;

    begin
        $display("Testcase 007: Dynamic Parallel Data Change");
        reset_dut();
        parallel_data = 8'h55;
        shift_byte(8'h55);

        parallel_data = 8'hAA;
        @(posedge clk); #1;
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
        testcase006();
        testcase007();
        
        
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
        input expected_match;
        begin
            if (expected_match === (expected_match ^ match ^ expected_match)) begin
                $display("PASS");
                $display("  Outputs: match=%b",
                         match);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: match=%b",
                         expected_match);
                $display("  Got:      match=%b",
                         match);
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
        $dumpvars(0,clk, parallel_data, reset, serial_data, match);
    end

endmodule
