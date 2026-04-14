`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg MODE;
    wire BOUT;
    wire COUT;
    wire [3:0] RESULT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .MODE(MODE),
        .BOUT(BOUT),
        .COUT(COUT),
        .RESULT(RESULT)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Addition (5 + 3), MODE=0", test_num);
            A = 4'd5;
            B = 4'd3;
            MODE = 1'b0;
            #1;

            check_outputs(1'b0, 1'b0, 4'd8);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Addition with carry (12 + 8), MODE=0", test_num);
            A = 4'd12;
            B = 4'd8;
            MODE = 1'b0;
            #1;

            check_outputs(1'b0, 1'b1, 4'd4);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Addition (15 + 15), MODE=0", test_num);
            A = 4'd15;
            B = 4'd15;
            MODE = 1'b0;
            #1;

            check_outputs(1'b0, 1'b1, 4'd14);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Addition (0 + 0), MODE=0", test_num);
            A = 4'd0;
            B = 4'd0;
            MODE = 1'b0;
            #1;

            check_outputs(1'b0, 1'b0, 4'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Subtraction (10 - 4), MODE=1", test_num);
            A = 4'd10;
            B = 4'd4;
            MODE = 1'b1;
            #1;

            check_outputs(1'b0, 1'b0, 4'd6);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Subtraction (7 - 7), MODE=1", test_num);
            A = 4'd7;
            B = 4'd7;
            MODE = 1'b1;
            #1;

            check_outputs(1'b0, 1'b0, 4'd0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Subtraction with borrow (3 - 8), MODE=1", test_num);
            A = 4'd3;
            B = 4'd8;
            MODE = 1'b1;
            #1;

            check_outputs(1'b1, 1'b0, 4'd11);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Subtraction (0 - 15), MODE=1", test_num);
            A = 4'd0;
            B = 4'd15;
            MODE = 1'b1;
            #1;

            check_outputs(1'b1, 1'b0, 4'd1);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: MODE transition check (15 - 1 -> 15 + 1)", test_num);
            A = 4'd15;
            B = 4'd1;
            MODE = 1'b1; #5;
            MODE = 1'b0;
            #1;

            check_outputs(1'b0, 1'b1, 4'd0);
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
        input expected_BOUT;
        input expected_COUT;
        input [3:0] expected_RESULT;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_BOUT === (expected_BOUT ^ BOUT ^ expected_BOUT) &&
                expected_COUT === (expected_COUT ^ COUT ^ expected_COUT) &&
                expected_RESULT === (expected_RESULT ^ RESULT ^ expected_RESULT)) begin
                $display("PASS");
                $display("  Outputs: BOUT=%b, COUT=%b, RESULT=%h",
                         BOUT, COUT, RESULT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: BOUT=%b, COUT=%b, RESULT=%h",
                         expected_BOUT, expected_COUT, expected_RESULT);
                $display("  Got:      BOUT=%b, COUT=%b, RESULT=%h",
                         BOUT, COUT, RESULT);
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
