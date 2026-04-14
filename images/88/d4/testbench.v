`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg clk_bps;
    reg dir;
    reg rst;
    wire [15:0] led;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .clk_bps(clk_bps),
        .dir(dir),
        .rst(rst),
        .led(led)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            clk_bps = 0;
            dir = 0;
            repeat(2) @(posedge clk);
            #1 rst = 0;
            repeat(1) @(posedge clk);
        end
        endtask
    task pulse_bps;

        begin
            @(posedge clk);
            #1 clk_bps = 1;
            @(posedge clk);
            #1 clk_bps = 0;
        end
        endtask

    task testcase001;

        begin
            $display("Running testcase001: Reset Logic Check");
            reset_dut();
            #1;

            check_outputs(16'h8000);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Shift Right Once (8000 -> 4000)");
            reset_dut();
            dir = 0;
            pulse_bps();
            #1;

            check_outputs(16'h4000);
        end
        endtask

    task testcase003;

        integer i;
        begin
            $display("Running testcase003: Shift Right Full Cycle (Wrap Around)");
            reset_dut();
            dir = 0;

            for(i=0; i<16; i=i+1) begin
                pulse_bps();
            end
            #1;

            check_outputs(16'h8000);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Shift Left from MSB (8000 -> 0001)");
            reset_dut();
            dir = 1;
            pulse_bps();
            #1;

            check_outputs(16'h0001);
        end
        endtask

    task testcase005;

        integer i;
        begin
            $display("Running testcase005: Shift Left Multiple (0001 -> 0010)");
            reset_dut();
            dir = 1;
            pulse_bps();
            pulse_bps();
            pulse_bps();
            pulse_bps();
            pulse_bps();
            #1;

            check_outputs(16'h0010);
        end
        endtask

    task testcase006;

        begin
            $display("Running testcase006: Change Direction Mid-stream");
            reset_dut();
            dir = 0;
            pulse_bps();
            pulse_bps();
            pulse_bps();
            dir = 1;
            pulse_bps();
            pulse_bps();
            #1;

            check_outputs(16'h4000);
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
        input [15:0] expected_led;
        begin
            if (expected_led === (expected_led ^ led ^ expected_led)) begin
                $display("PASS");
                $display("  Outputs: led=%h",
                         led);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: led=%h",
                         expected_led);
                $display("  Got:      led=%h",
                         led);
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
        $dumpvars(0,clk, clk_bps, dir, rst, led);
    end

endmodule
