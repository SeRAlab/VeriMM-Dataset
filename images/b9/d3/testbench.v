`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg areset;
    reg clk;
    reg [3:0] data_in;
    reg load;
    reg shift_enable;
    reg shift_right;
    wire [3:0] data_out;
    wire full;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .areset(areset),
        .clk(clk),
        .data_in(data_in),
        .load(load),
        .shift_enable(shift_enable),
        .shift_right(shift_right),
        .data_out(data_out),
        .full(full)
    );

    // Clock generation (10ns period)
    initial begin
        areset = 0;
        forever #5 areset = ~areset;
    end

        task reset_dut;

    begin
        areset = 1;
        load = 0;
        shift_enable = 0;
        shift_right = 0;
        data_in = 4'b0000;
        #15;
        areset = 0;
        #5;
    end
        endtask
    task testcase001;

    begin
        $display("Testcase 001: Checking Reset state");
        reset_dut();
        #1;

        check_outputs(4'b0000, 1'b0);
    end
        endtask

    task testcase002;

    begin
        $display("Testcase 002: Loading 4'b1010");
        reset_dut();
        data_in = 4'b1010;
        load = 1;
        @(posedge clk);
        #2;
        load = 0;
        #1;

        check_outputs(4'b1010, 1'b0);
    end
        endtask

    task testcase003;

    begin
        $display("Testcase 003: Loading 4'b1111 (Full check)");
        reset_dut();
        data_in = 4'b1111;
        load = 1;
        @(posedge clk);
        #2;
        load = 0;
        #1;

        check_outputs(4'b1111, 1'b1);
    end
        endtask

    task testcase004;

    begin
        $display("Testcase 004: Load 4'b1000 and Shift Right once");
        reset_dut();
        data_in = 4'b1000;
        load = 1;
        @(posedge clk);
        #2;
        load = 0;
        shift_enable = 1;
        shift_right = 1;
        @(posedge clk);
        #2;
        shift_enable = 0;
        #1;

        check_outputs(4'b0100, 1'b0);
    end
        endtask

    task testcase005;

    begin
        $display("Testcase 005: Load 4'b0001 and Shift Left once");
        reset_dut();
        data_in = 4'b0001;
        load = 1;
        @(posedge clk);
        #2;
        load = 0;
        shift_enable = 1;
        shift_right = 0;
        @(posedge clk);
        #2;
        shift_enable = 0;
        #1;

        check_outputs(4'b0010, 1'b0);
    end
        endtask

    task testcase006;

    begin
        $display("Testcase 006: Circular Right Wrap (4'b0001 -> 4'b1000)");
        reset_dut();
        data_in = 4'b0001;
        load = 1;
        @(posedge clk);
        #2;
        load = 0;
        shift_enable = 1;
        shift_right = 1;
        @(posedge clk);
        #2;
        shift_enable = 0;
        #1;

        check_outputs(4'b1000, 1'b0);
    end
        endtask

    task testcase007;

    begin
        $display("Testcase 007: Circular Left Wrap (4'b1000 -> 4'b0001)");
        reset_dut();
        data_in = 4'b1000;
        load = 1;
        @(posedge clk);
        #2;
        load = 0;
        shift_enable = 1;
        shift_right = 0;
        @(posedge clk);
        #2;
        shift_enable = 0;
        #1;

        check_outputs(4'b0001, 1'b0);
    end
        endtask

    task testcase008;

    begin
        $display("Testcase 008: Checking Priority (Load vs Shift)");
        reset_dut();
        data_in = 4'b1010;
        load = 1;
        shift_enable = 1;
        shift_right = 1;
        @(posedge clk);
        #2;
        load = 0;
        shift_enable = 0;
        #1;

        check_outputs(4'b1010, 1'b0);
    end
        endtask

    task testcase009;

    begin
        $display("Testcase 009: Shift Enable = 0 (No change)");
        reset_dut();
        data_in = 4'b0110;
        load = 1;
        @(posedge clk);
        #2;
        load = 0;
        shift_enable = 0;
        shift_right = 1;
        @(posedge clk);
        #2;
        #1;

        check_outputs(4'b0110, 1'b0);
    end
        endtask

    task testcase010;

    begin
        $display("Testcase 010: 4 consecutive Right Shifts");
        reset_dut();
        data_in = 4'b1100;
        load = 1;
        @(posedge clk);
        #2;
        load = 0;
        shift_enable = 1;
        shift_right = 1;
        repeat(4) @(posedge clk);
        #2;
        shift_enable = 0;
        #1;

        check_outputs(4'b1100, 1'b0);
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
        testcase009();
        testcase010();
        
        
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
        input [3:0] expected_data_out;
        input expected_full;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_full === (expected_full ^ full ^ expected_full)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, full=%b",
                         data_out, full);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, full=%b",
                         expected_data_out, expected_full);
                $display("  Got:      data_out=%h, full=%b",
                         data_out, full);
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
        $dumpvars(0,areset, clk, data_in, load, shift_enable, shift_right, data_out, full);
    end

endmodule
