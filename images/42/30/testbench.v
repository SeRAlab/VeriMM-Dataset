`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clear;
    reg clk;
    reg leds_on;
    reg rst;
    wire beep;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clear(clear),
        .clk(clk),
        .leds_on(leds_on),
        .rst(rst),
        .beep(beep)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            clear = 0;
            leds_on = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            leds_on = 1;
            @(posedge clk);
            #1 leds_on = 0;
            @(posedge clk);

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            leds_on = 1;
            @(posedge clk);
            #1 leds_on = 0;
            repeat(2) @(posedge clk);
            clear = 1;
            @(posedge clk);
            #1 clear = 0;
            @(posedge clk);

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            leds_on = 0;
            repeat(5) @(posedge clk);

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            leds_on = 1;
            @(posedge clk);
            #1 leds_on = 0;
            repeat(5) @(posedge clk);
            clear = 0;
            @(posedge clk);

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            leds_on = 1;
            @(posedge clk);
            #1 leds_on = 0;
            @(posedge clk);
            rst = 1;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);

            #1;


            check_outputs(1'b0);
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
        input expected_beep;
        begin
            if (expected_beep === (expected_beep ^ beep ^ expected_beep)) begin
                $display("PASS");
                $display("  Outputs: beep=%b",
                         beep);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: beep=%b",
                         expected_beep);
                $display("  Got:      beep=%b",
                         beep);
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
        $dumpvars(0,clear, clk, leds_on, rst, beep);
    end

endmodule
