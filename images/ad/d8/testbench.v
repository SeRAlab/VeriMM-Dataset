`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg data_in_end;
    reg data_in_start;
    reg reset;
    wire [7:0] data_out;
    wire data_out_end;
    wire data_out_start;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data_in(data_in),
        .data_in_end(data_in_end),
        .data_in_start(data_in_start),
        .reset(reset),
        .data_out(data_out),
        .data_out_end(data_out_end),
        .data_out_start(data_out_start)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            data_in = 8'h0;
            data_in_start = 0;
            data_in_end = 0;
            repeat(2) @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Reset State Check");
            test_num = 1;
            reset_dut();

            #1;


            check_outputs(8'h00, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Single Write Operation");
            test_num = 2;
            reset_dut();
            @(posedge clk);
            data_in = 8'hA5;
            data_in_start = 1;
            @(posedge clk);
            data_in_start = 0;
            #1;

            #1;


            check_outputs(8'hA5, 1'b0, 1'b1);
        end
        endtask

    task testcase003;

        integer i;
        begin
            $display("Testcase 003: Fill to Full");
            test_num = 3;
            reset_dut();
            for (i=1; i<=16; i=i+1) begin
                @(posedge clk);
                data_in = i;
                data_in_start = 1;
            end
            @(posedge clk);
            data_in_start = 0;
            #1;

            #1;


            check_outputs(8'h01, 1'b1, 1'b1);
        end
        endtask

    task testcase004;

        integer i;
        begin
            $display("Testcase 004: Clear Full Flag via Read");
            test_num = 4;
            reset_dut();

            for (i=1; i<=16; i=i+1) begin
                @(posedge clk);
                data_in = i; data_in_start = 1;
            end
            @(posedge clk);
            data_in_start = 0;

            @(posedge clk);
            data_in_end = 1;
            @(posedge clk);
            data_in_end = 0;
            #1;

            #1;


            check_outputs(8'h02, 1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Read until Empty");
            test_num = 5;
            reset_dut();

            @(posedge clk);
            data_in = 8'h55; data_in_start = 1;
            @(posedge clk);
            data_in_start = 0;

            @(posedge clk);
            data_in_end = 1;
            @(posedge clk);
            data_in_end = 0;
            #1;

            #1;


            check_outputs(8'h55, 1'b0, 1'b0);
        end
        endtask

    task testcase006;

        integer i;
        begin
            $display("Testcase 006: Pointer Wrap Around Check");
            test_num = 6;
            reset_dut();

            for (i=1; i<=10; i=i+1) begin
                @(posedge clk);
                data_in = i; data_in_start = 1;
            end
            @(posedge clk);
            data_in_start = 0;

            for (i=0; i<10; i=i+1) begin
                @(posedge clk);
                data_in_end = 1;
            end
            @(posedge clk);
            data_in_end = 0;

            for (i=20; i<=29; i=i+1) begin
                @(posedge clk);
                data_in = i; data_in_start = 1;
            end
            @(posedge clk);
            data_in_start = 0;

            for (i=0; i<5; i=i+1) begin
                @(posedge clk);
                data_in_end = 1;
            end
            @(posedge clk);
            data_in_end = 0;
            #1;

            #1;


            check_outputs(8'd25, 1'b0, 1'b1);
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
        input [7:0] expected_data_out;
        input expected_data_out_end;
        input expected_data_out_start;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_data_out_end === (expected_data_out_end ^ data_out_end ^ expected_data_out_end) &&
                expected_data_out_start === (expected_data_out_start ^ data_out_start ^ expected_data_out_start)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, data_out_end=%b, data_out_start=%b",
                         data_out, data_out_end, data_out_start);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, data_out_end=%b, data_out_start=%b",
                         expected_data_out, expected_data_out_end, expected_data_out_start);
                $display("  Got:      data_out=%h, data_out_end=%b, data_out_start=%b",
                         data_out, data_out_end, data_out_start);
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
        $dumpvars(0,clk, data_in, data_in_end, data_in_start, reset, data_out, data_out_end, data_out_start);
    end

endmodule
