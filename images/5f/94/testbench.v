`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] adg_int;
    reg async_reset_neg;
    reg fb_clk;
    reg fb_tag_r;
    reg fb_we_r;
    wire output_signal;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .adg_int(adg_int),
        .async_reset_neg(async_reset_neg),
        .fb_clk(fb_clk),
        .fb_tag_r(fb_tag_r),
        .fb_we_r(fb_we_r),
        .output_signal(output_signal)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test %0d: Active Low Reset is Active (async_reset_neg=0)", test_num);

        async_reset_neg = 1'b0;
        fb_clk = 1'b1;
        adg_int = 32'h00000001;
        fb_tag_r = 1'b1;
        fb_we_r = 1'b0;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %0d: All conditions met except fb_clk is LOW", test_num);
        async_reset_neg = 1'b1;
        fb_clk = 1'b0;
        adg_int = 32'h00000001;
        fb_tag_r = 1'b1;
        fb_we_r = 1'b0;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %0d: All conditions met except adg_int is negative", test_num);
        async_reset_neg = 1'b1;
        fb_clk = 1'b1;
        adg_int = 32'h80000000;
        fb_tag_r = 1'b1;
        fb_we_r = 1'b0;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %0d: All conditions met except fb_tag_r is inactive", test_num);
        async_reset_neg = 1'b1;
        fb_clk = 1'b1;
        adg_int = 32'h00000005;
        fb_tag_r = 1'b0;
        fb_we_r = 1'b0;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %0d: All conditions met except fb_we_r is active", test_num);
        async_reset_neg = 1'b1;
        fb_clk = 1'b1;
        adg_int = 32'h00000005;
        fb_tag_r = 1'b1;
        fb_we_r = 1'b1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test %0d: All conditions met (Success Case)", test_num);
        async_reset_neg = 1'b1;
        fb_clk = 1'b1;
        adg_int = 32'h0000FFFF;
        fb_tag_r = 1'b1;
        fb_we_r = 1'b0;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test %0d: Boundary condition - adg_int is zero (non-negative)", test_num);
        async_reset_neg = 1'b1;
        fb_clk = 1'b1;
        adg_int = 32'h00000000;
        fb_tag_r = 1'b1;
        fb_we_r = 1'b0;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test %0d: Boundary condition - adg_int is max positive", test_num);
        async_reset_neg = 1'b1;
        fb_clk = 1'b1;
        adg_int = 32'h7FFFFFFF;
        fb_tag_r = 1'b1;
        fb_we_r = 1'b0;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test %0d: Multiple conditions failing", test_num);
        async_reset_neg = 1'b0;
        fb_clk = 1'b0;
        adg_int = 32'hFFFFFFFF;
        fb_tag_r = 1'b0;
        fb_we_r = 1'b1;
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
        testcase008();
        testcase009();
        
        
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
        input expected_output_signal;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_output_signal === (expected_output_signal ^ output_signal ^ expected_output_signal)) begin
                $display("PASS");
                $display("  Outputs: output_signal=%b",
                         output_signal);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: output_signal=%b",
                         expected_output_signal);
                $display("  Got:      output_signal=%b",
                         output_signal);
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
