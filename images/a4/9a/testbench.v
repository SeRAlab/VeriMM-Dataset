`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] input1;
    reg [7:0] input2;
    wire [15:0] add_output;
    wire [15:0] mul_output;
    wire [15:0] sub_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .input1(input1),
        .input2(input2),
        .add_output(add_output),
        .mul_output(mul_output),
        .sub_output(sub_output)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Basic arithmetic with small positive integers", test_num);
            input1 = 8'd10;
            input2 = 8'd5;

            #1;


            check_outputs(16'd15, 16'd50, 16'd5);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Zero inputs", test_num);
            input1 = 8'd0;
            input2 = 8'd0;

            #1;


            check_outputs(16'd0, 16'd0, 16'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Maximum input values", test_num);
            input1 = 8'hFF;
            input2 = 8'hFF;

            #1;


            check_outputs(16'h01FE, 16'hFE01, 16'h0000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Subtraction resulting in a negative value (underflow logic)", test_num);
            input1 = 8'd10;
            input2 = 8'd20;

            #1;


            check_outputs(16'd30, 16'd200, 16'hFFF6);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Multiplication by zero and maximum value", test_num);
            input1 = 8'd255;
            input2 = 8'd0;

            #1;


            check_outputs(16'h00FF, 16'h0000, 16'h00FF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Power of two inputs", test_num);
            input1 = 8'd128;
            input2 = 8'd2;

            #1;


            check_outputs(16'd130, 16'd256, 16'd126);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Large product within range", test_num);
            input1 = 8'd200;
            input2 = 8'd100;

            #1;


            check_outputs(16'd300, 16'd20000, 16'd100);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: One subtracted from zero", test_num);
            input1 = 8'd0;
            input2 = 8'd1;

            #1;


            check_outputs(16'd1, 16'd0, 16'hFFFF);
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
        input [15:0] expected_add_output;
        input [15:0] expected_mul_output;
        input [15:0] expected_sub_output;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_add_output === (expected_add_output ^ add_output ^ expected_add_output) &&
                expected_mul_output === (expected_mul_output ^ mul_output ^ expected_mul_output) &&
                expected_sub_output === (expected_sub_output ^ sub_output ^ expected_sub_output)) begin
                $display("PASS");
                $display("  Outputs: add_output=%h, mul_output=%h, sub_output=%h",
                         add_output, mul_output, sub_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: add_output=%h, mul_output=%h, sub_output=%h",
                         expected_add_output, expected_mul_output, expected_sub_output);
                $display("  Got:      add_output=%h, mul_output=%h, sub_output=%h",
                         add_output, mul_output, sub_output);
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
