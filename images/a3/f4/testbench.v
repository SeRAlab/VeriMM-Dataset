`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] binary_input;
    wire [3:0] bcd_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .binary_input(binary_input),
        .bcd_output(bcd_output)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Binary Input = 0", test_num);
            binary_input = 4'd0;
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Binary Input = 5", test_num);
            binary_input = 4'd5;
            #1;

            check_outputs(4'd5);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Binary Input = 9", test_num);
            binary_input = 4'd9;
            #1;

            check_outputs(4'd9);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Binary Input = 10 (Invalid, expect 0)", test_num);
            binary_input = 4'd10;
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Binary Input = 13 (Invalid, expect 0)", test_num);
            binary_input = 4'd13;
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Binary Input = 15 (Invalid, expect 0)", test_num);
            binary_input = 4'd15;
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Binary Input = 3", test_num);
            binary_input = 4'd3;
            #1;

            check_outputs(4'd3);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Binary Input = 8", test_num);
            binary_input = 4'd8;
            #1;

            check_outputs(4'd8);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Binary Input = 11 (Invalid, expect 0)", test_num);
            binary_input = 4'd11;
            #1;

            check_outputs(4'd0);
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
        input [3:0] expected_bcd_output;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_bcd_output === (expected_bcd_output ^ bcd_output ^ expected_bcd_output)) begin
                $display("PASS");
                $display("  Outputs: bcd_output=%h",
                         bcd_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: bcd_output=%h",
                         expected_bcd_output);
                $display("  Got:      bcd_output=%h",
                         bcd_output);
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
