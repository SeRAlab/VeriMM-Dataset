`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg choose_bit;
    reg [31:0] input_0;
    reg [31:0] input_1;
    wire [31:0] next;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .choose_bit(choose_bit),
        .input_0(input_0),
        .input_1(input_1),
        .next(next)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %03d: Select input_0 (pattern AAAAAAAA)", test_num);
            input_0 = 32'hAAAAAAAA;
            input_1 = 32'h55555555;
            choose_bit = 1'b0;
            #1;

            check_outputs(32'hAAAAAAAA);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %03d: Select input_1 (pattern 55555555)", test_num);
            input_0 = 32'hAAAAAAAA;
            input_1 = 32'h55555555;
            choose_bit = 1'b1;
            #1;

            check_outputs(32'h55555555);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %03d: Select input_0 (All Fs)", test_num);
            input_0 = 32'hFFFFFFFF;
            input_1 = 32'h00000000;
            choose_bit = 1'b0;
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %03d: Select input_1 (All 0s)", test_num);
            input_0 = 32'hFFFFFFFF;
            input_1 = 32'h00000000;
            choose_bit = 1'b1;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %03d: Select input_0 (Mixed Hex)", test_num);
            input_0 = 32'hDEADBEEF;
            input_1 = 32'hCAFEBABE;
            choose_bit = 1'b0;
            #1;

            check_outputs(32'hDEADBEEF);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %03d: Select input_1 (Mixed Hex)", test_num);
            input_0 = 32'hDEADBEEF;
            input_1 = 32'hCAFEBABE;
            choose_bit = 1'b1;
            #1;

            check_outputs(32'hCAFEBABE);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case %03d: Single Bit input_0", test_num);
            input_0 = 32'h00000001;
            input_1 = 32'h80000000;
            choose_bit = 1'b0;
            #1;

            check_outputs(32'h00000001);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test Case %03d: Single Bit input_1", test_num);
            input_0 = 32'h00000001;
            input_1 = 32'h80000000;
            choose_bit = 1'b1;
            #1;

            check_outputs(32'h80000000);
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
        input [31:0] expected_next;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_next === (expected_next ^ next ^ expected_next)) begin
                $display("PASS");
                $display("  Outputs: next=%h",
                         next);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: next=%h",
                         expected_next);
                $display("  Got:      next=%h",
                         next);
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
