`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] pll_M;
    reg [4:0] pll_N;
    reg [1:0] pll_OD;
    reg pll_RESET;
    reg pll_asleep;
    reg pllrefclk;
    wire plloutclk;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .pll_M(pll_M),
        .pll_N(pll_N),
        .pll_OD(pll_OD),
        .pll_RESET(pll_RESET),
        .pll_asleep(pll_asleep),
        .pllrefclk(pllrefclk),
        .plloutclk(plloutclk)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Normal Operation - Clock Low", test_num);
            pll_asleep = 0;
            pll_RESET = 0;
            pll_M = 8'd20;
            pll_N = 5'd2;
            pll_OD = 2'b01;
            pllrefclk = 0;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Normal Operation - Clock High", test_num);
            pll_asleep = 0;
            pll_RESET = 0;
            pll_M = 8'd20;
            pll_N = 5'd2;
            pll_OD = 2'b01;
            pllrefclk = 1;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Reset Mode - Clock Low", test_num);
            pll_asleep = 0;
            pll_RESET = 1;
            pll_M = 8'd10;
            pll_N = 5'd1;
            pll_OD = 2'b00;
            pllrefclk = 0;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Reset Mode - Clock High", test_num);
            pll_asleep = 0;
            pll_RESET = 1;
            pll_M = 8'd10;
            pll_N = 5'd1;
            pll_OD = 2'b00;
            pllrefclk = 1;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Sleep Mode - Clock Low", test_num);
            pll_asleep = 1;
            pll_RESET = 0;
            pll_M = 8'hFF;
            pll_N = 5'h1F;
            pll_OD = 2'b11;
            pllrefclk = 0;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Sleep Mode - Clock High", test_num);
            pll_asleep = 1;
            pll_RESET = 0;
            pll_M = 8'hFF;
            pll_N = 5'h1F;
            pll_OD = 2'b11;
            pllrefclk = 1;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Config Change - Large M", test_num);
            pll_asleep = 0;
            pll_RESET = 0;
            pll_M = 8'd255;
            pll_N = 5'd10;
            pll_OD = 2'b10;
            pllrefclk = 1;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: Config Change - Small N", test_num);
            pll_asleep = 0;
            pll_RESET = 0;
            pll_M = 8'd5;
            pll_N = 5'd0;
            pll_OD = 2'b00;
            pllrefclk = 0;
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
        input expected_plloutclk;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_plloutclk === (expected_plloutclk ^ plloutclk ^ expected_plloutclk)) begin
                $display("PASS");
                $display("  Outputs: plloutclk=%b",
                         plloutclk);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: plloutclk=%b",
                         expected_plloutclk);
                $display("  Got:      plloutclk=%b",
                         plloutclk);
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
