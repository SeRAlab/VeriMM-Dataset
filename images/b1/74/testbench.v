`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg DIODE;
    reg VGND;
    reg VPWR;
    wire RECTIFIED_SIGNAL;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .DIODE(DIODE),
        .VGND(VGND),
        .VPWR(VPWR),
        .RECTIFIED_SIGNAL(RECTIFIED_SIGNAL)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: DIODE input High, Power Supply Active", test_num);

            VPWR = 1'b1;
            VGND = 1'b0;

            DIODE = 1'b1;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: DIODE input Low, Power Supply Active", test_num);

            VPWR = 1'b1;
            VGND = 1'b0;

            DIODE = 1'b0;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Transition from Low to High", test_num);
            VPWR = 1'b1;
            VGND = 1'b0;
            DIODE = 1'b0;
            #10;
            DIODE = 1'b1;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Transition from High to Low", test_num);
            VPWR = 1'b1;
            VGND = 1'b0;
            DIODE = 1'b1;
            #10;
            DIODE = 1'b0;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Rapid input toggle check", test_num);
            VPWR = 1'b1;
            VGND = 1'b0;
            DIODE = 1'b0; #5;
            DIODE = 1'b1; #5;
            DIODE = 1'b0; #5;
            DIODE = 1'b1;

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
        input expected_RECTIFIED_SIGNAL;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_RECTIFIED_SIGNAL === (expected_RECTIFIED_SIGNAL ^ RECTIFIED_SIGNAL ^ expected_RECTIFIED_SIGNAL)) begin
                $display("PASS");
                $display("  Outputs: RECTIFIED_SIGNAL=%b",
                         RECTIFIED_SIGNAL);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: RECTIFIED_SIGNAL=%b",
                         expected_RECTIFIED_SIGNAL);
                $display("  Got:      RECTIFIED_SIGNAL=%b",
                         RECTIFIED_SIGNAL);
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
