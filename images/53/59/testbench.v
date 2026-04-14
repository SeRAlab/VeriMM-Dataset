`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg s;
    reg x;
    wire y0;
    wire y1;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .s(s),
        .x(x),
        .y0(y0),
        .y1(y1)
    );
    task testcase001;

        begin
            test_num = 1;
            s = 1'b0;
            x = 1'b0;
            $display("Test Case %0d: s=0 (Select y0), x=0", test_num);
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            s = 1'b0;
            x = 1'b1;
            $display("Test Case %0d: s=0 (Select y0), x=1", test_num);
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            s = 1'b1;
            x = 1'b0;
            $display("Test Case %0d: s=1 (Select y1), x=0", test_num);
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            s = 1'b1;
            x = 1'b1;
            $display("Test Case %0d: s=1 (Select y1), x=1", test_num);
            #1;

            check_outputs(1'b0, 1'b1);
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
        input expected_y0;
        input expected_y1;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_y0 === (expected_y0 ^ y0 ^ expected_y0) &&
                expected_y1 === (expected_y1 ^ y1 ^ expected_y1)) begin
                $display("PASS");
                $display("  Outputs: y0=%b, y1=%b",
                         y0, y1);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: y0=%b, y1=%b",
                         expected_y0, expected_y1);
                $display("  Got:      y0=%b, y1=%b",
                         y0, y1);
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
