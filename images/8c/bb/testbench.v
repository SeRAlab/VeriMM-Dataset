`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg carry_in;
    reg [7:0] input1;
    reg [7:0] input2;
    wire carry_out;
    wire overflow_flag;
    wire [7:0] sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .carry_in(carry_in),
        .input1(input1),
        .input2(input2),
        .carry_out(carry_out),
        .overflow_flag(overflow_flag),
        .sum(sum)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Basic Addition (No carry)", test_num);
            input1 = 8'd10;
            input2 = 8'd20;
            carry_in = 1'b0;

            #1;


            check_outputs(1'b0, 1'b0, 8'd30);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Basic Addition with Carry-In", test_num);
            input1 = 8'd15;
            input2 = 8'd5;
            carry_in = 1'b1;

            #1;


            check_outputs(1'b0, 1'b0, 8'd21);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Sum exactly 255 (Boundary)", test_num);
            input1 = 8'd250;
            input2 = 8'd5;
            carry_in = 1'b0;

            #1;


            check_outputs(1'b0, 1'b0, 8'd255);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Sum triggers carry/overflow (256)", test_num);
            input1 = 8'd255;
            input2 = 8'd1;
            carry_in = 1'b0;

            #1;


            check_outputs(1'b1, 1'b1, 8'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Max inputs with Carry-In", test_num);
            input1 = 8'd255;
            input2 = 8'd255;
            carry_in = 1'b1;


            #1;



            check_outputs(1'b1, 1'b1, 8'd255);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Zero inputs with Carry-In", test_num);
            input1 = 8'd0;
            input2 = 8'd0;
            carry_in = 1'b1;

            #1;


            check_outputs(1'b0, 1'b0, 8'd1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Mid-range overflow", test_num);
            input1 = 8'd128;
            input2 = 8'd128;
            carry_in = 1'b0;

            #1;


            check_outputs(1'b1, 1'b1, 8'd0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: All inputs Zero", test_num);
            input1 = 8'd0;
            input2 = 8'd0;
            carry_in = 1'b0;

            #1;


            check_outputs(1'b0, 1'b0, 8'd0);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Large sum with carry_in", test_num);
            input1 = 8'd200;
            input2 = 8'd100;
            carry_in = 1'b1;


            #1;



            check_outputs(1'b1, 1'b1, 8'd45);
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
        input expected_carry_out;
        input expected_overflow_flag;
        input [7:0] expected_sum;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_carry_out === (expected_carry_out ^ carry_out ^ expected_carry_out) &&
                expected_overflow_flag === (expected_overflow_flag ^ overflow_flag ^ expected_overflow_flag) &&
                expected_sum === (expected_sum ^ sum ^ expected_sum)) begin
                $display("PASS");
                $display("  Outputs: carry_out=%b, overflow_flag=%b, sum=%h",
                         carry_out, overflow_flag, sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: carry_out=%b, overflow_flag=%b, sum=%h",
                         expected_carry_out, expected_overflow_flag, expected_sum);
                $display("  Got:      carry_out=%b, overflow_flag=%b, sum=%h",
                         carry_out, overflow_flag, sum);
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
