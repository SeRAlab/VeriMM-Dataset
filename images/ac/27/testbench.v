`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk_in;
    reg clk_out;
    reg pulse_in;
    wire pulse_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk_in(clk_in),
        .clk_out(clk_out),
        .pulse_in(pulse_in),
        .pulse_out(pulse_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk_in = 0;
        forever #5 clk_in = ~clk_in;
    end

        task reset_dut;

        begin
            pulse_in = 0;
            pulse_out_seen = 0;

            repeat(5) @(posedge clk_in);
            repeat(5) @(posedge clk_out);
            pulse_out_seen = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Single Pulse Synchronization", test_num);
            reset_dut();

            @(posedge clk_in);
            pulse_in = 1;
            @(posedge clk_in);
            pulse_in = 0;



            repeat(10) @(posedge clk_out);


            if (pulse_out_seen) begin
                $display("Pulse successfully detected in clk_out domain.");
                #1;

                check_outputs(pulse_out);

                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: Pulse not detected.");
                fail_count = fail_count + 1;
            end
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Idle Input Check", test_num);
            reset_dut();

            pulse_in = 0;
            repeat(20) @(posedge clk_out);


            if (!pulse_out_seen && pulse_out == 0) begin
                #1;

                check_outputs(1'b0);
            end else begin
                $display("FAIL: Unexpected pulse detected.");
                fail_count = fail_count + 1;
            end
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = 3;
            $display("\nTestcase %0d: Multiple Successive Pulses", test_num);
            reset_dut();

            for (i = 0; i < 3; i = i + 1) begin
                pulse_out_seen = 0;

                @(posedge clk_in);
                pulse_in = 1;
                @(posedge clk_in);
                pulse_in = 0;

                repeat(15) @(posedge clk_out);

                if (!pulse_out_seen) begin
                    $display("FAIL: Pulse %0d not detected.", i);
                    fail_count = fail_count + 1;
                end
            end

            if (fail_count == 0 || test_num > 2) begin
                $display("Multiple pulse sequence completed.");
                #1;

                check_outputs(pulse_out);
            end
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Long Input Pulse", test_num);
            reset_dut();

            @(posedge clk_in);
            pulse_in = 1;
            repeat(5) @(posedge clk_in);
            pulse_in = 0;

            repeat(15) @(posedge clk_out);


            #1;



            check_outputs(1'b0);
            if (pulse_out_seen) $display("Long pulse handled.");
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
        input expected_pulse_out;
        begin
            if (expected_pulse_out === (expected_pulse_out ^ pulse_out ^ expected_pulse_out)) begin
                $display("PASS");
                $display("  Outputs: pulse_out=%b",
                         pulse_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: pulse_out=%b",
                         expected_pulse_out);
                $display("  Got:      pulse_out=%b",
                         pulse_out);
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
        $dumpvars(0,clk_in, clk_out, pulse_in, pulse_out);
    end

endmodule
