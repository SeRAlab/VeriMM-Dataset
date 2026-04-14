`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg down;
    reg reset;
    reg up;
    wire [9:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .down(down),
        .reset(reset),
        .up(up),
        .count(count)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        up = 0;
        down = 0;
        @(posedge clk);
        #1;
        reset = 0;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase 001: Checking Reset state (expecting 512)");
        reset_dut();
        @(posedge clk);
        #1;
        #1;

        check_outputs(10'd512);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase 002: Counting up 10 times (512 -> 522)");
        reset_dut();
        up = 1;
        repeat(10) @(posedge clk);
        up = 0;
        #1;
        #1;

        check_outputs(10'd522);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase 003: Counting down 20 times (512 -> 492)");
        reset_dut();
        down = 1;
        repeat(20) @(posedge clk);
        down = 0;
        #1;
        #1;

        check_outputs(10'd492);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase 004: Counting up to overflow (512 + 512 = 1024 -> 0)");
        reset_dut();
        up = 1;
        repeat(512) @(posedge clk);
        up = 0;
        #1;
        #1;

        check_outputs(10'd0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase 005: Counting down to underflow (512 - 513 = -1 -> 1023)");
        reset_dut();
        down = 1;
        repeat(513) @(posedge clk);
        down = 0;
        #1;
        #1;

        check_outputs(10'h3FF);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase 006: Simultaneous Up and Down (Counter should stay at 512)");
        reset_dut();
        up = 1;
        down = 1;
        repeat(10) @(posedge clk);
        up = 0;
        down = 0;
        #1;
        #1;

        check_outputs(10'd512);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase 007: Interleaved Up and Down (512 + 5 - 2 = 515)");
        reset_dut();
        up = 1;
        repeat(5) @(posedge clk);
        up = 0;
        down = 1;
        repeat(2) @(posedge clk);
        down = 0;
        #1;
        #1;

        check_outputs(10'd515);
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
        input [9:0] expected_count;
        begin
            if (expected_count === (expected_count ^ count ^ expected_count)) begin
                $display("PASS");
                $display("  Outputs: count=%h",
                         count);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count=%h",
                         expected_count);
                $display("  Got:      count=%h",
                         count);
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
        $dumpvars(0,clk, down, reset, up, count);
    end

endmodule
