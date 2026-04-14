`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    wire [7:0] y1;
    wire [7:0] y2;
    wire [7:0] y3;
    wire [7:0] y4;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .y1(y1),
        .y2(y2),
        .y3(y3),
        .y4(y4)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case 001: Initial constant output check");

            #1;


            check_outputs(8'h01, 8'h02, 8'h03, 8'h05);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case 002: Stability check after time delay");
            #100;
            #1;

            check_outputs(8'h01, 8'h02, 8'h03, 8'h05);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case 003: Final consistency check");
            #10;
            #1;

            check_outputs(8'h01, 8'h02, 8'h03, 8'h05);
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
        input [7:0] expected_y1;
        input [7:0] expected_y2;
        input [7:0] expected_y3;
        input [7:0] expected_y4;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_y1 === (expected_y1 ^ y1 ^ expected_y1) &&
                expected_y2 === (expected_y2 ^ y2 ^ expected_y2) &&
                expected_y3 === (expected_y3 ^ y3 ^ expected_y3) &&
                expected_y4 === (expected_y4 ^ y4 ^ expected_y4)) begin
                $display("PASS");
                $display("  Outputs: y1=%h, y2=%h, y3=%h, y4=%h",
                         y1, y2, y3, y4);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: y1=%h, y2=%h, y3=%h, y4=%h",
                         expected_y1, expected_y2, expected_y3, expected_y4);
                $display("  Got:      y1=%h, y2=%h, y3=%h, y4=%h",
                         y1, y2, y3, y4);
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
