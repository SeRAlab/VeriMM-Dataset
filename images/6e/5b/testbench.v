`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] input_x;
    reg [7:0] input_y;
    wire [7:0] output_and;
    wire [7:0] output_cmp;
    wire [7:0] output_sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .input_x(input_x),
        .input_y(input_y),
        .output_and(output_and),
        .output_cmp(output_cmp),
        .output_sum(output_sum)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: All Zeros", test_num);
            input_x = 8'h00;
            input_y = 8'h00;

            #1;


            check_outputs(8'h00, 8'h01, 8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: X is Zero, Y is Non-Zero", test_num);
            input_x = 8'h00;
            input_y = 8'hFF;

            #1;


            check_outputs(8'h00, 8'h01, 8'hFF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: X is Non-Zero, Y is Zero", test_num);
            input_x = 8'hA5;
            input_y = 8'h00;

            #1;


            check_outputs(8'h00, 8'h00, 8'hA5);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Addition with Overflow", test_num);
            input_x = 8'h80;
            input_y = 8'h81;

            #1;


            check_outputs(8'h80, 8'h00, 8'h01);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Bitwise AND Logic", test_num);
            input_x = 8'hAA;
            input_y = 8'h55;

            #1;


            check_outputs(8'h00, 8'h00, 8'hFF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Maximum Values", test_num);
            input_x = 8'hFF;
            input_y = 8'hFF;

            #1;


            check_outputs(8'hFF, 8'h00, 8'hFE);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Comparison Boundary (X=1)", test_num);
            input_x = 8'h01;
            input_y = 8'hEE;

            #1;


            check_outputs(8'h00, 8'h00, 8'hEF);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Random Mixing", test_num);
            input_x = 8'h12;
            input_y = 8'h34;

            #1;


            check_outputs(8'h10, 8'h00, 8'h46);
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
        input [7:0] expected_output_and;
        input [7:0] expected_output_cmp;
        input [7:0] expected_output_sum;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_output_and === (expected_output_and ^ output_and ^ expected_output_and) &&
                expected_output_cmp === (expected_output_cmp ^ output_cmp ^ expected_output_cmp) &&
                expected_output_sum === (expected_output_sum ^ output_sum ^ expected_output_sum)) begin
                $display("PASS");
                $display("  Outputs: output_and=%h, output_cmp=%h, output_sum=%h",
                         output_and, output_cmp, output_sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: output_and=%h, output_cmp=%h, output_sum=%h",
                         expected_output_and, expected_output_cmp, expected_output_sum);
                $display("  Got:      output_and=%h, output_cmp=%h, output_sum=%h",
                         output_and, output_cmp, output_sum);
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
