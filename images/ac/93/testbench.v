`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg in_signal;
    reg ref_signal;
    wire [15:0] error;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .in_signal(in_signal),
        .ref_signal(ref_signal),
        .error(error)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            in_signal = 0;
            ref_signal = 0;
            @(posedge clock);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Running Testcase 001: Perfectly Aligned Signals");
            reset_dut();
            generate_signals(50, 20, 0);


            #1;



            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            $display("Running Testcase 002: 180 Degrees Out of Phase");
            reset_dut();
            generate_signals(50, 20, 10);


            if (error != 0) begin
                pass_count = pass_count + 1;
                $display("PASS: Error detected for phase shift: %d", error);
            end else begin
                fail_count = fail_count + 1;
                $display("FAIL: No error detected for 180 deg shift");
            end
        end
        endtask

    task testcase003;

        begin
            $display("Running Testcase 003: 90 Degrees Phase Shift");
            reset_dut();
            generate_signals(50, 20, 5);

            if (error != 0) begin
                pass_count = pass_count + 1;
                $display("PASS: Error detected: %d", error);
            end else begin
                fail_count = fail_count + 1;
                $display("FAIL: No error detected for 90 deg shift");
            end
        end
        endtask

    task testcase004;

        begin
            $display("Running Testcase 004: Input Signal Loss");
            reset_dut();

            generate_signals(20, 20, 0);

            in_signal = 0;
            repeat(100) begin
                ref_signal = ~ref_signal;
                #100;
                @(posedge clock);
            end

            if (error != 0) begin
                pass_count = pass_count + 1;
                $display("PASS: Non-zero error on signal loss");
            end else begin
                fail_count = fail_count + 1;
                $display("FAIL: Error remained zero after signal loss");
            end
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
        input [15:0] expected_error;
        begin
            if (expected_error === (expected_error ^ error ^ expected_error)) begin
                $display("PASS");
                $display("  Outputs: error=%h",
                         error);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: error=%h",
                         expected_error);
                $display("  Got:      error=%h",
                         error);
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
        $dumpvars(0,clock, in_signal, ref_signal, error);
    end

endmodule
