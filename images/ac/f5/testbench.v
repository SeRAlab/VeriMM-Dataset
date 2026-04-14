`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg VGND;
    reg VPWR;
    wire tap;
    wire tap_bar;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .VGND(VGND),
        .VPWR(VPWR),
        .tap(tap),
        .tap_bar(tap_bar)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Valid Power Condition (VPWR=1, VGND=0)", test_num);
        VPWR = 1'b1;
        VGND = 1'b0;
        #1;

        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: VPWR Indeterminate (VPWR=X, VGND=0)", test_num);
        VPWR = 1'bx;
        VGND = 1'b0;
        #1;

        check_outputs(1'bx, 1'bx);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: VGND Indeterminate (VPWR=1, VGND=X)", test_num);
        VPWR = 1'b1;
        VGND = 1'bx;
        #1;

        check_outputs(1'bx, 1'bx);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Both Rails Indeterminate (VPWR=X, VGND=X)", test_num);
        VPWR = 1'bx;
        VGND = 1'bx;
        #1;

        check_outputs(1'bx, 1'bx);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Power Down (VPWR=0, VGND=0)", test_num);
        VPWR = 1'b0;
        VGND = 1'b0;
        #1;

        check_outputs(1'bx, 1'bx);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Invalid Logic (VPWR=1, VGND=1)", test_num);
        VPWR = 1'b1;
        VGND = 1'b1;
        #1;

        check_outputs(1'bx, 1'bx);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Reversed Supplies (VPWR=0, VGND=1)", test_num);
        VPWR = 1'b0;
        VGND = 1'b1;
        #1;

        check_outputs(1'bx, 1'bx);
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
        input expected_tap;
        input expected_tap_bar;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_tap === (expected_tap ^ tap ^ expected_tap) &&
                expected_tap_bar === (expected_tap_bar ^ tap_bar ^ expected_tap_bar)) begin
                $display("PASS");
                $display("  Outputs: tap=%b, tap_bar=%b",
                         tap, tap_bar);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: tap=%b, tap_bar=%b",
                         expected_tap, expected_tap_bar);
                $display("  Got:      tap=%b, tap_bar=%b",
                         tap, tap_bar);
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
