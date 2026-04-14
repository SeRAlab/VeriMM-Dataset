`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg bw_pll_2xclk;
    wire bw_pll_2x_clk_local;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .bw_pll_2xclk(bw_pll_2xclk),
        .bw_pll_2x_clk_local(bw_pll_2x_clk_local)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Input Low", test_num);
            bw_pll_2xclk = 1'b0;
            #10;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Input High", test_num);
            bw_pll_2xclk = 1'b1;
            #10;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Toggle Input Low-High-Low", test_num);
            bw_pll_2xclk = 1'b0;
            #5;
            bw_pll_2xclk = 1'b1;
            #5;
            bw_pll_2xclk = 1'b0;
            #10;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Toggle Input High-Low-High", test_num);
            bw_pll_2xclk = 1'b1;
            #5;
            bw_pll_2xclk = 1'b0;
            #5;
            bw_pll_2xclk = 1'b1;
            #10;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Simulate High Frequency (Final State Low)", test_num);
            repeat(10) begin
                bw_pll_2xclk = 1'b1;
                #2;
                bw_pll_2xclk = 1'b0;
                #2;
            end
            #10;
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
        input expected_bw_pll_2x_clk_local;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_bw_pll_2x_clk_local === (expected_bw_pll_2x_clk_local ^ bw_pll_2x_clk_local ^ expected_bw_pll_2x_clk_local)) begin
                $display("PASS");
                $display("  Outputs: bw_pll_2x_clk_local=%b",
                         bw_pll_2x_clk_local);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: bw_pll_2x_clk_local=%b",
                         expected_bw_pll_2x_clk_local);
                $display("  Got:      bw_pll_2x_clk_local=%b",
                         bw_pll_2x_clk_local);
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
