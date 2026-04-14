`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg in;
    wire y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .in(in),
        .y(y)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            in = 0;
            repeat (4) @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Running testcase%03d: Basic 101 sequence", test_num);
            reset_dut();

            in = 1; @(posedge clk); #1;

            in = 0; @(posedge clk); #1;

            in = 1; @(posedge clk); #1;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Running testcase%03d: Incomplete sequence 100", test_num);
            reset_dut();
            in = 1; @(posedge clk); #1;
            in = 0; @(posedge clk); #1;
            in = 0; @(posedge clk); #1;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Running testcase%03d: Overlapping sequence 10101", test_num);
            reset_dut();
            in = 1; @(posedge clk); #1;
            in = 0; @(posedge clk); #1;
            in = 1; @(posedge clk); #1;
            in = 0; @(posedge clk); #1;
            in = 1; @(posedge clk); #1;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Running testcase%03d: Leading zeros before 101", test_num);
            reset_dut();
            in = 0; @(posedge clk); #1;
            in = 0; @(posedge clk); #1;
            in = 1; @(posedge clk); #1;
            in = 0; @(posedge clk); #1;
            in = 1; @(posedge clk); #1;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Running testcase%03d: Continuous ones", test_num);
            reset_dut();
            in = 1; @(posedge clk); #1;
            in = 1; @(posedge clk); #1;
            in = 1; @(posedge clk); #1;
            in = 1; @(posedge clk); #1;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Running testcase%03d: Broken sequence 1001", test_num);
            reset_dut();
            in = 1; @(posedge clk); #1;
            in = 0; @(posedge clk); #1;
            in = 0; @(posedge clk); #1;
            in = 1; @(posedge clk); #1;
            #1;

            check_outputs(0);
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
        input expected_y;
        begin
            if (expected_y === (expected_y ^ y ^ expected_y)) begin
                $display("PASS");
                $display("  Outputs: y=%b",
                         y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: y=%b",
                         expected_y);
                $display("  Got:      y=%b",
                         y);
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
        $dumpvars(0,clk, in, y);
    end

endmodule
