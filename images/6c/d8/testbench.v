`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] A;
    reg [31:0] B;
    wire overflow;
    wire [31:0] sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .overflow(overflow),
        .sum(sum)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Simple positive addition (no overflow)", test_num);
            A = 32'h00000005;
            B = 32'h0000000A;
            #1;

            check_outputs(1'b0, 32'h0000000F);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Positive and negative addition (no overflow)", test_num);
            A = 32'h0000000A;
            B = 32'hFFFFFFF6;
            #1;

            check_outputs(1'b0, 32'h00000000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Max positive plus zero (no overflow)", test_num);
            A = 32'h7FFFFFFF;
            B = 32'h00000000;
            #1;

            check_outputs(1'b0, 32'h7FFFFFFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Max positive plus one (overflow occurs)", test_num);
            A = 32'h7FFFFFFF;
            B = 32'h00000001;
            #1;

            check_outputs(1'b1, 32'h80000000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Min negative plus minus one (overflow occurs)", test_num);
            A = 32'h80000000;
            B = 32'hFFFFFFFF;
            #1;

            check_outputs(1'b1, 32'h7FFFFFFF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Large negative addition (no overflow)", test_num);
            A = 32'hC0000000;
            B = 32'hC0000000;
            #1;

            check_outputs(1'b0, 32'h80000000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Two's complement zero check", test_num);
            A = 32'h00000000;
            B = 32'h00000000;
            #1;

            check_outputs(1'b0, 32'h00000000);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Adding -1 and -1 (no overflow)", test_num);
            A = 32'hFFFFFFFF;
            B = 32'hFFFFFFFF;
            #1;

            check_outputs(1'b0, 32'hFFFFFFFE);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Positive overflow with large values", test_num);
            A = 32'h40000000;
            B = 32'h40000000;
            #1;

            check_outputs(1'b1, 32'h80000000);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Maximum possible overflow", test_num);
            A = 32'h7FFFFFFF;
            B = 32'h7FFFFFFF;
            #1;

            check_outputs(1'b1, 32'hFFFFFFFE);
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
        input [31:0] expected_sum;
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
