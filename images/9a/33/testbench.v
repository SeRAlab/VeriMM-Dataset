`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg [15:0] in;
    reg inc;
    reg load;
    reg reset;
    wire [15:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .in(in),
        .inc(inc),
        .load(load),
        .reset(reset),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            reset = 1;
            load = 0;
            inc = 0;
            in = 16'h0;
            @(posedge clock);
            #1;
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Basic Reset");
            reset_dut();

            #1;


            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Load Value");
            reset_dut();
            in = 16'hA5A5;
            load = 1;
            @(posedge clock);
            #1;
            load = 0;
            #1;

            check_outputs(16'hA5A5);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Increment from Zero");
            reset_dut();
            inc = 1;
            @(posedge clock);
            @(posedge clock);
            @(posedge clock);
            #1;
            inc = 0;
            #1;

            check_outputs(16'h0003);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Load then Increment");
            reset_dut();
            in = 16'h1000;
            load = 1;
            @(posedge clock);
            load = 0;
            inc = 1;
            @(posedge clock);
            #1;
            inc = 0;
            #1;

            check_outputs(16'h1001);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Priority - Reset over Load/Inc");
            reset_dut();
            in = 16'hFFFF;
            load = 1;
            inc = 1;
            reset = 1;
            @(posedge clock);
            #1;
            reset = 0;
            load = 0;
            inc = 0;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase006;

        begin
            $display("Running testcase006: Priority - Load over Inc");
            reset_dut();
            in = 16'h5555;
            load = 1;
            inc = 1;
            @(posedge clock);
            #1;
            load = 0;
            inc = 0;
            #1;

            check_outputs(16'h5555);
        end
        endtask

    task testcase007;

        begin
            $display("Running testcase007: Hold Value");
            reset_dut();
            in = 16'h1234;
            load = 1;
            @(posedge clock);
            load = 0;
            inc = 0;
            reset = 0;
            @(posedge clock);
            @(posedge clock);
            #1;
            #1;

            check_outputs(16'h1234);
        end
        endtask

    task testcase008;

        begin
            $display("Running testcase008: Counter Rollover");
            reset_dut();
            in = 16'hFFFF;
            load = 1;
            @(posedge clock);
            load = 0;
            inc = 1;
            @(posedge clock);
            #1;
            inc = 0;
            #1;

            check_outputs(16'h0000);
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
        input [15:0] expected_out;
        begin
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
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
        $dumpvars(0,clock, in, inc, load, reset, out);
    end

endmodule
