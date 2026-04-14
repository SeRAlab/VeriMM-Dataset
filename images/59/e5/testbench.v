`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] a;
    wire is_negative;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .is_negative(is_negative)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Zero (8'h00)", test_num);
            a = 8'h00;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Max positive (8'h7F)", test_num);
            a = 8'h7F;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Min negative (8'h80)", test_num);
            a = 8'h80;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: All ones (8'hFF)", test_num);
            a = 8'hFF;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Small positive (8'h05)", test_num);
            a = 8'h05;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Arbitrary negative (8'hA5)", test_num);
            a = 8'hA5;
            #1;

            check_outputs(1'b1);
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
        input expected_is_negative;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_is_negative === (expected_is_negative ^ is_negative ^ expected_is_negative)) begin
                $display("PASS");
                $display("  Outputs: is_negative=%b",
                         is_negative);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: is_negative=%b",
                         expected_is_negative);
                $display("  Got:      is_negative=%b",
                         is_negative);
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
