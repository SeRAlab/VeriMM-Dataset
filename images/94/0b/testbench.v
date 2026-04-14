`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    wire [3:0] output1;
    wire [3:0] output2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .reset(reset),
        .output1(output1),
        .output2(output2)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        @(posedge clk);
        #1 reset = 0;
    end
        endtask
    task testcase001;

    begin
        $display("Testcase 001: Checking initial state after reset...");
        test_num = test_num + 1;
        reset_dut();


        #1;



        check_outputs(4'h0, 4'hF);
    end
        endtask

    task testcase002;

    begin
        $display("Testcase 002: Checking count after 1 cycle...");
        test_num = test_num + 1;
        reset_dut();
        @(posedge clk);
        #1;
        #1;

        check_outputs(4'h1, 4'hE);
    end
        endtask

    task testcase003;

    begin
        $display("Testcase 003: Checking count after 8 cycles...");
        test_num = test_num + 1;
        reset_dut();
        repeat(8) @(posedge clk);
        #1;
        #1;

        check_outputs(4'h8, 4'h7);
    end
        endtask

    task testcase004;

    begin
        $display("Testcase 004: Checking count at max value (15)...");
        test_num = test_num + 1;
        reset_dut();
        repeat(15) @(posedge clk);
        #1;
        #1;

        check_outputs(4'hF, 4'h0);
    end
        endtask

    task testcase005;

    begin
        $display("Testcase 005: Checking rollover after 16 cycles...");
        test_num = test_num + 1;
        reset_dut();
        repeat(16) @(posedge clk);
        #1;
        #1;

        check_outputs(4'h0, 4'hF);
    end
        endtask

    task testcase006;

    begin
        $display("Testcase 006: Checking count after 33 cycles (multiple rollovers)...");
        test_num = test_num + 1;
        reset_dut();
        repeat(33) @(posedge clk);
        #1;
        #1;

        check_outputs(4'h1, 4'hE);
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
        input [3:0] expected_output1;
        input [3:0] expected_output2;
        begin
            if (expected_output1 === (expected_output1 ^ output1 ^ expected_output1) &&
                expected_output2 === (expected_output2 ^ output2 ^ expected_output2)) begin
                $display("PASS");
                $display("  Outputs: output1=%h, output2=%h",
                         output1, output2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: output1=%h, output2=%h",
                         expected_output1, expected_output2);
                $display("  Got:      output1=%h, output2=%h",
                         output1, output2);
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
        $dumpvars(0,clk, reset, output1, output2);
    end

endmodule
