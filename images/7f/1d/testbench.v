`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg reset;
    reg write_en;
    wire [7:0] data_out;
    wire empty;
    wire full;
    wire read_en;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data_in(data_in),
        .reset(reset),
        .write_en(write_en),
        .data_out(data_out),
        .empty(empty),
        .full(full),
        .read_en(read_en)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            write_en = 0;
            data_in = 8'h0;

            @(posedge clk);
            #1;
            @(posedge clk);
            #1;
            reset = 0;

            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase 001: Initial State after Reset");
            reset_dut();

            #1;


            check_outputs(8'h00, 1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase 002: Single Write Operation (0xAA)");
            reset_dut();


            data_in = 8'hAA;
            write_en = 1;
            @(posedge clk);
            #1;
            write_en = 0;


            repeat(1) @(posedge clk);
            #1;



            #1;




            check_outputs(8'hAA, 1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = 3;
            $display("Testcase 003: Filling FIFO to Depth 16");
            reset_dut();


            for (i = 0; i < 16; i = i + 1) begin
                data_in = i[7:0];
                write_en = 1;
                @(posedge clk);
                #1;
            end
            write_en = 0;


            #1;

            #1;


            check_outputs(8'h00, 1'b0, 1'b1, 1'b1);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = 4;
            $display("Testcase 004: Overflow Write Check");
            reset_dut();


            for (i = 0; i < 16; i = i + 1) begin
                data_in = i[7:0];
                write_en = 1;
                @(posedge clk);
                #1;
            end


            data_in = 8'hFF;
            write_en = 1;
            @(posedge clk);
            #1;
            write_en = 0;


            #1;
            #1;

            check_outputs(8'h00, 1'b0, 1'b1, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase 005: Partial Fill Verification");
            reset_dut();


            repeat(8) begin
                data_in = 8'h55;
                write_en = 1;
                @(posedge clk);
                #1;
            end
            write_en = 0;


            #1;
            #1;

            check_outputs(8'h55, 1'b0, 1'b0, 1'b1);
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
        input [7:0] expected_data_out;
        input expected_empty;
        input expected_full;
        input expected_read_en;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_empty === (expected_empty ^ empty ^ expected_empty) &&
                expected_full === (expected_full ^ full ^ expected_full) &&
                expected_read_en === (expected_read_en ^ read_en ^ expected_read_en)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, empty=%b, full=%b, read_en=%b",
                         data_out, empty, full, read_en);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, empty=%b, full=%b, read_en=%b",
                         expected_data_out, expected_empty, expected_full, expected_read_en);
                $display("  Got:      data_out=%h, empty=%b, full=%b, read_en=%b",
                         data_out, empty, full, read_en);
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
        $dumpvars(0,clk, data_in, reset, write_en, data_out, empty, full, read_en);
    end

endmodule
