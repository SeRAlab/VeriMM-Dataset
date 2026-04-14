`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] a;
    reg [31:0] b;
    reg carry_in;
    wire carry_out;
    wire [31:0] sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .carry_in(carry_in),
        .carry_out(carry_out),
        .sum(sum)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Zero addition", test_num);
            a = 32'h00000000;
            b = 32'h00000000;
            carry_in = 1'b0;
            #1;

            check_outputs(1'b0, 32'h00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Carry-in only", test_num);
            a = 32'h00000000;
            b = 32'h00000000;
            carry_in = 1'b1;
            #1;

            check_outputs(1'b0, 32'h00000001);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Basic addition (no overflow)", test_num);
            a = 32'h12345678;
            b = 32'h11111111;
            carry_in = 1'b0;
            #1;

            check_outputs(1'b0, 32'h23456789);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Maximum sum without overflow", test_num);
            a = 32'hFFFFFFFF;
            b = 32'h00000000;
            carry_in = 1'b0;
            #1;

            check_outputs(1'b0, 32'hFFFFFFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Minimum carry-out (0xFFFFFFFF + 1)", test_num);
            a = 32'hFFFFFFFF;
            b = 32'h00000000;
            carry_in = 1'b1;
            #1;

            check_outputs(1'b1, 32'h00000000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Overflow with two large values", test_num);
            a = 32'h80000000;
            b = 32'h80000000;
            carry_in = 1'b0;
            #1;

            check_outputs(1'b1, 32'h00000000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating bits", test_num);
            a = 32'hAAAAAAAA;
            b = 32'h55555555;
            carry_in = 1'b0;
            #1;

            check_outputs(1'b0, 32'hFFFFFFFF);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating bits with carry-in", test_num);
            a = 32'hAAAAAAAA;
            b = 32'h55555555;
            carry_in = 1'b1;
            #1;

            check_outputs(1'b1, 32'h00000000);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Maximum possible inputs", test_num);
            a = 32'hFFFFFFFF;
            b = 32'hFFFFFFFF;
            carry_in = 1'b1;
            #1;

            check_outputs(1'b1, 32'hFFFFFFFF);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Random pattern", test_num);
            a = 32'h1234ABCD;
            b = 32'hFEDC5432;
            carry_in = 1'b1;


            #1;



            check_outputs(1'b1, 32'h11110000);
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
        input [31:0] expected_sum;
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
