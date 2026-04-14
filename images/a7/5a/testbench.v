`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg output_enable;
    reg [23:0] tone_switch_period;
    reg volume;
    wire [31:0] _counter;
    wire square_wave_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .output_enable(output_enable),
        .tone_switch_period(tone_switch_period),
        .volume(volume),
        ._counter(_counter),
        .square_wave_out(square_wave_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            output_enable = 0;
            tone_switch_period = 24'd0;
            volume = 0;
            repeat(2) @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Running Testcase 001: Output Disabled Check");
            reset_dut();

            output_enable = 0;
            tone_switch_period = 24'd100;
            volume = 1;

            repeat(15) @(posedge clk);
            #1;

            #1;


            check_outputs(32'd0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Running Testcase 002: Volume High - Active High Phase");
            reset_dut();

            tone_switch_period = 24'd100;
            volume = 1;
            output_enable = 1;



            repeat(10) @(posedge clk);
            #1;
            #1;

            check_outputs(32'd9, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Running Testcase 003: Volume High - Active Low Phase");
            reset_dut();

            tone_switch_period = 24'd100;
            volume = 1;
            output_enable = 1;



            repeat(60) @(posedge clk);
            #1;
            #1;

            check_outputs(32'd59, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Running Testcase 004: Volume Low - Duty Cycle Adjustment");
            reset_dut();

            tone_switch_period = 24'd100;
            volume = 0;
            output_enable = 1;



            repeat(30) @(posedge clk);
            #1;
            #1;

            check_outputs(32'd29, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Running Testcase 005: Period Rollover Check");
            reset_dut();

            tone_switch_period = 24'd10;
            volume = 1;
            output_enable = 1;


            repeat(11) @(posedge clk);
            #1;
            #1;

            check_outputs(32'd0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Running Testcase 006: Dynamic Period Update");
            reset_dut();

            tone_switch_period = 24'd50;
            output_enable = 1;
            volume = 1;
            repeat(10) @(posedge clk);


            tone_switch_period = 24'd200;
            repeat(5) @(posedge clk);
            #1;

            #1;


            check_outputs(32'd14, 1'b1);
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
        input [31:0] expected__counter;
        input expected_square_wave_out;
        begin
            if (expected__counter === (expected__counter ^ _counter ^ expected__counter) &&
                expected_square_wave_out === (expected_square_wave_out ^ square_wave_out ^ expected_square_wave_out)) begin
                $display("PASS");
                $display("  Outputs: _counter=%h, square_wave_out=%b",
                         _counter, square_wave_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: _counter=%h, square_wave_out=%b",
                         expected__counter, expected_square_wave_out);
                $display("  Got:      _counter=%h, square_wave_out=%b",
                         _counter, square_wave_out);
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
        $dumpvars(0,clk, output_enable, tone_switch_period, volume, _counter, square_wave_out);
    end

endmodule
