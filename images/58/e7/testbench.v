`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg adj_clk;
    reg adjust;
    reg clk;
    wire clock;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .adj_clk(adj_clk),
        .adjust(adjust),
        .clk(clk),
        .clock(clock)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Select primary clock (adjust=0) when clk is low", test_num);
            adjust = 0;
            clk = 0;
            adj_clk = 1;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Select primary clock (adjust=0) when clk is high", test_num);
            adjust = 0;
            clk = 1;
            adj_clk = 0;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Select alternative clock (adjust=1) when adj_clk is high", test_num);
            adjust = 1;
            clk = 0;
            adj_clk = 1;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Select alternative clock (adjust=1) when adj_clk is low", test_num);
            adjust = 1;
            clk = 1;
            adj_clk = 0;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Verify clk toggling does not affect output when adjust=1", test_num);
            adjust = 1;
            adj_clk = 1;
            clk = 1; #5;
            clk = 0; #5;
            clk = 1;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Verify adj_clk toggling does not affect output when adjust=0", test_num);
            adjust = 0;
            clk = 0;
            adj_clk = 0; #5;
            adj_clk = 1; #5;
            adj_clk = 0;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Switching from clk to adj_clk dynamically", test_num);

            adjust = 0;
            clk = 0;
            adj_clk = 1;
            #5;

            adjust = 1;
            #1;

            check_outputs(1);
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
        input expected_clock;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_clock === (expected_clock ^ clock ^ expected_clock)) begin
                $display("PASS");
                $display("  Outputs: clock=%b",
                         clock);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: clock=%b",
                         expected_clock);
                $display("  Got:      clock=%b",
                         clock);
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

endmodule
