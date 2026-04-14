`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg RST;
    reg SIGNAL;
    wire TRANS;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .RST(RST),
        .SIGNAL(SIGNAL),
        .TRANS(TRANS)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            RST = 0;
            SIGNAL = 0;
            test_num = test_num + 1;
            #20;
            RST = 1;
            #5;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            SIGNAL = 0;
            @(posedge CLK);
            #2;
            $display("Testcase 001: Initial State (SIGNAL=0)");
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            SIGNAL = 0;
            @(posedge CLK);
            SIGNAL = 1;
            @(posedge CLK);
            #2;
            $display("Testcase 002: Simple Rising Edge Detection");
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            SIGNAL = 0;
            @(posedge CLK);
            SIGNAL = 1;
            repeat(3) @(posedge CLK);
            #2;
            $display("Testcase 003: Maintain TRANS High during SIGNAL High");
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            SIGNAL = 0;
            @(posedge CLK);
            SIGNAL = 1;
            @(posedge CLK);
            SIGNAL = 0;
            @(posedge CLK);
            #2;
            $display("Testcase 004: TRANS returns to LOW when SIGNAL goes LOW");
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            RST = 0;
            SIGNAL = 1;
            #20;
            RST = 1;
            @(posedge CLK);
            #2;
            $display("Testcase 005: SIGNAL High during reset (No Rising Edge yet)");
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin

            RST = 0;
            SIGNAL = 1;
            #20;
            RST = 1;
            @(posedge CLK);
            SIGNAL = 0;
            @(posedge CLK);
            SIGNAL = 1;
            @(posedge CLK);
            #2;
            $display("Testcase 006: Detection after 1->0->1 sequence post-reset");
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            reset_dut();

            SIGNAL = 1; @(posedge CLK);
            SIGNAL = 0; @(posedge CLK);

            SIGNAL = 1; @(posedge CLK);
            #2;
            $display("Testcase 007: Verification of repeated rising edge triggers");
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            SIGNAL = 1; @(posedge CLK);
            #1;
            RST = 0;
            #2;
            $display("Testcase 008: TRANS forced LOW by RST during active state");
            #1;

            check_outputs(1'b0);
            RST = 1;
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
        input expected_TRANS;
        begin
            if (expected_TRANS === (expected_TRANS ^ TRANS ^ expected_TRANS)) begin
                $display("PASS");
                $display("  Outputs: TRANS=%b",
                         TRANS);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: TRANS=%b",
                         expected_TRANS);
                $display("  Got:      TRANS=%b",
                         TRANS);
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
        $dumpvars(0,CLK, RST, SIGNAL, TRANS);
    end

endmodule
