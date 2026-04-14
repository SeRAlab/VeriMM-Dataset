`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg iClock;
    reg iReset;
    wire oOut131k;
    wire oOut262k;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .iClock(iClock),
        .iReset(iReset),
        .oOut131k(oOut131k),
        .oOut262k(oOut262k)
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
            @(posedge iClock);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Testing Reset", test_num);
            reset_dut();
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Testing oOut262k (q[17]) toggle after 131,072 cycles", test_num);
            reset_dut();
            repeat(131072) @(posedge iClock);
            #1;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Testing oOut131k (q[18]) toggle after 262,144 cycles", test_num);
            reset_dut();
            repeat(262144) @(posedge iClock);
            #1;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Testing both outputs high (393,216 cycles)", test_num);
            reset_dut();
            repeat(393216) @(posedge iClock);
            #1;
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Testing counter wrap-around (524,288 cycles)", test_num);
            reset_dut();
            repeat(524288) @(posedge iClock);
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
        input expected_oOut131k;
        input expected_oOut262k;
        begin
            if (expected_oOut131k === (expected_oOut131k ^ oOut131k ^ expected_oOut131k) &&
                expected_oOut262k === (expected_oOut262k ^ oOut262k ^ expected_oOut262k)) begin
                $display("PASS");
                $display("  Outputs: oOut131k=%b, oOut262k=%b",
                         oOut131k, oOut262k);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: oOut131k=%b, oOut262k=%b",
                         expected_oOut131k, expected_oOut262k);
                $display("  Got:      oOut131k=%b, oOut262k=%b",
                         oOut131k, oOut262k);
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
        $dumpvars(0,iClock, iReset, oOut131k, oOut262k);
    end

endmodule
