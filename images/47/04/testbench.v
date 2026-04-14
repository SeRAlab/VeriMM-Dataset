`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg ar;
    reg clk;
    reg en;
    wire [3:0] dig1;
    wire [3:0] dig2;
    wire [3:0] dig3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ar(ar),
        .clk(clk),
        .en(en),
        .dig1(dig1),
        .dig2(dig2),
        .dig3(dig3)
    );

    // Clock generation (10ns period)
    initial begin
        ar = 0;
        forever #5 ar = ~ar;
    end

        task reset_dut;

        begin
            ar = 0;
            en = 0;
            #(12);
            ar = 1;
            #(10);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Counting to 9", test_num);
            reset_dut();
            en = 1;
            repeat(9) @(posedge clk);
            #1;
            #1;

            check_outputs(4'd9, 4'd0, 4'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Overflow Dig1 (Count to 10)", test_num);
            reset_dut();
            en = 1;
            repeat(10) @(posedge clk);
            #1;
            #1;

            check_outputs(4'd0, 4'd1, 4'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Count to 55", test_num);
            reset_dut();
            en = 1;
            repeat(55) @(posedge clk);
            #1;
            #1;

            check_outputs(4'd5, 4'd5, 4'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Overflow Dig2 (Count to 100)", test_num);
            reset_dut();
            en = 1;
            repeat(100) @(posedge clk);
            #1;
            #1;

            check_outputs(4'd0, 4'd0, 4'd1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Count to 999", test_num);
            reset_dut();
            en = 1;
            repeat(999) @(posedge clk);
            #1;
            #1;

            check_outputs(4'd9, 4'd9, 4'd9);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Wrap around (Count to 1000)", test_num);
            reset_dut();
            en = 1;
            repeat(1000) @(posedge clk);
            #1;
            #1;

            check_outputs(4'd0, 4'd0, 4'd0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Enable signal toggle test", test_num);
            reset_dut();
            en = 1;
            repeat(5) @(posedge clk);
            en = 0;
            repeat(5) @(posedge clk);
            en = 1;
            repeat(3) @(posedge clk);
            #1;
            #1;

            check_outputs(4'd8, 4'd0, 4'd0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Asynchronous reset mid-count", test_num);
            reset_dut();
            en = 1;
            repeat(50) @(posedge clk);
            #2;
            ar = 0;
            #2;
            #1;

            check_outputs(4'd0, 4'd0, 4'd0);
            ar = 1;
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
        testcase008();
        
        
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
        input [3:0] expected_dig1;
        input [3:0] expected_dig2;
        input [3:0] expected_dig3;
        begin
            if (expected_dig1 === (expected_dig1 ^ dig1 ^ expected_dig1) &&
                expected_dig2 === (expected_dig2 ^ dig2 ^ expected_dig2) &&
                expected_dig3 === (expected_dig3 ^ dig3 ^ expected_dig3)) begin
                $display("PASS");
                $display("  Outputs: dig1=%h, dig2=%h, dig3=%h",
                         dig1, dig2, dig3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dig1=%h, dig2=%h, dig3=%h",
                         expected_dig1, expected_dig2, expected_dig3);
                $display("  Got:      dig1=%h, dig2=%h, dig3=%h",
                         dig1, dig2, dig3);
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
        $dumpvars(0,ar, clk, en, dig1, dig2, dig3);
    end

endmodule
