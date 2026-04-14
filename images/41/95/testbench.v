`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg i_clk;
    reg [1:0] i_data;
    reg i_ready;
    wire [4:0] o_data;
    wire o_ready;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .i_clk(i_clk),
        .i_data(i_data),
        .i_ready(i_ready),
        .o_data(o_data),
        .o_ready(o_ready)
    );

    // Clock generation (10ns period)
    initial begin
        i_clk = 0;
        forever #5 i_clk = ~i_clk;
    end

        task reset_dut;

    begin
        i_data = 2'b00;
        i_ready = 0;
        @(posedge i_clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        $display("Running Testcase 001: Basic Positive Accumulation...");
        test_num = 1;
        reset_dut();

        @(posedge i_clk);
        i_ready = 1; i_data = 2'b01;
        @(posedge i_clk);
        i_ready = 1; i_data = 2'b01;
        @(posedge i_clk);

        #1;
        #1;

        check_outputs(5'sd2, 1'b1);
    end
        endtask

    task testcase002;

    begin
        $display("Running Testcase 002: Accumulate Negative Numbers...");
        test_num = 2;


        i_ready = 1; i_data = 2'b11;
        @(posedge i_clk);
        i_ready = 1; i_data = 2'b11;
        @(posedge i_clk);

        #1;
        #1;

        check_outputs(5'sd0, 1'b1);
    end
        endtask

    task testcase003;

    begin
        $display("Running Testcase 003: Verify i_ready Gating...");
        test_num = 3;

        @(posedge i_clk);
        i_ready = 1; i_data = 2'b01;
        @(posedge i_clk);
        i_ready = 0; i_data = 2'b01;
        @(posedge i_clk);
        i_ready = 1; i_data = 2'b01;
        @(posedge i_clk);

        #1;
        #1;

        check_outputs(5'sd2, 1'b1);
    end
        endtask

    task testcase004;

    begin
        $display("Running Testcase 004: Large Negative Jumps...");
        test_num = 4;

        @(posedge i_clk);
        i_ready = 1; i_data = 2'b10;
        @(posedge i_clk);
        i_ready = 1; i_data = 2'b10;
        @(posedge i_clk);

        #1;
        #1;

        check_outputs(5'sb11110, 1'b1);
    end
        endtask

    task testcase005;

    integer i;
    begin
        $display("Running Testcase 005: Accumulate to Minimum (-16)...");
        test_num = 5;

        for(i=0; i<7; i=i+1) begin
            i_ready = 1; i_data = 2'b10;
            @(posedge i_clk);
        end

        #1;
        #1;

        check_outputs(5'sb10000, 1'b1);
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
        input [4:0] expected_o_data;
        input expected_o_ready;
        begin
            if (expected_o_data === (expected_o_data ^ o_data ^ expected_o_data) &&
                expected_o_ready === (expected_o_ready ^ o_ready ^ expected_o_ready)) begin
                $display("PASS");
                $display("  Outputs: o_data=%h, o_ready=%b",
                         o_data, o_ready);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o_data=%h, o_ready=%b",
                         expected_o_data, expected_o_ready);
                $display("  Got:      o_data=%h, o_ready=%b",
                         o_data, o_ready);
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
        $dumpvars(0,i_clk, i_data, i_ready, o_data, o_ready);
    end

endmodule
