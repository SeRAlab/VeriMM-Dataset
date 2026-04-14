`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] a;
    reg [3:0] b;
    reg sub;
    wire [3:0] sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .sub(sub),
        .sum(sum)
    );
    task testcase001;

    begin
        test_num = 1;
        a = 4'd3;
        b = 4'd4;
        sub = 1'b0;
        $display("Test %0d: Addition (3 + 4)", test_num);
        #1;

        check_outputs(4'd7);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        a = 4'd12;
        b = 4'd5;
        sub = 1'b0;
        $display("Test %0d: Addition with overflow (12 + 5)", test_num);
        #1;

        check_outputs(4'd1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        a = 4'd15;
        b = 4'd0;
        sub = 1'b0;
        $display("Test %0d: Addition with zero (15 + 0)", test_num);
        #1;

        check_outputs(4'd15);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        a = 4'd10;
        b = 4'd3;
        sub = 1'b1;
        $display("Test %0d: Subtraction (10 - 3)", test_num);
        #1;

        check_outputs(4'd7);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        a = 4'd5;
        b = 4'd5;
        sub = 1'b1;
        $display("Test %0d: Subtraction to zero (5 - 5)", test_num);
        #1;

        check_outputs(4'd0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        a = 4'd2;
        b = 4'd5;
        sub = 1'b1;
        $display("Test %0d: Subtraction with negative result (2 - 5)", test_num);
        #1;

        check_outputs(4'd13);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        a = 4'd0;
        b = 4'd1;
        sub = 1'b1;
        $display("Test %0d: Subtraction from zero (0 - 1)", test_num);
        #1;

        check_outputs(4'd15);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        a = 4'd15;
        b = 4'd15;
        sub = 1'b0;
        $display("Test %0d: Max values addition (15 + 15)", test_num);
        #1;

        check_outputs(4'd14);
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
        input [3:0] expected_sum;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_sum === (expected_sum ^ sum ^ expected_sum)) begin
                $display("PASS");
                $display("  Outputs: sum=%h",
                         sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: sum=%h",
                         expected_sum);
                $display("  Got:      sum=%h",
                         sum);
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
