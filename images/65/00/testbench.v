`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] a;
    reg [3:0] b;
    wire overflow;
    wire [3:0] sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .overflow(overflow),
        .sum(sum)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Zero inputs", test_num);
            a = 4'd0;
            b = 4'd0;
            #1;

            check_outputs(1'b0, 4'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Small sum (no overflow)", test_num);
            a = 4'd5;
            b = 4'd3;
            #1;

            check_outputs(1'b0, 4'd8);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Maximum sum without overflow (sum=15)", test_num);
            a = 4'd7;
            b = 4'd8;
            #1;

            check_outputs(1'b0, 4'd15);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Minimum overflow (sum=16)", test_num);
            a = 4'd8;
            b = 4'd8;
            #1;

            check_outputs(1'b1, 4'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Maximum inputs (sum=30)", test_num);
            a = 4'd15;
            b = 4'd15;
            #1;

            check_outputs(1'b1, 4'd14);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Overflow with non-zero result", test_num);
            a = 4'd10;
            b = 4'd10;
            #1;

            check_outputs(1'b1, 4'd4);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Input near boundary (sum=16)", test_num);
            a = 4'd15;
            b = 4'd1;
            #1;

            check_outputs(1'b1, 4'd0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: Addition with zero", test_num);
            a = 4'd0;
            b = 4'd15;
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
