`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg UDP_IN;
    reg VGND;
    reg VPWR;
    wire UDP_OUT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .UDP_IN(UDP_IN),
        .VGND(VGND),
        .VPWR(VPWR),
        .UDP_OUT(UDP_OUT)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: All signals low", test_num);
        UDP_IN = 0;
        VPWR = 0;
        VGND = 0;
        #1;

        check_outputs(0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: UDP_IN High, VPWR Low (Fault Condition)", test_num);
        UDP_IN = 1;
        VPWR = 0;
        VGND = 0;
        #1;

        check_outputs(1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: UDP_IN Low, VPWR High (Normal Power)", test_num);
        UDP_IN = 0;
        VPWR = 1;
        VGND = 0;
        #1;

        check_outputs(0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: Both UDP_IN and VPWR High", test_num);
        UDP_IN = 1;
        VPWR = 1;
        VGND = 0;
        #1;

        check_outputs(0);
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
        input expected_UDP_OUT;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_UDP_OUT === (expected_UDP_OUT ^ UDP_OUT ^ expected_UDP_OUT)) begin
                $display("PASS");
                $display("  Outputs: UDP_OUT=%b",
                         UDP_OUT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: UDP_OUT=%b",
                         expected_UDP_OUT);
                $display("  Got:      UDP_OUT=%b",
                         UDP_OUT);
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
