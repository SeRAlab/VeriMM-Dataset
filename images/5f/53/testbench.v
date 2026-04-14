`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg crcbitin;
    reg crcinclk;
    reg crcoutclk;
    reg reset;
    wire crcbitout;
    wire crcdone;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .crcbitin(crcbitin),
        .crcinclk(crcinclk),
        .crcoutclk(crcoutclk),
        .reset(reset),
        .crcbitout(crcbitout),
        .crcdone(crcdone)
    );

    // Clock generation (10ns period)
    initial begin
        crcinclk = 0;
        forever #5 crcinclk = ~crcinclk;
    end

        task reset_dut;

        begin
            reset = 1;
            crcbitin = 0;
            crcoutclk = 0;
            #20;
            reset = 0;
            #10;
        end
        endtask
    task pulse_crcoutclk;

        input integer times;
        integer i;
        begin
            for (i = 0; i < times; i = i + 1) begin
                #5 crcoutclk = 1;
                #5 crcoutclk = 0;
                #2;
            end
        end
        endtask

    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Initial Reset State", test_num);
            reset_dut();

            #1;


            check_outputs(crcbitout, 0);
        end
        endtask

    task testcase002;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %03d: 16-bit Zero Input Sequence", test_num);
            reset_dut();
            for (i = 0; i < 16; i = i + 1) begin
                @(posedge crcinclk);
                crcbitin = 0;
            end

            @(posedge crcinclk);

            #1;


            check_outputs(crcbitout, 1);

            pulse_crcoutclk(16);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %03d: 16-bit All-Ones Input Sequence", test_num);
            reset_dut();
            for (i = 0; i < 16; i = i + 1) begin
                @(posedge crcinclk);
                crcbitin = 1;
            end
            @(posedge crcinclk);
            #1;

            check_outputs(crcbitout, 1);
            pulse_crcoutclk(16);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %03d: 16-bit Alternating Pattern (1010...)", test_num);
            reset_dut();
            for (i = 0; i < 16; i = i + 1) begin
                @(posedge crcinclk);
                crcbitin = (i % 2 == 0) ? 1 : 0;
            end
            @(posedge crcinclk);
            #1;

            check_outputs(crcbitout, 1);
            pulse_crcoutclk(16);
        end
        endtask

    task testcase005;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Premature Completion Check (8 bits)", test_num);
            reset_dut();
            for (i = 0; i < 8; i = i + 1) begin
                @(posedge crcinclk);
                crcbitin = 1;
            end

            #1;


            check_outputs(crcbitout, 0);
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
        input expected_crcbitout;
        input expected_crcdone;
        begin
            if (expected_crcbitout === (expected_crcbitout ^ crcbitout ^ expected_crcbitout) &&
                expected_crcdone === (expected_crcdone ^ crcdone ^ expected_crcdone)) begin
                $display("PASS");
                $display("  Outputs: crcbitout=%b, crcdone=%b",
                         crcbitout, crcdone);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: crcbitout=%b, crcdone=%b",
                         expected_crcbitout, expected_crcdone);
                $display("  Got:      crcbitout=%b, crcdone=%b",
                         crcbitout, crcdone);
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
        $dumpvars(0,crcbitin, crcinclk, crcoutclk, reset, crcbitout, crcdone);
    end

endmodule
