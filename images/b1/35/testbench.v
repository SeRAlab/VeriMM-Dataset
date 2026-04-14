`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg in_x;
    reg in_y;
    wire out_carry;
    wire out_sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in_x(in_x),
        .in_y(in_y),
        .out_carry(out_carry),
        .out_sum(out_sum)
    );
    task testcase001;

        begin
            test_num = 1;
            in_x = 1'b0;
            in_y = 1'b0;
            $display("Test Case %0d: in_x=%b, in_y=%b", test_num, in_x, in_y);
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            in_x = 1'b0;
            in_y = 1'b1;
            $display("Test Case %0d: in_x=%b, in_y=%b", test_num, in_x, in_y);
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            in_x = 1'b1;
            in_y = 1'b0;
            $display("Test Case %0d: in_x=%b, in_y=%b", test_num, in_x, in_y);
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            in_x = 1'b1;
            in_y = 1'b1;
            $display("Test Case %0d: in_x=%b, in_y=%b", test_num, in_x, in_y);
            #1;

            check_outputs(1'b1, 1'b0);
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
        input expected_out_carry;
        input expected_out_sum;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out_carry === (expected_out_carry ^ out_carry ^ expected_out_carry) &&
                expected_out_sum === (expected_out_sum ^ out_sum ^ expected_out_sum)) begin
                $display("PASS");
                $display("  Outputs: out_carry=%b, out_sum=%b",
                         out_carry, out_sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_carry=%b, out_sum=%b",
                         expected_out_carry, expected_out_sum);
                $display("  Got:      out_carry=%b, out_sum=%b",
                         out_carry, out_sum);
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
