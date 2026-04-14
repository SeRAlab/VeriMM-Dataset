`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg i_counter_reset;
    reg i_dataout_stall;
    reg [31:0] i_size;
    reg i_start;
    reg resetn;
    wire [31:0] o_dataout;
    wire o_dataout_valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .i_counter_reset(i_counter_reset),
        .i_dataout_stall(i_dataout_stall),
        .i_size(i_size),
        .i_start(i_start),
        .resetn(resetn),
        .o_dataout(o_dataout),
        .o_dataout_valid(o_dataout_valid)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            resetn = 0;
            i_counter_reset = 0;
            i_dataout_stall = 0;
            i_size = 0;
            i_start = 0;
            @(posedge clock);
            #1;
            resetn = 1;
            @(posedge clock);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            i_size = 32'd10;
            i_start = 1;

            repeat(10) @(posedge clock);
            #1;

            #1;


            check_outputs(32'd10, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            i_size = 32'd20;
            i_start = 1;
            repeat(5) @(posedge clock);
            #1 i_dataout_stall = 1;
            repeat(5) @(posedge clock);
            #1 i_dataout_stall = 0;
            repeat(5) @(posedge clock);
            #1;
            #1;

            check_outputs(32'd10, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            i_size = 32'd50;
            i_start = 1;
            repeat(10) @(posedge clock);
            #1 i_counter_reset = 1;
            @(posedge clock);
            #1 i_counter_reset = 0;

            #1;


            check_outputs(32'd0, o_dataout_valid);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            i_size = 32'd100;
            i_start = 1;
            repeat(20) @(posedge clock);
            #1 resetn = 0;
            @(posedge clock);
            #1;
            #1;

            check_outputs(32'd0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            i_size = 32'd2;
            i_start = 1;
            repeat(2) @(posedge clock);
            #1 i_start = 0;
            repeat(2) @(posedge clock);
            #1;

            #1;


            check_outputs(32'd2, o_dataout_valid);
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
        input [31:0] expected_o_dataout;
        input expected_o_dataout_valid;
        begin
            if (expected_o_dataout === (expected_o_dataout ^ o_dataout ^ expected_o_dataout) &&
                expected_o_dataout_valid === (expected_o_dataout_valid ^ o_dataout_valid ^ expected_o_dataout_valid)) begin
                $display("PASS");
                $display("  Outputs: o_dataout=%h, o_dataout_valid=%b",
                         o_dataout, o_dataout_valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o_dataout=%h, o_dataout_valid=%b",
                         expected_o_dataout, expected_o_dataout_valid);
                $display("  Got:      o_dataout=%h, o_dataout_valid=%b",
                         o_dataout, o_dataout_valid);
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
        $dumpvars(0,clock, i_counter_reset, i_dataout_stall, i_size, i_start, resetn, o_dataout, o_dataout_valid);
    end

endmodule
