`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg m_ctlout;
    reg zero;
    wire PCSrc;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .m_ctlout(m_ctlout),
        .zero(zero),
        .PCSrc(PCSrc)
    );
    task testcase001;

    begin
        test_num = 1;
        m_ctlout = 0;
        zero = 0;
        $display("Testcase %0d: m_ctlout = 0, zero = 0", test_num);
        #1;

        check_outputs(0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        m_ctlout = 0;
        zero = 1;
        $display("Testcase %0d: m_ctlout = 0, zero = 1", test_num);
        #1;

        check_outputs(0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        m_ctlout = 1;
        zero = 0;
        $display("Testcase %0d: m_ctlout = 1, zero = 0", test_num);
        #1;

        check_outputs(0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        m_ctlout = 1;
        zero = 1;
        $display("Testcase %0d: m_ctlout = 1, zero = 1", test_num);
        #1;

        check_outputs(1);
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
        input expected_PCSrc;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_PCSrc === (expected_PCSrc ^ PCSrc ^ expected_PCSrc)) begin
                $display("PASS");
                $display("  Outputs: PCSrc=%b",
                         PCSrc);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: PCSrc=%b",
                         expected_PCSrc);
                $display("  Got:      PCSrc=%b",
                         PCSrc);
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
