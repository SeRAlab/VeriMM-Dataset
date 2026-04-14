`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] a;
    reg add_sub;
    reg [3:0] b;
    wire overflow;
    wire [3:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .add_sub(add_sub),
        .b(b),
        .overflow(overflow),
        .result(result)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test %0d: Simple Addition (3 + 2)", test_num);
        a = 4'd3; b = 4'd2; add_sub = 1'b1;
        #1;

        check_outputs(1'b0, 4'd5);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %0d: Simple Subtraction (5 - 2)", test_num);
        a = 4'd5; b = 4'd2; add_sub = 1'b0;
        #1;

        check_outputs(1'b0, 4'd3);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %0d: Addition Overflow (7 + 1)", test_num);
        a = 4'b0111; b = 4'b0001; add_sub = 1'b1;
        #1;

        check_outputs(1'b1, 4'b1000);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %0d: Addition Overflow (-5 + -4)", test_num);
        a = 4'b1011; b = 4'b1100; add_sub = 1'b1;
        #1;

        check_outputs(1'b1, 4'b0111);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %0d: Subtraction Overflow (4 - -5)", test_num);
        a = 4'b0100; b = 4'b1011; add_sub = 1'b0;
        #1;

        check_outputs(1'b1, 4'b1001);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test %0d: Subtraction Overflow (-6 - 3)", test_num);
        a = 4'b1010; b = 4'b0011; add_sub = 1'b0;
        #1;

        check_outputs(1'b1, 4'b0111);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test %0d: Boundary Addition (-8 + 0)", test_num);
        a = 4'b1000; b = 4'b0000; add_sub = 1'b1;
        #1;

        check_outputs(1'b0, 4'b1000);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test %0d: Boundary Subtraction (-7 - 1)", test_num);
        a = 4'b1001; b = 4'b0001; add_sub = 1'b0;
        #1;

        check_outputs(1'b0, 4'b1000);
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
        input expected_overflow;
        input [3:0] expected_result;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_overflow === (expected_overflow ^ overflow ^ expected_overflow) &&
                expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: overflow=%b, result=%h",
                         overflow, result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: overflow=%b, result=%h",
                         expected_overflow, expected_result);
                $display("  Got:      overflow=%b, result=%h",
                         overflow, result);
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
