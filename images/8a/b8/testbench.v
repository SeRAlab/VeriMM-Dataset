`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] e;
    reg [15:0] s;
    wire [15:0] f;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .e(e),
        .s(s),
        .f(f)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Signal=0, Echo=0", test_num);
        s = 16'sd0;
        e = 16'sd0;
        #1;

        check_outputs(16'sd0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Positive signals, s > e", test_num);
        s = 16'sd1200;
        e = 16'sd400;
        #1;

        check_outputs(16'sd800);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Positive signals, s < e", test_num);
        s = 16'sd300;
        e = 16'sd1000;
        #1;

        check_outputs(-16'sd700);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Both signals negative", test_num);
        s = -16'sd500;
        e = -16'sd200;
        #1;

        check_outputs(-16'sd300);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Positive signal, Negative echo", test_num);
        s = 16'sd1000;
        e = -16'sd500;
        #1;

        check_outputs(16'sd1500);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Negative signal, Positive echo", test_num);
        s = -16'sd1000;
        e = 16'sd500;
        #1;

        check_outputs(-16'sd1500);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Maximum positive signal value", test_num);
        s = 16'sh7FFF;
        e = 16'sd0;
        #1;

        check_outputs(16'sh7FFF);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Minimum negative signal value", test_num);
        s = 16'sh8000;
        e = 16'sd0;
        #1;

        check_outputs(16'sh8000);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: s equals e (full cancellation)", test_num);
        s = 16'sd12345;
        e = 16'sd12345;
        #1;

        check_outputs(16'sd0);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: s equals e (negative full cancellation)", test_num);
        s = -16'sd9876;
        e = -16'sd9876;
        #1;

        check_outputs(16'sd0);
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
        testcase008();
        testcase009();
        testcase010();
        
        
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
        input [15:0] expected_f;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_f === (expected_f ^ f ^ expected_f)) begin
                $display("PASS");
                $display("  Outputs: f=%h",
                         f);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: f=%h",
                         expected_f);
                $display("  Got:      f=%h",
                         f);
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
