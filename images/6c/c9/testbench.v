`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg bw_pll_2xclk_b;
    wire bw_pll_2x_clk_local_b;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .bw_pll_2xclk_b(bw_pll_2xclk_b),
        .bw_pll_2x_clk_local_b(bw_pll_2x_clk_local_b)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Input Low (0)", test_num);
        bw_pll_2xclk_b = 1'b0;
        #10;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Input High (1)", test_num);
        bw_pll_2xclk_b = 1'b1;
        #10;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Pulse sequence 0->1->0", test_num);
        bw_pll_2xclk_b = 1'b0;
        #5;
        bw_pll_2xclk_b = 1'b1;
        #5;
        bw_pll_2xclk_b = 1'b0;
        #5;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Pulse sequence 1->0->1", test_num);
        bw_pll_2xclk_b = 1'b1;
        #5;
        bw_pll_2xclk_b = 1'b0;
        #5;
        bw_pll_2xclk_b = 1'b1;
        #5;
        #1;

        check_outputs(1'b1);
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
        input expected_bw_pll_2x_clk_local_b;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_bw_pll_2x_clk_local_b === (expected_bw_pll_2x_clk_local_b ^ bw_pll_2x_clk_local_b ^ expected_bw_pll_2x_clk_local_b)) begin
                $display("PASS");
                $display("  Outputs: bw_pll_2x_clk_local_b=%b",
                         bw_pll_2x_clk_local_b);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: bw_pll_2x_clk_local_b=%b",
                         expected_bw_pll_2x_clk_local_b);
                $display("  Got:      bw_pll_2x_clk_local_b=%b",
                         bw_pll_2x_clk_local_b);
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
