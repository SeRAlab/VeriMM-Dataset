`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg clr_sum;
    reg [7:0] dat_in;
    reg load;
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
        vol_in = 0;
        dat_in = 8'h80;
        @(posedge clock);
        #1 clr_sum = 0;
        @(posedge clock);
    end
        endtask
    task wait_for_ready;

    begin
        @(posedge clock);

        while (ready === 0) @(posedge clock);
    end
        endtask

    task testcase001;

    begin
        test_num = 1;
        reset_dut();
        vol_in = 6'd0;
        dat_in = 8'h80;
        @(posedge clock);
        load = 1;
        @(posedge clock);
        load = 0;
        wait_for_ready();
        #1;

        check_outputs(1'b1, 16'h0000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        reset_dut();
        vol_in = 6'd1;
        dat_in = 8'h81;
        @(posedge clock);
        load = 1;
        @(posedge clock);
        load = 0;
        wait_for_ready();
        #1;

        check_outputs(1'b1, 16'h0010);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        reset_dut();
        vol_in = 6'd10;
        dat_in = 8'h7F;
        @(posedge clock);
        load = 1;
        @(posedge clock);
        load = 0;
        wait_for_ready();
        #1;

        check_outputs(1'b1, 16'hFF60);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        reset_dut();
        vol_in = 6'd63;
        dat_in = 8'h82;
        @(posedge clock);
        load = 1;
        @(posedge clock);
        load = 0;
        wait_for_ready();
        #1;

        check_outputs(1'b1, 16'h07E0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        reset_dut();
        vol_in = 6'd63;
        dat_in = 8'hFF;
        @(posedge clock);
        load = 1;
        @(posedge clock);
        load = 0;
        wait_for_ready();
        #1;

        check_outputs(1'b1, 16'hF410);
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
        $dumpvars(0,clock, clr_sum, dat_in, load, vol_in, ready, sum_out);
    end

endmodule
