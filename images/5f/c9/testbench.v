`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    wire usb_dn;
    wire usb_dp;
    wire usb_dp_pu;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .usb_dn(usb_dn),
        .usb_dp(usb_dp),
        .usb_dp_pu(usb_dp_pu)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Checking initial state of USB lines...", test_num);

            #1;


            check_outputs(1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Checking stability of USB lines after 100ns delay...", test_num);
            #100;

            #1;


            check_outputs(1'b0, 1'b0, 1'b0);
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
        input expected_usb_dn;
        input expected_usb_dp;
        input expected_usb_dp_pu;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_usb_dn === (expected_usb_dn ^ usb_dn ^ expected_usb_dn) &&
                expected_usb_dp === (expected_usb_dp ^ usb_dp ^ expected_usb_dp) &&
                expected_usb_dp_pu === (expected_usb_dp_pu ^ usb_dp_pu ^ expected_usb_dp_pu)) begin
                $display("PASS");
                $display("  Outputs: usb_dn=%b, usb_dp=%b, usb_dp_pu=%b",
                         usb_dn, usb_dp, usb_dp_pu);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: usb_dn=%b, usb_dp=%b, usb_dp_pu=%b",
                         expected_usb_dn, expected_usb_dp, expected_usb_dp_pu);
                $display("  Got:      usb_dn=%b, usb_dp=%b, usb_dp_pu=%b",
                         usb_dn, usb_dp, usb_dp_pu);
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
