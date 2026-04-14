`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg sub;
    wire [3:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .sub(sub),
        .result(result)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        A = 4'd1; B = 4'd2; sub = 1'b0;
        $display("Test %0d: Addition (1 + 2)", test_num);
        #1;

        check_outputs(4'd3);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        A = 4'd13; B = 4'd5; sub = 1'b0;
        $display("Test %0d: Addition with Overflow (13 + 5)", test_num);
        #1;

        check_outputs(4'd2);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        A = 4'd10; B = 4'd3; sub = 1'b1;
        $display("Test %0d: Subtraction (10 - 3)", test_num);
        #1;

        check_outputs(4'd7);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        A = 4'd3; B = 4'd10; sub = 1'b1;
        $display("Test %0d: Subtraction with Negative Result (3 - 10)", test_num);

        #1;


        check_outputs(4'd9);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        A = 4'd15; B = 4'd15; sub = 1'b0;
        $display("Test %0d: Addition Max Values (15 + 15)", test_num);
        #1;

        check_outputs(4'd14);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        A = 4'd0; B = 4'd0; sub = 1'b1;
        $display("Test %0d: Subtraction Zero (0 - 0)", test_num);
        #1;

        check_outputs(4'd0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        A = 4'd0; B = 4'd1; sub = 1'b1;
        $display("Test %0d: Subtraction Underflow (0 - 1)", test_num);
        #1;

        check_outputs(4'd15);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        A = 4'd8; B = 4'd8; sub = 1'b0;
        $display("Test %0d: Addition resulting in 0 (8 + 8)", test_num);
        #1;

        check_outputs(4'd0);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        A = 4'd7; B = 4'd7; sub = 1'b1;
        $display("Test %0d: Subtraction same values (7 - 7)", test_num);
        #1;

        check_outputs(4'd0);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        A = 4'd8; B = 4'd1; sub = 1'b1;
        $display("Test %0d: Subtraction from MSB (8 - 1)", test_num);
        #1;

        check_outputs(4'd7);
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
        input [3:0] expected_result;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: result=%h",
                         result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: result=%h",
                         expected_result);
                $display("  Got:      result=%h",
                         result);
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
