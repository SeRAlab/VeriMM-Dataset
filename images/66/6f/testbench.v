`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg iClock;
    reg iEmpty;
    reg iReady;
    reg iReset;
    wire oPopSignal;
    wire oValid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .iClock(iClock),
        .iEmpty(iEmpty),
        .iReady(iReady),
        .iReset(iReset),
        .oPopSignal(oPopSignal),
        .oValid(oValid)
    );

    // Clock generation (10ns period)
    initial begin
        iClock = 0;
        forever #5 iClock = ~iClock;
    end

        task reset_dut;

        begin
            iReset = 1;
            iEmpty = 1;
            iReady = 0;
            @(posedge iClock);
            #1 iReset = 0;
            @(posedge iClock);
        end
        endtask
    task testcase001;

        begin
            reset_dut();

            #1;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            iEmpty = 0;
            iReady = 1;
            @(posedge iClock);
            #1;


            #1;



            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            iEmpty = 0;
            iReady = 1;
            @(posedge iClock);
            #1;
            iReady = 0;
            @(posedge iClock);
            #1;

            #1;


            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            iEmpty = 0;
            iReady = 1;
            @(posedge iClock);
            #1;
            iEmpty = 1;
            @(posedge iClock);
            #1;


            #1;



            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            iEmpty = 0;
            iReady = 0;
            @(posedge iClock);
            #1;

            iReady = 1;
            @(posedge iClock);
            #1;
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            iEmpty = 0;
            iReady = 1;
            @(posedge iClock);
            iEmpty = 1;
            @(posedge iClock);
            iReady = 1;
            #1;

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
        input expected_oPopSignal;
        input expected_oValid;
        begin
            if (expected_oPopSignal === (expected_oPopSignal ^ oPopSignal ^ expected_oPopSignal) &&
                expected_oValid === (expected_oValid ^ oValid ^ expected_oValid)) begin
                $display("PASS");
                $display("  Outputs: oPopSignal=%b, oValid=%b",
                         oPopSignal, oValid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: oPopSignal=%b, oValid=%b",
                         expected_oPopSignal, expected_oValid);
                $display("  Got:      oPopSignal=%b, oValid=%b",
                         oPopSignal, oValid);
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
        $dumpvars(0,iClock, iEmpty, iReady, iReset, oPopSignal, oValid);
    end

endmodule
