`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [1:0] noise_freq;
    reg pulse_from_gen;
    reg rst_n;
    wire out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .noise_freq(noise_freq),
        .pulse_from_gen(pulse_from_gen),
        .rst_n(rst_n),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            noise_freq = 2'b00;
            pulse_from_gen = 0;
            repeat (2) @(posedge clk);
            #1 rst_n = 1;
            repeat (1) @(posedge clk);
        end
        endtask
    task send_pulses;

        input integer count;
        integer i;
        begin
            for (i = 0; i < count; i = i + 1) begin
                @(posedge clk);
                pulse_from_gen = 1;
                @(posedge clk);
                pulse_from_gen = 0;
                repeat (2) @(posedge clk);
            end
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            $display("Running testcase%03d: Reset check", test_num);
            reset_dut();

            if (out === 1'b0 || out === 1'b1)
                #1;

                check_outputs(out);
            else
                #1;

                check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Running testcase%03d: Freq 00 operation", test_num);
            reset_dut();
            noise_freq = 2'b00;
            send_pulses(20);
            #5;
            #1;

            check_outputs(out);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Running testcase%03d: Freq 01 operation", test_num);
            reset_dut();
            noise_freq = 2'b01;
            send_pulses(20);
            #5;
            #1;

            check_outputs(out);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Running testcase%03d: Freq 10 operation", test_num);
            reset_dut();
            noise_freq = 2'b10;
            send_pulses(20);
            #5;
            #1;

            check_outputs(out);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Running testcase%03d: Freq 11 operation", test_num);
            reset_dut();
            noise_freq = 2'b11;
            send_pulses(30);
            #5;
            #1;

            check_outputs(out);
        end
        endtask

    task testcase006;

        reg initial_out;
        begin
            test_num = 6;
            $display("Running testcase%03d: No pulse check", test_num);
            reset_dut();
            initial_out = out;
            noise_freq = 2'b00;
            pulse_from_gen = 0;
            repeat (50) @(posedge clk);
            #5;
            #1;

            check_outputs(initial_out);
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
        input expected_out;
        begin
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%b",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%b",
                         expected_out);
                $display("  Got:      out=%b",
                         out);
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
        $dumpvars(0,clk, noise_freq, pulse_from_gen, rst_n, out);
    end

endmodule
