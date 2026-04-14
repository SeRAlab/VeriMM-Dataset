`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] input_value;
    wire [15:0] output_value;
    wire sign_flag;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .input_value(input_value),
        .output_value(output_value),
        .sign_flag(sign_flag)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Zero input", test_num);
            input_value = 32'h0000_0000;
            #1;

            check_outputs(16'h0000, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Small positive input", test_num);
            input_value = 32'h0001_ABCD;
            #1;

            check_outputs(16'h0001, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Large positive input", test_num);
            input_value = 32'h5A5A_FFFF;
            #1;

            check_outputs(16'h5A5A, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Maximum positive input", test_num);
            input_value = 32'h7FFF_FFFF;
            #1;

            check_outputs(16'h7FFF, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Negative input (-1)", test_num);
            input_value = 32'hFFFF_FFFF;
            #1;

            check_outputs(16'hFFFF, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Large negative input", test_num);
            input_value = 32'hA5A5_0000;
            #1;

            check_outputs(16'hA5A5, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Minimum negative input", test_num);
            input_value = 32'h8000_0000;
            #1;

            check_outputs(16'h8000, 1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Pattern check", test_num);
            input_value = 32'h1234_5678;
            #1;

            check_outputs(16'h1234, 1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Bit boundary negative", test_num);
            input_value = 32'hFFFE_0000;
            #1;

            check_outputs(16'hFFFE, 1'b1);
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
        input [15:0] expected_output_value;
        input expected_sign_flag;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_output_value === (expected_output_value ^ output_value ^ expected_output_value) &&
                expected_sign_flag === (expected_sign_flag ^ sign_flag ^ expected_sign_flag)) begin
                $display("PASS");
                $display("  Outputs: output_value=%h, sign_flag=%b",
                         output_value, sign_flag);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: output_value=%h, sign_flag=%b",
                         expected_output_value, expected_sign_flag);
                $display("  Got:      output_value=%h, sign_flag=%b",
                         output_value, sign_flag);
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
