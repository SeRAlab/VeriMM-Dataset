`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg data_in;
    reg [3:0] power_in;
    wire data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .data_in(data_in),
        .power_in(power_in),
        .data_out(data_out)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case 001: data_in=1, power_in=10 (Active Match)");
            data_in = 1'b1;
            power_in = 4'd10;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case 002: data_in=0, power_in=10 (Active Match)");
            data_in = 1'b0;
            power_in = 4'd10;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case 003: data_in=1, power_in=9 (Mismatch)");
            data_in = 1'b1;
            power_in = 4'd9;
            #1;

            check_outputs(1'bx);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case 004: data_in=0, power_in=11 (Mismatch)");
            data_in = 1'b0;
            power_in = 4'd11;
            #1;

            check_outputs(1'bx);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case 005: data_in=1, power_in=0 (Minimum Mismatch)");
            data_in = 1'b1;
            power_in = 4'd0;
            #1;

            check_outputs(1'bx);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case 006: data_in=0, power_in=15 (Maximum Mismatch)");
            data_in = 1'b0;
            power_in = 4'd15;
            #1;

            check_outputs(1'bx);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case 007: data_in=1, power_in=5 (Random Mismatch)");
            data_in = 1'b1;
            power_in = 4'd5;
            #1;

            check_outputs(1'bx);
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
        input expected_data_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%b",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%b",
                         expected_data_out);
                $display("  Got:      data_out=%b",
                         data_out);
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
