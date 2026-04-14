`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg dsysclk;
    reg esysclk;
    reg [31:0] ival;
    reg preset;
    reg qreset;
    reg reset;
    reg sysclk;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .dsysclk(dsysclk),
        .esysclk(esysclk),
        .ival(ival),
        .preset(preset),
        .qreset(qreset),
        .reset(reset),
        .sysclk(sysclk)
    );

    // Clock generation (10ns period)
    initial begin
        dsysclk = 0;
        forever #5 dsysclk = ~dsysclk;
    end

        task reset_dut;

        begin
            reset = 1;
            preset = 0;
            qreset = 0;
            ival = 0;
            repeat(2) @(posedge dsysclk);
            #1 reset = 0;
            repeat(1) @(posedge dsysclk);
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning Testcase 001: Power-on Reset");
            reset_dut();

            #1;


            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning Testcase 002: Preset Logic");
            reset_dut();
            ival = 32'hAAAA_5555;
            preset = 1;
            @(posedge dsysclk);
            #1 preset = 0;
            repeat(2) @(posedge dsysclk);

            #1;


            check_outputs(sysclk, esysclk);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning Testcase 003: Preset with All Fs");
            reset_dut();
            ival = 32'hFFFF_FFFF;
            preset = 1;
            @(posedge dsysclk);
            #1 preset = 0;
            repeat(2) @(posedge dsysclk);
            #1;

            check_outputs(sysclk, esysclk);
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning Testcase 004: Quick Reset (qreset)");
            reset_dut();
            qreset = 1;
            repeat(2) @(posedge dsysclk);
            #1 qreset = 0;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            $display("\nRunning Testcase 005: Reset Priority over Preset");
            reset_dut();
            reset = 1;
            preset = 1;
            ival = 32'h1234_5678;
            repeat(2) @(posedge dsysclk);
            #1;

            #1;


            check_outputs(1'b0, 1'b0);
            reset = 0;
            preset = 0;
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
        begin
            if () begin
                $display("PASS");
                $display("  Outputs: ",
                         );
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ",
                         );
                $display("  Got:      ",
                         );
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
        $dumpvars(0,dsysclk, esysclk, ival, preset, qreset, reset, sysclk);
    end

endmodule
