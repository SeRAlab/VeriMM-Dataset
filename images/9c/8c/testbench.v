`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg iClock;
    reg iReset;
    wire oOut128;
    wire oOut256;
    wire oOut64;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .iClock(iClock),
        .iReset(iReset),
        .oOut128(oOut128),
        .oOut256(oOut256),
        .oOut64(oOut64)
    );

    // Clock generation (10ns period)
    initial begin
        iClock = 0;
        forever #5 iClock = ~iClock;
    end

        task reset_dut;

        begin
            iReset = 1;
            #20;
            iReset = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case 001: Initial Reset State");
            reset_dut();

            #1;


            check_outputs(1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case 002: Check oOut256 (Bit 13) after 8192 cycles");
            reset_dut();
            repeat(8192) @(posedge iClock);
            #2;

            #1;


            check_outputs(1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case 003: Check oOut128 (Bit 14) after 16384 cycles");
            reset_dut();
            repeat(16384) @(posedge iClock);
            #2;

            #1;


            check_outputs(1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case 004: Check oOut64 (Bit 15) after 32768 cycles");
            reset_dut();
            repeat(32768) @(posedge iClock);
            #2;

            #1;


            check_outputs(1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case 005: Check all outputs after 57344 cycles (2^15 + 2^14 + 2^13)");
            reset_dut();
            repeat(57344) @(posedge iClock);
            #2;

            #1;


            check_outputs(1'b1, 1'b1, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case 006: Asynchronous Reset while outputs are active");
            reset_dut();
            repeat(57344) @(posedge iClock);
            #2;

            iReset = 1;
            #15;


            #1;



            check_outputs(1'b0, 1'b0, 1'b0);
            iReset = 0;
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
        input expected_oOut128;
        input expected_oOut256;
        input expected_oOut64;
        begin
            if (expected_oOut128 === (expected_oOut128 ^ oOut128 ^ expected_oOut128) &&
                expected_oOut256 === (expected_oOut256 ^ oOut256 ^ expected_oOut256) &&
                expected_oOut64 === (expected_oOut64 ^ oOut64 ^ expected_oOut64)) begin
                $display("PASS");
                $display("  Outputs: oOut128=%b, oOut256=%b, oOut64=%b",
                         oOut128, oOut256, oOut64);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: oOut128=%b, oOut256=%b, oOut64=%b",
                         expected_oOut128, expected_oOut256, expected_oOut64);
                $display("  Got:      oOut128=%b, oOut256=%b, oOut64=%b",
                         oOut128, oOut256, oOut64);
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
        $dumpvars(0,iClock, iReset, oOut128, oOut256, oOut64);
    end

endmodule
