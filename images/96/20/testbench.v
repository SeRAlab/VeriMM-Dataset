`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg io_dataIn;
    reg io_initial;
    reg io_mainClk;
    reg resetCtrl_systemReset;
    wire io_dataOut;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .io_dataIn(io_dataIn),
        .io_initial(io_initial),
        .io_mainClk(io_mainClk),
        .resetCtrl_systemReset(resetCtrl_systemReset),
        .io_dataOut(io_dataOut)
    );

    // Clock generation (10ns period)
    initial begin
        io_mainClk = 0;
        forever #5 io_mainClk = ~io_mainClk;
    end

        task reset_dut;

        begin
            @(posedge io_mainClk);
            resetCtrl_systemReset = 1;
            repeat(2) @(posedge io_mainClk);
            #1;
            resetCtrl_systemReset = 0;
            @(posedge io_mainClk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase 001: Checking reset to initial value 0");
            io_initial = 0;
            io_dataIn = 1;
            reset_dut();

            #1;


            check_outputs(0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase 002: Checking reset to initial value 1");
            io_initial = 1;
            io_dataIn = 0;
            reset_dut();

            #1;


            check_outputs(1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase 003: Propagate 1 through 2 stages (initial 0)");
            io_initial = 0;
            reset_dut();
            io_dataIn = 1;
            @(posedge io_mainClk);
            @(posedge io_mainClk);
            #1;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase 004: Propagate 0 through 2 stages (initial 1)");
            io_initial = 1;
            reset_dut();
            io_dataIn = 0;
            @(posedge io_mainClk);
            @(posedge io_mainClk);
            #1;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase 005: Verify 2-cycle latency (output shouldn't change after 1 cycle)");
            io_initial = 0;
            reset_dut();
            io_dataIn = 1;
            @(posedge io_mainClk);
            #1;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase 006: Verify sequential stream (1 then 0)");
            io_initial = 0;
            reset_dut();
            io_dataIn = 1;
            @(posedge io_mainClk);
            io_dataIn = 0;
            @(posedge io_mainClk);
            #1;
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
        input expected_io_dataOut;
        begin
            if (expected_io_dataOut === (expected_io_dataOut ^ io_dataOut ^ expected_io_dataOut)) begin
                $display("PASS");
                $display("  Outputs: io_dataOut=%b",
                         io_dataOut);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: io_dataOut=%b",
                         expected_io_dataOut);
                $display("  Got:      io_dataOut=%b",
                         io_dataOut);
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
        $dumpvars(0,io_dataIn, io_initial, io_mainClk, resetCtrl_systemReset, io_dataOut);
    end

endmodule
