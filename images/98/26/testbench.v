`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [8:0] address;
    reg clk;
    reg enable;
    reg [6:0] pwm_word;
    reg [7:0] sinewave;
    reg [1:0] wave_word;
    wire [7:0] waveform;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .address(address),
        .clk(clk),
        .enable(enable),
        .pwm_word(pwm_word),
        .sinewave(sinewave),
        .wave_word(wave_word),
        .waveform(waveform)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            enable = 0;
            wave_word = 2'b00;
            pwm_word = 7'd0;
            sinewave = 8'd0;
            address = 9'd0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            enable = 0;
            wave_word = 2'b00;
            sinewave = 8'hAA;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            enable = 1;
            wave_word = 2'b00;
            sinewave = 8'h55;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            enable = 1;
            wave_word = 2'b01;
            address = 9'h055;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            enable = 1;
            wave_word = 2'b01;
            address = 9'h1AA;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            enable = 1;
            wave_word = 2'b10;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            enable = 1;
            wave_word = 2'b11;
            pwm_word = 7'h40;
            address = 9'h000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = 7;
            enable = 1;
            wave_word = 2'b11;
            pwm_word = 7'h10;
            address = 9'h100;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h00);
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
        input [7:0] expected_waveform;
        begin
            if (expected_waveform === (expected_waveform ^ waveform ^ expected_waveform)) begin
                $display("PASS");
                $display("  Outputs: waveform=%h",
                         waveform);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: waveform=%h",
                         expected_waveform);
                $display("  Got:      waveform=%h",
                         waveform);
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
        $dumpvars(0,address, clk, enable, pwm_word, sinewave, wave_word, waveform);
    end

endmodule
