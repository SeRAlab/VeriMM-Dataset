`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] amplitude_l;
    reg [3:0] amplitude_r;
    reg clk;
    reg en_noise;
    reg en_tone;
    reg noise;
    reg tone;
    wire [4:0] out_l;
    wire [4:0] out_r;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .amplitude_l(amplitude_l),
        .amplitude_r(amplitude_r),
        .clk(clk),
        .en_noise(en_noise),
        .en_tone(en_tone),
        .noise(noise),
        .tone(tone),
        .out_l(out_l),
        .out_r(out_r)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            en_tone = 0;
            en_noise = 0;
            tone = 0;
            noise = 0;
            amplitude_l = 0;
            amplitude_r = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Test %0d: All signals disabled/zero", test_num);
            en_tone = 0;
            en_noise = 0;
            tone = 0;
            noise = 0;
            amplitude_l = 4'd10;
            amplitude_r = 4'd5;
            @(posedge clk);
            #1;
            #1;

            check_outputs(5'd0, 5'd0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Test %0d: Only Tone enabled and active", test_num);
            en_tone = 1;
            en_noise = 0;
            tone = 1;
            noise = 1;
            amplitude_l = 4'd8;
            amplitude_r = 4'd4;
            @(posedge clk);
            #1;
            #1;

            check_outputs(5'd8, 5'd4);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Test %0d: Only Noise enabled and active", test_num);
            en_tone = 0;
            en_noise = 1;
            tone = 1;
            noise = 1;
            amplitude_l = 4'd7;
            amplitude_r = 4'd12;
            @(posedge clk);
            #1;
            #1;

            check_outputs(5'd7, 5'd12);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Test %0d: Both enabled, only Tone signal high", test_num);
            en_tone = 1;
            en_noise = 1;
            tone = 1;
            noise = 0;
            amplitude_l = 4'd3;
            amplitude_r = 4'd9;
            @(posedge clk);
            #1;
            #1;

            check_outputs(5'd3, 5'd9);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Test %0d: Both enabled and active (Summation)", test_num);
            en_tone = 1;
            en_noise = 1;
            tone = 1;
            noise = 1;
            amplitude_l = 4'd5;
            amplitude_r = 4'd6;
            @(posedge clk);
            #1;

            #1;


            check_outputs(5'd10, 5'd12);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            $display("Test %0d: Max amplitudes summation (15+15)", test_num);
            en_tone = 1;
            en_noise = 1;
            tone = 1;
            noise = 1;
            amplitude_l = 4'd15;
            amplitude_r = 4'd15;
            @(posedge clk);
            #1;
            #1;

            check_outputs(5'd30, 5'd30);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = 7;
            $display("Test %0d: Signals active but disabled", test_num);
            en_tone = 0;
            en_noise = 0;
            tone = 1;
            noise = 1;
            amplitude_l = 4'd15;
            amplitude_r = 4'd15;
            @(posedge clk);
            #1;
            #1;

            check_outputs(5'd0, 5'd0);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            test_num = 8;
            $display("Test %0d: Enabled but signals inactive", test_num);
            en_tone = 1;
            en_noise = 1;
            tone = 0;
            noise = 0;
            amplitude_l = 4'd15;
            amplitude_r = 4'd15;
            @(posedge clk);
            #1;
            #1;

            check_outputs(5'd0, 5'd0);
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
        input [4:0] expected_out_l;
        input [4:0] expected_out_r;
        begin
            if (expected_out_l === (expected_out_l ^ out_l ^ expected_out_l) &&
                expected_out_r === (expected_out_r ^ out_r ^ expected_out_r)) begin
                $display("PASS");
                $display("  Outputs: out_l=%h, out_r=%h",
                         out_l, out_r);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_l=%h, out_r=%h",
                         expected_out_l, expected_out_r);
                $display("  Got:      out_l=%h, out_r=%h",
                         out_l, out_r);
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
        $dumpvars(0,amplitude_l, amplitude_r, clk, en_noise, en_tone, noise, tone, out_l, out_r);
    end

endmodule
