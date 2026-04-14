`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg carry_in;
    reg [1:0] in1;
    reg [1:0] in2;
    wire carry_out;
    wire [1:0] sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .carry_in(carry_in),
        .in1(in1),
        .in2(in2),
        .carry_out(carry_out),
        .sum(sum)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: All zeros", test_num);
        in1 = 2'b00; in2 = 2'b00; carry_in = 1'b0;
        #1;

        check_outputs(1'b0, 2'b00);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Carry-in only", test_num);
        in1 = 2'b00; in2 = 2'b00; carry_in = 1'b1;
        #1;

        check_outputs(1'b0, 2'b01);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Sum 1+1, no carry-in", test_num);
        in1 = 2'b01; in2 = 2'b01; carry_in = 1'b0;
        #1;

        check_outputs(1'b0, 2'b10);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Sum 1+2, no carry-in", test_num);
        in1 = 2'b01; in2 = 2'b10; carry_in = 1'b0;
        #1;

        check_outputs(1'b0, 2'b11);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Sum 2+2, carry out generated", test_num);
        in1 = 2'b10; in2 = 2'b10; carry_in = 1'b0;
        #1;

        check_outputs(1'b1, 2'b00);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Sum 3+3, carry out generated", test_num);
        in1 = 2'b11; in2 = 2'b11; carry_in = 1'b0;
        #1;

        check_outputs(1'b1, 2'b10);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Max sum 3+3+1", test_num);
        in1 = 2'b11; in2 = 2'b11; carry_in = 1'b1;
        #1;

        check_outputs(1'b1, 2'b11);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Internal carry generation", test_num);
        in1 = 2'b01; in2 = 2'b01; carry_in = 1'b1;
        #1;

        check_outputs(1'b0, 2'b11);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Sum 2+1+1", test_num);
        in1 = 2'b10; in2 = 2'b01; carry_in = 1'b1;
        #1;

        check_outputs(1'b1, 2'b00);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Edge case 3+0+1", test_num);
        in1 = 2'b11; in2 = 2'b00; carry_in = 1'b1;
        #1;

        check_outputs(1'b1, 2'b00);
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
        input [1:0] expected_sum;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_carry_out === (expected_carry_out ^ carry_out ^ expected_carry_out) &&
                expected_sum === (expected_sum ^ sum ^ expected_sum)) begin
                $display("PASS");
                $display("  Outputs: carry_out=%b, sum=%h",
                         carry_out, sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: carry_out=%b, sum=%h",
                         expected_carry_out, expected_sum);
                $display("  Got:      carry_out=%b, sum=%h",
                         carry_out, sum);
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
