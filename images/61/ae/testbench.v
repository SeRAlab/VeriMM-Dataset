`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg r;
    reg s;
    wire q;
    wire qnot;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .r(r),
        .s(s),
        .q(q),
        .qnot(qnot)
    );
    task testcase001;

    begin
        test_num = 1;

        s = 1'b0;
        r = 1'b1;
        #10;
        #1;

        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;

        s = 1'b0; r = 1'b1;
        #10;

        s = 1'b1;
        r = 1'b0;
        #10;
        #1;

        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;

        s = 1'b0; r = 1'b1;
        #10;

        s = 1'b1; r = 1'b0;
        #10;

        s = 1'b1; r = 1'b1;
        #10;
        #1;

        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;

        s = 1'b1; r = 1'b0;
        #10;

        s = 1'b0; r = 1'b1;
        #10;

        s = 1'b1; r = 1'b1;
        #10;
        #1;

        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;

        s = 1'b0; r = 1'b1;
        #10;

        s = 1'b0;
        r = 1'b0;
        #10;
        #1;

        check_outputs(1'b1, 1'b1);
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
        input expected_q;
        input expected_qnot;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_q === (expected_q ^ q ^ expected_q) &&
                expected_qnot === (expected_qnot ^ qnot ^ expected_qnot)) begin
                $display("PASS");
                $display("  Outputs: q=%b, qnot=%b",
                         q, qnot);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%b, qnot=%b",
                         expected_q, expected_qnot);
                $display("  Got:      q=%b, qnot=%b",
                         q, qnot);
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
