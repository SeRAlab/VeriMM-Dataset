`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] d0_i;
    reg [7:0] d10_i;
    reg [7:0] d11_i;
    reg [7:0] d12_i;
    reg [7:0] d13_i;
    reg [7:0] d14_i;
    reg [7:0] d15_i;
    reg [7:0] d1_i;
    reg [7:0] d2_i;
    reg [7:0] d3_i;
    reg [7:0] d4_i;
    reg [7:0] d5_i;
    reg [7:0] d6_i;
    reg [7:0] d7_i;
    reg [7:0] d8_i;
    reg [7:0] d9_i;
    reg [3:0] selector_i;
    wire [7:0] d_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .d0_i(d0_i),
        .d10_i(d10_i),
        .d11_i(d11_i),
        .d12_i(d12_i),
        .d13_i(d13_i),
        .d14_i(d14_i),
        .d15_i(d15_i),
        .d1_i(d1_i),
        .d2_i(d2_i),
        .d3_i(d3_i),
        .d4_i(d4_i),
        .d5_i(d5_i),
        .d6_i(d6_i),
        .d7_i(d7_i),
        .d8_i(d8_i),
        .d9_i(d9_i),
        .selector_i(selector_i),
        .d_o(d_o)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Select d0_i", test_num);
            d0_i = 8'hA0; d1_i = 8'hA1; d2_i = 8'hA2; d3_i = 8'hA3;
            d4_i = 8'hA4; d5_i = 8'hA5; d6_i = 8'hA6; d7_i = 8'hA7;
            d8_i = 8'hA8; d9_i = 8'hA9; d10_i = 8'hAA; d11_i = 8'hAB;
            d12_i = 8'hAC; d13_i = 8'hAD; d14_i = 8'hAE; d15_i = 8'hAF;
            selector_i = 4'd0;
            #1;

            check_outputs(8'hA0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Select d1_i", test_num);
            selector_i = 4'd1;
            #1;

            check_outputs(8'hA1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Select d4_i", test_num);
            selector_i = 4'd4;
            #1;

            check_outputs(8'hA4);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Select d7_i", test_num);
            selector_i = 4'd7;
            #1;

            check_outputs(8'hA7);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Select d8_i", test_num);
            selector_i = 4'd8;
            #1;

            check_outputs(8'hA8);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Select d12_i", test_num);
            selector_i = 4'd12;
            #1;

            check_outputs(8'hAC);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Select d15_i", test_num);
            selector_i = 4'd15;
            #1;

            check_outputs(8'hAF);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: Change d15_i value", test_num);
            selector_i = 4'd15;
            d15_i = 8'hFF;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Testcase %0d: Change d0_i value", test_num);
            selector_i = 4'd0;
            d0_i = 8'h00;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Testcase %0d: Selector 10 with all ones", test_num);
            d10_i = 8'hFF;
            selector_i = 4'd10;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase011;

        begin
            test_num = 11;
            $display("Testcase %0d: Select d9_i", test_num);
            d9_i = 8'h55;
            selector_i = 4'd9;
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase012;

        begin
            test_num = 12;
            $display("Testcase %0d: Select d3_i", test_num);
            d3_i = 8'hAA;
            selector_i = 4'd3;
            #1;

            check_outputs(8'hAA);
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
        testcase010();
        testcase011();
        testcase012();
        
        
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
        input [7:0] expected_d_o;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_d_o === (expected_d_o ^ d_o ^ expected_d_o)) begin
                $display("PASS");
                $display("  Outputs: d_o=%h",
                         d_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: d_o=%h",
                         expected_d_o);
                $display("  Got:      d_o=%h",
                         d_o);
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
