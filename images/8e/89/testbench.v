`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg clr_sum;
    reg [7:0] dat_in;
    reg load;
    reg mode_inv7b;
    reg [5:0] vol_in;
    wire ready;
    wire [15:0] sum_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .clr_sum(clr_sum),
        .dat_in(dat_in),
        .load(load),
        .mode_inv7b(mode_inv7b),
        .vol_in(vol_in),
        .ready(ready),
        .sum_out(sum_out)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

    begin
        clr_sum = 1;
        load = 0;
        dat_in = 0;
        vol_in = 0;
        mode_inv7b = 0;
        repeat(2) @(posedge clock);
        #1;
        clr_sum = 0;
        repeat(2) @(posedge clock);
        #1;
    end
        endtask
    task perform_load;

        input [7:0] d;
        input [5:0] v;
        input m;
        begin
            dat_in = d;
            vol_in = v;
            mode_inv7b = m;
            load = 1;
            @(posedge clock);
            #1;
            load = 0;

            @(posedge clock);
            while (ready == 1'b0) @(posedge clock);
            #1;
        end
        endtask

    task testcase001;

    begin
        test_num = 1;
        $display("\nTestcase %03d: Initial Reset State", test_num);
        reset_dut();

        #1;


        check_outputs(1'b1, 16'h0000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("\nTestcase %03d: Single Accumulation (10 * 2)", test_num);
        reset_dut();
        perform_load(8'd10, 6'd2, 1'b0);
        #1;

        check_outputs(1'b1, 16'd20);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("\nTestcase %03d: Multi-stage Accumulation (10*2 + 30*3)", test_num);
        reset_dut();
        perform_load(8'd10, 6'd2, 1'b0);
        perform_load(8'd30, 6'd3, 1'b0);
        #1;

        check_outputs(1'b1, 16'd110);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("\nTestcase %03d: Operation in Mode 1", test_num);
        reset_dut();


        perform_load(8'hFF, 6'd1, 1'b1);


        #1;



        check_outputs(1'b1, sum_out);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("\nTestcase %03d: Large Value Accumulation", test_num);
        reset_dut();
        perform_load(8'd255, 6'd63, 1'b0);
        #1;

        check_outputs(1'b1, 16'd16065);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("\nTestcase %03d: Clear Sum Mid-Process", test_num);
        reset_dut();
        perform_load(8'd50, 6'd10, 1'b0);
        clr_sum = 1;
        @(posedge clock);
        #1;
        clr_sum = 0;
        @(posedge clock);
        #1;
        #1;

        check_outputs(1'b1, 16'h0000);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("\nTestcase %03d: Consecutive Rapid Loads", test_num);
        reset_dut();
        perform_load(8'd1, 6'd1, 1'b0);
        perform_load(8'd2, 6'd1, 1'b0);
        perform_load(8'd3, 6'd1, 1'b0);
        perform_load(8'd4, 6'd1, 1'b0);
        #1;

        check_outputs(1'b1, 16'd10);
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
        input expected_ready;
        input [15:0] expected_sum_out;
        begin
            if (expected_ready === (expected_ready ^ ready ^ expected_ready) &&
                expected_sum_out === (expected_sum_out ^ sum_out ^ expected_sum_out)) begin
                $display("PASS");
                $display("  Outputs: ready=%b, sum_out=%h",
                         ready, sum_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ready=%b, sum_out=%h",
                         expected_ready, expected_sum_out);
                $display("  Got:      ready=%b, sum_out=%h",
                         ready, sum_out);
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
        $dumpvars(0,clock, clr_sum, dat_in, load, mode_inv7b, vol_in, ready, sum_out);
    end

endmodule
