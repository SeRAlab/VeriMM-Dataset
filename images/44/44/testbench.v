`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg wHClk_i;
    reg wLClk_i;
    reg wReset_i;
    reg wTrig_i;
    wire wTrig_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .wHClk_i(wHClk_i),
        .wLClk_i(wLClk_i),
        .wReset_i(wReset_i),
        .wTrig_i(wTrig_i),
        .wTrig_o(wTrig_o)
    );

    // Clock generation (10ns period)
    initial begin
        wHClk_i = 0;
        forever #5 wHClk_i = ~wHClk_i;
    end

        task reset_dut;

    begin
        wReset_i = 1;
        wTrig_i = 0;
        repeat (5) @(posedge wHClk_i);
        wReset_i = 0;
        repeat (2) @(posedge wHClk_i);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %03d: Post-Reset Idle Check", test_num);
        reset_dut();
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %03d: Immediate Trigger Response", test_num);
        reset_dut();
        @(posedge wHClk_i);
        wTrig_i = 1;
        #1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %03d: Pulse Capture/Stretching", test_num);
        reset_dut();
        @(posedge wHClk_i);
        wTrig_i = 1;
        @(posedge wHClk_i);
        wTrig_i = 0;
        @(posedge wHClk_i);

        #1;


        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %03d: Return to IDLE after timeout", test_num);
        reset_dut();
        @(posedge wHClk_i);
        wTrig_i = 1;
        @(posedge wHClk_i);
        wTrig_i = 0;

        repeat (10) @(posedge wLClk_i);
        repeat (5) @(posedge wHClk_i);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %03d: Reset during active state", test_num);
        reset_dut();
        @(posedge wHClk_i);
        wTrig_i = 1;
        @(posedge wHClk_i);
        wReset_i = 1;
        repeat (2) @(posedge wHClk_i);
        #1;

        check_outputs(1'b0);
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
        input expected_wTrig_o;
        begin
            if (expected_wTrig_o === (expected_wTrig_o ^ wTrig_o ^ expected_wTrig_o)) begin
                $display("PASS");
                $display("  Outputs: wTrig_o=%b",
                         wTrig_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: wTrig_o=%b",
                         expected_wTrig_o);
                $display("  Got:      wTrig_o=%b",
                         wTrig_o);
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,wHClk_i, wLClk_i, wReset_i, wTrig_i, wTrig_o);
    end

endmodule
