`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg DATA;
    reg LATCH;
    wire Q;
    wire QNOT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .DATA(DATA),
        .LATCH(LATCH),
        .Q(Q),
        .QNOT(QNOT)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %03d: Transparent Mode - Set Q High", test_num);
            DATA = 1'b1;
            LATCH = 1'b1;
            #10;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %03d: Hold Mode - Hold Q High while DATA changes", test_num);
            LATCH = 1'b0;
            #5;
            DATA = 1'b0;
            #10;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %03d: Transparent Mode - Set Q Low", test_num);
            DATA = 1'b0;
            LATCH = 1'b1;
            #10;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %03d: Hold Mode - Hold Q Low while DATA changes", test_num);
            LATCH = 1'b0;
            #5;
            DATA = 1'b1;
            #10;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %03d: Transparent Mode - Q follows toggling DATA", test_num);
            LATCH = 1'b1;
            DATA = 1'b1; #5;
            DATA = 1'b0; #5;
            DATA = 1'b1; #5;
            DATA = 1'b0; #5;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %03d: Verify QNOT is always inverse of Q", test_num);
            LATCH = 1'b1;
            DATA = 1'b1;
            #10;
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
        input expected_Q;
        input expected_QNOT;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Q === (expected_Q ^ Q ^ expected_Q) &&
                expected_QNOT === (expected_QNOT ^ QNOT ^ expected_QNOT)) begin
                $display("PASS");
                $display("  Outputs: Q=%b, QNOT=%b",
                         Q, QNOT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%b, QNOT=%b",
                         expected_Q, expected_QNOT);
                $display("  Got:      Q=%b, QNOT=%b",
                         Q, QNOT);
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
