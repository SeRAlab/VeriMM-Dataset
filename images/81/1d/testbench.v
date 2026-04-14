`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg ldin;
    reg ldout;
    wire vdin;
    wire vdout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ldin(ldin),
        .ldout(ldout),
        .vdin(vdin),
        .vdout(vdout)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: All signals low", test_num);
        ldin = 1'b0;
        ldout = 1'b0;
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: ldin high, ldout low", test_num);
        ldin = 1'b1;
        ldout = 1'b0;
        #1;

        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: ldin low, ldout high", test_num);
        ldin = 1'b0;
        ldout = 1'b1;
        #1;

        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: All signals high", test_num);
        ldin = 1'b1;
        ldout = 1'b1;
        #1;

        check_outputs(1'b1, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Toggle ldin", test_num);
        ldin = 1'b0; ldout = 1'b0;
        #5;
        ldin = 1'b1;
        #5;
        ldin = 1'b0;
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Toggle ldout", test_num);
        ldin = 1'b0; ldout = 1'b0;
        #5;
        ldout = 1'b1;
        #5;
        ldout = 1'b0;
        #1;

        check_outputs(1'b0, 1'b0);
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
        input expected_vdin;
        input expected_vdout;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_vdin === (expected_vdin ^ vdin ^ expected_vdin) &&
                expected_vdout === (expected_vdout ^ vdout ^ expected_vdout)) begin
                $display("PASS");
                $display("  Outputs: vdin=%b, vdout=%b",
                         vdin, vdout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: vdin=%b, vdout=%b",
                         expected_vdin, expected_vdout);
                $display("  Got:      vdin=%b, vdout=%b",
                         vdin, vdout);
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
