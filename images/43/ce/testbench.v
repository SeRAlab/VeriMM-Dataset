`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg sub;
    wire overflow;
    wire [3:0] sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .sub(sub),
        .overflow(overflow),
        .sum(sum)
    );
    task testcase001;

        begin
            test_num = 1;
            A = 4'd5; B = 4'd3; sub = 1'b0;
            $display("Testcase %0d: Addition (5 + 3)", test_num);
            #1;

            check_outputs(1'b0, 4'd8);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            A = 4'd10; B = 4'd5; sub = 1'b0;
            $display("Testcase %0d: Addition (10 + 5 = 15 boundary)", test_num);
            #1;

            check_outputs(1'b0, 4'd15);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            A = 4'd8; B = 4'd8; sub = 1'b0;
            $display("Testcase %0d: Addition (8 + 8 = 16 overflow)", test_num);
            #1;

            check_outputs(1'b1, 4'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            A = 4'd15; B = 4'd15; sub = 1'b0;
            $display("Testcase %0d: Addition (15 + 15 = 30 overflow)", test_num);
            #1;

            check_outputs(1'b1, 4'd14);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            A = 4'd10; B = 4'd4; sub = 1'b1;
            $display("Testcase %0d: Subtraction (10 - 4)", test_num);
            #1;

            check_outputs(1'b0, 4'd6);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            A = 4'd7; B = 4'd7; sub = 1'b1;
            $display("Testcase %0d: Subtraction (7 - 7 = 0 boundary)", test_num);
            #1;

            check_outputs(1'b0, 4'd0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            A = 4'd3; B = 4'd5; sub = 1'b1;
            $display("Testcase %0d: Subtraction (3 - 5 = -2 overflow)", test_num);
            #1;

            check_outputs(1'b1, 4'd14);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            A = 4'd0; B = 4'd15; sub = 1'b1;
            $display("Testcase %0d: Subtraction (0 - 15 = -15 overflow)", test_num);
            #1;

            check_outputs(1'b1, 4'd1);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            A = 4'd0; B = 4'd0; sub = 1'b0;
            $display("Testcase %0d: Addition (0 + 0)", test_num);
            #1;

            check_outputs(1'b0, 4'd0);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            A = 4'd15; B = 4'd0; sub = 1'b1;
            $display("Testcase %0d: Subtraction (15 - 0)", test_num);
            #1;

            check_outputs(1'b0, 4'd15);
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
        input expected_overflow;
        input [3:0] expected_sum;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_overflow === (expected_overflow ^ overflow ^ expected_overflow) &&
                expected_sum === (expected_sum ^ sum ^ expected_sum)) begin
                $display("PASS");
                $display("  Outputs: overflow=%b, sum=%h",
                         overflow, sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: overflow=%b, sum=%h",
                         expected_overflow, expected_sum);
                $display("  Got:      overflow=%b, sum=%h",
                         overflow, sum);
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
