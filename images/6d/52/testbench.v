`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg ctrlld;
    reg wdogdis;
    reg wdtripce;
    reg [7:0] wrtdata;
    wire [7:0] controlrdata;
    wire motorenaint;
    wire run0;
    wire run1;
    wire run2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .ctrlld(ctrlld),
        .wdogdis(wdogdis),
        .wdtripce(wdtripce),
        .wrtdata(wrtdata),
        .controlrdata(controlrdata),
        .motorenaint(motorenaint),
        .run0(run0),
        .run1(run1),
        .run2(run2)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            ctrlld = 0;
            wdtripce = 1;
            wdogdis = 0;
            wrtdata = 8'h00;
            @(posedge clk);
            #1;
            wdtripce = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Test Case 001: Default Reset State");
            reset_dut();

            #1;


            check_outputs(8'h00, 0, 0, 0, 0);
        end
        endtask

    task testcase002;

        begin
            $display("Test Case 002: Load Register with 0x0F (All active)");
            reset_dut();
            ctrlld = 1;
            wrtdata = 8'h0F;
            @(posedge clk);
            #1;
            ctrlld = 0;

            #1;


            check_outputs(8'h0F, 1, 1, 1, 1);
        end
        endtask

    task testcase003;

        begin
            $display("Test Case 003: Bit Mapping Check (0x05)");
            reset_dut();
            ctrlld = 1;
            wrtdata = 8'h05;
            @(posedge clk);
            #1;
            ctrlld = 0;

            #1;


            check_outputs(8'h05, 0, 1, 0, 1);
        end
        endtask

    task testcase004;

        begin
            $display("Test Case 004: Write Disable (ctrlld=0)");
            reset_dut();
            ctrlld = 0;
            wrtdata = 8'hFF;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h00, 0, 0, 0, 0);
        end
        endtask

    task testcase005;

        begin
            $display("Test Case 005: Watchdog Trip Effect");
            reset_dut();

            ctrlld = 1;
            wrtdata = 8'hAA;
            @(posedge clk);
            #1;

            ctrlld = 0;
            wdtripce = 1;
            @(posedge clk);
            #1;
            wdtripce = 0;

            #1;


            check_outputs(8'h00, 0, 0, 0, 0);
        end
        endtask

    task testcase006;

        begin
            $display("Test Case 006: High Nibble Persistence");
            reset_dut();
            ctrlld = 1;
            wrtdata = 8'hF0;
            @(posedge clk);
            #1;
            ctrlld = 0;

            #1;


            check_outputs(8'hF0, 0, 0, 0, 0);
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
        input [7:0] expected_controlrdata;
        input expected_motorenaint;
        input expected_run0;
        input expected_run1;
        input expected_run2;
        begin
            if (expected_controlrdata === (expected_controlrdata ^ controlrdata ^ expected_controlrdata) &&
                expected_motorenaint === (expected_motorenaint ^ motorenaint ^ expected_motorenaint) &&
                expected_run0 === (expected_run0 ^ run0 ^ expected_run0) &&
                expected_run1 === (expected_run1 ^ run1 ^ expected_run1) &&
                expected_run2 === (expected_run2 ^ run2 ^ expected_run2)) begin
                $display("PASS");
                $display("  Outputs: controlrdata=%h, motorenaint=%b, run0=%b, run1=%b, run2=%b",
                         controlrdata, motorenaint, run0, run1, run2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: controlrdata=%h, motorenaint=%b, run0=%b, run1=%b, run2=%b",
                         expected_controlrdata, expected_motorenaint, expected_run0, expected_run1, expected_run2);
                $display("  Got:      controlrdata=%h, motorenaint=%b, run0=%b, run1=%b, run2=%b",
                         controlrdata, motorenaint, run0, run1, run2);
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
        $dumpvars(0,clk, ctrlld, wdogdis, wdtripce, wrtdata, controlrdata, motorenaint, run0, run1, run2);
    end

endmodule
