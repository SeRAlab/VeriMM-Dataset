`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [9:0] CRTClockFreq;
    reg Clock;
    reg Reset;
    reg [9:0] SystemClockFreq;
    wire PixelClock;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CRTClockFreq(CRTClockFreq),
        .Clock(Clock),
        .Reset(Reset),
        .SystemClockFreq(SystemClockFreq),
        .PixelClock(PixelClock)
    );

    // Clock generation (10ns period)
    initial begin
        Clock = 0;
        forever #5 Clock = ~Clock;
    end

        task reset_dut;

        begin
            Reset = 1;
            SystemClockFreq = 0;
            CRTClockFreq = 0;
            @(posedge Clock);
            #1;
            Reset = 0;
            @(posedge Clock);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Ratio 4 (40/10)", test_num);
            reset_dut();
            SystemClockFreq = 40;
            CRTClockFreq = 10;




            repeat(3) @(posedge Clock);
            #2;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Ratio 2 (100/50)", test_num);
            reset_dut();
            SystemClockFreq = 100;
            CRTClockFreq = 50;



            repeat(2) @(posedge Clock);
            #2;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Ratio 10 (100/10)", test_num);
            reset_dut();
            SystemClockFreq = 100;
            CRTClockFreq = 10;


            repeat(2) @(posedge Clock);
            #2;
            if (PixelClock === 1) begin

                repeat(4) @(posedge Clock);
                #2;
                #1;

                check_outputs(0);
            end else begin
                #1;

                check_outputs(1);
            end
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Ratio 40 (200/5)", test_num);
            reset_dut();
            SystemClockFreq = 200;
            CRTClockFreq = 5;


            repeat(5) @(posedge Clock);
            #2;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Ratio 1 (10/10)", test_num);
            reset_dut();
            SystemClockFreq = 10;
            CRTClockFreq = 10;


            repeat(2) @(posedge Clock);
            #2;

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
        input expected_PixelClock;
        begin
            if (expected_PixelClock === (expected_PixelClock ^ PixelClock ^ expected_PixelClock)) begin
                $display("PASS");
                $display("  Outputs: PixelClock=%b",
                         PixelClock);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: PixelClock=%b",
                         expected_PixelClock);
                $display("  Got:      PixelClock=%b",
                         PixelClock);
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
        $dumpvars(0,CRTClockFreq, Clock, Reset, SystemClockFreq, PixelClock);
    end

endmodule
