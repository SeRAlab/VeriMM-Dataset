`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] pll_value;
    wire [5:0] high;
    wire [5:0] low;
    wire w_edge;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .pll_value(pll_value),
        .high(high),
        .low(low),
        .w_edge(w_edge)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All zeros", test_num);
            pll_value = 8'h00;



            #1;




            check_outputs(6'd1, 6'd0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Upper6 zero, LSB one", test_num);
            pll_value = 8'h01;



            #1;




            check_outputs(6'd1, 6'd1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verify bit 1 ignored", test_num);
            pll_value = 8'h03;

            #1;


            check_outputs(6'd1, 6'd1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Upper6=1, LSB=0", test_num);
            pll_value = 8'h04;



            #1;




            check_outputs(6'd1, 6'd1, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Upper6=1, LSB=1", test_num);
            pll_value = 8'h05;



            #1;




            check_outputs(6'd1, 6'd2, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Mid-range value", test_num);
            pll_value = 8'hA8;



            #1;




            check_outputs(6'd42, 6'd42, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Max Upper6, LSB=0", test_num);
            pll_value = 8'hFC;



            #1;




            check_outputs(6'd63, 6'd63, 1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Max Upper6, LSB=1 (Low Overflow)", test_num);
            pll_value = 8'hFD;



            #1;




            check_outputs(6'd63, 6'd0, 1'b1);
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
        input [5:0] expected_high;
        input [5:0] expected_low;
        input expected_w_edge;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_high === (expected_high ^ high ^ expected_high) &&
                expected_low === (expected_low ^ low ^ expected_low) &&
                expected_w_edge === (expected_w_edge ^ w_edge ^ expected_w_edge)) begin
                $display("PASS");
                $display("  Outputs: high=%h, low=%h, w_edge=%b",
                         high, low, w_edge);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: high=%h, low=%h, w_edge=%b",
                         expected_high, expected_low, expected_w_edge);
                $display("  Got:      high=%h, low=%h, w_edge=%b",
                         high, low, w_edge);
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
