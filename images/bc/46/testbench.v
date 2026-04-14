`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    wire [3:0] an;
    wire [6:0] seg;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .reset(reset),
        .an(an),
        .seg(seg)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            repeat(2) @(posedge clk);
            #1 reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Initial Reset Check", test_num);
            reset_dut();
            @(posedge clk);
            #1;
            #1;

            check_outputs(AN_0, SEG_0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Increment to 9 seconds", test_num);
            reset_dut();
            repeat(9) @(posedge clk);
            #1;
            #1;

            check_outputs(AN_0, SEG_9);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Rollover to 1 minute, 1 second", test_num);
            reset_dut();
            repeat(61) @(posedge clk);
            #1;
            #1;

            check_outputs(AN_0, SEG_1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Rollover to 1 hour, 1 minute, 2 seconds", test_num);
            reset_dut();

            repeat(3662) @(posedge clk);
            #1;
            #1;

            check_outputs(AN_0, SEG_2);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Full 24-hour rollover", test_num);
            reset_dut();

            repeat(86400) @(posedge clk);
            #1;
            #1;

            check_outputs(AN_0, SEG_0);
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
        input [3:0] expected_an;
        input [6:0] expected_seg;
        begin
            if (expected_an === (expected_an ^ an ^ expected_an) &&
                expected_seg === (expected_seg ^ seg ^ expected_seg)) begin
                $display("PASS");
                $display("  Outputs: an=%h, seg=%h",
                         an, seg);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: an=%h, seg=%h",
                         expected_an, expected_seg);
                $display("  Got:      an=%h, seg=%h",
                         an, seg);
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
        $dumpvars(0,clk, reset, an, seg);
    end

endmodule
