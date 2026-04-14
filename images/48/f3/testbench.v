`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk_i;
    reg [15:0] di;
    reg flush_i;
    reg next_i;
    reg rst_i;
    reg stb_i;
    wire can_burst_o;
    wire [7:0] do8;
    wire do8_valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk_i(clk_i),
        .di(di),
        .flush_i(flush_i),
        .next_i(next_i),
        .rst_i(rst_i),
        .stb_i(stb_i),
        .can_burst_o(can_burst_o),
        .do8(do8),
        .do8_valid(do8_valid)
    );

    // Clock generation (10ns period)
    initial begin
        clk_i = 0;
        forever #5 clk_i = ~clk_i;
    end

        task reset_dut;

        begin
            rst_i = 1;
            flush_i = 0;
            stb_i = 0;
            next_i = 0;
            di = 0;
            repeat(5) @(posedge clk_i);
            #1 rst_i = 0;
            repeat(2) @(posedge clk_i);
        end
        endtask
    task pulse_next;

        begin
            @(posedge clk_i);
            #1 next_i = 1;
            @(posedge clk_i);
            #1 next_i = 0;
        end
        endtask

    task pulse_stb;

        input [15:0] data;
        begin
            @(posedge clk_i);
            #1;
            di = data;
            stb_i = 1;
            @(posedge clk_i);
            #1;
            stb_i = 0;
            di = 0;
        end
        endtask

    task testcase001;

        begin
            $display("Running testcase001: Reset Check");
            reset_dut();

            #1;


            check_outputs(0, 8'hxx, 0);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Single Write (High Byte)");
            reset_dut();
            pulse_stb(16'hABCD);
            repeat(1) @(posedge clk_i);

            #1;


            check_outputs(1, 8'hAB, 1);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Single Write (Low Byte)");
            reset_dut();
            pulse_stb(16'h1234);
            repeat(1) @(posedge clk_i);
            pulse_next();
            repeat(1) @(posedge clk_i);

            #1;


            check_outputs(0, 8'h34, 1);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Burst Capability Check");
            reset_dut();
            pulse_stb(16'h1111);
            pulse_stb(2222);
            repeat(2) @(posedge clk_i);

            #1;


            check_outputs(1, 8'h11, 1);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Flush Operation");
            reset_dut();
            pulse_stb(16'h5566);
            repeat(1) @(posedge clk_i);

            @(posedge clk_i);
            #1 flush_i = 1;
            @(posedge clk_i);
            #1 flush_i = 0;
            repeat(2) @(posedge clk_i);

            #1;


            check_outputs(0, 8'hxx, 0);
        end
        endtask

    task testcase006;

        begin
            $display("Running testcase006: Read until empty");
            reset_dut();
            pulse_stb(16'hDEAD);
            repeat(1) @(posedge clk_i);
            pulse_next();
            pulse_next();
            repeat(2) @(posedge clk_i);

            #1;


            check_outputs(0, 8'hxx, 0);
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
        input expected_can_burst_o;
        input [7:0] expected_do8;
        input expected_do8_valid;
        begin
            if (expected_can_burst_o === (expected_can_burst_o ^ can_burst_o ^ expected_can_burst_o) &&
                expected_do8 === (expected_do8 ^ do8 ^ expected_do8) &&
                expected_do8_valid === (expected_do8_valid ^ do8_valid ^ expected_do8_valid)) begin
                $display("PASS");
                $display("  Outputs: can_burst_o=%b, do8=%h, do8_valid=%b",
                         can_burst_o, do8, do8_valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: can_burst_o=%b, do8=%h, do8_valid=%b",
                         expected_can_burst_o, expected_do8, expected_do8_valid);
                $display("  Got:      can_burst_o=%b, do8=%h, do8_valid=%b",
                         can_burst_o, do8, do8_valid);
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
        $dumpvars(0,clk_i, di, flush_i, next_i, rst_i, stb_i, can_burst_o, do8, do8_valid);
    end

endmodule
