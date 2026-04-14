`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg SUB;
    wire OVFL;
    wire [3:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .SUB(SUB),
        .OVFL(OVFL),
        .result(result)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Addition 2 + 3", test_num);
        A = 4'b0010;
        B = 4'b0011;
        SUB = 1'b0;
        #1;

        check_outputs(1'b0, 4'b0101);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Addition 7 + 1 (Expected Overflow)", test_num);
        A = 4'b0111;
        B = 4'b0001;
        SUB = 1'b0;
        #1;

        check_outputs(1'b1, 4'b1000);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Addition -1 + -1", test_num);
        A = 4'b1111;
        B = 4'b1111;
        SUB = 1'b0;
        #1;

        check_outputs(1'b0, 4'b1110);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Addition -5 + -4 (Expected Overflow)", test_num);
        A = 4'b1011;
        B = 4'b1100;
        SUB = 1'b0;
        #1;

        check_outputs(1'b1, 4'b0111);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Subtraction 5 - 2", test_num);
        A = 4'b0101;
        B = 4'b0010;
        SUB = 1'b1;
        #1;

        check_outputs(1'b0, 4'b0011);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Subtraction 5 - (-4) (Expected Overflow)", test_num);
        A = 4'b0101;
        B = 4'b1100;
        SUB = 1'b1;
        #1;

        check_outputs(1'b1, 4'b1001);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Subtraction -6 - 3 (Expected Overflow)", test_num);
        A = 4'b1010;
        B = 4'b0011;
        SUB = 1'b1;
        #1;

        check_outputs(1'b1, 4'b0111);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Subtraction -8 - (-8)", test_num);
        A = 4'b1000;
        B = 4'b1000;
        SUB = 1'b1;
        #1;

        check_outputs(1'b0, 4'b0000);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Subtraction 0 - (-8) (Expected Overflow)", test_num);
        A = 4'b0000;
        B = 4'b1000;
        SUB = 1'b1;
        #1;

        check_outputs(1'b1, 4'b1000);
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
        input expected_OVFL;
        input [3:0] expected_result;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_OVFL === (expected_OVFL ^ OVFL ^ expected_OVFL) &&
                expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: OVFL=%b, result=%h",
                         OVFL, result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: OVFL=%b, result=%h",
                         expected_OVFL, expected_result);
                $display("  Got:      OVFL=%b, result=%h",
                         OVFL, result);
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
