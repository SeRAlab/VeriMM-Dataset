`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg rd;
    reg reset;
    reg wr;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data_in(data_in),
        .rd(rd),
        .reset(reset),
        .wr(wr),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            rd = 0;
            wr = 0;
            data_in = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning testcase001: Basic Single Write/Read");
            reset_dut();


            wr = 1; data_in = 8'hA5;
            @(posedge clk); #1;
            wr = 0;


            rd = 1;
            @(posedge clk); #1;
            rd = 0;

            #1;


            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning testcase002: Multiple Writes and Reads (Burst)");
            reset_dut();


            wr = 1; data_in = 8'h11; @(posedge clk); #1;
            wr = 1; data_in = 8'h22; @(posedge clk); #1;
            wr = 1; data_in = 8'h33; @(posedge clk); #1;
            wr = 1; data_in = 8'h44; @(posedge clk); #1;
            wr = 0;


            rd = 1; @(posedge clk); #1;
            rd = 1; @(posedge clk); #1;
            rd = 1; @(posedge clk); #1;
            rd = 1; @(posedge clk); #1;
            rd = 0;

            #1;


            check_outputs(8'h44);
        end
        endtask

    task testcase003;

        integer i;
        begin
            $display("\nRunning testcase003: Full Depth Test (16 items)");
            reset_dut();


            wr = 1;
            for (i = 0; i < 16; i = i + 1) begin
                data_in = i[7:0];
                @(posedge clk); #1;
            end
            wr = 0;


            rd = 1;
            for (i = 0; i < 16; i = i + 1) begin
                @(posedge clk); #1;
            end
            rd = 0;

            #1;


            check_outputs(8'd15);
        end
        endtask

    task testcase004;

        integer i;
        begin
            $display("\nRunning testcase004: Pointer Wrap-around Test");
            reset_dut();


            wr = 1;
            for (i = 0; i < 10; i = i + 1) begin
                data_in = i[7:0];
                @(posedge clk); #1;
            end
            wr = 0;


            rd = 1;
            for (i = 0; i < 10; i = i + 1) begin
                @(posedge clk); #1;
            end
            rd = 0;


            wr = 1;
            for (i = 0; i < 10; i = i + 1) begin
                data_in = 8'hF0 + i[7:0];
                @(posedge clk); #1;
            end
            wr = 0;


            rd = 1;
            for (i = 0; i < 10; i = i + 1) begin
                @(posedge clk); #1;
            end
            rd = 0;

            #1;


            check_outputs(8'hF9);
        end
        endtask

    task testcase005;

        begin
            $display("\nRunning testcase005: Simultaneous Read and Write");
            reset_dut();


            wr = 1; data_in = 8'hAA; @(posedge clk); #1;
            wr = 0;


            wr = 1; data_in = 8'hBB;
            rd = 1;
            @(posedge clk); #1;


            wr = 0;
            rd = 1;
            @(posedge clk); #1;
            rd = 0;

            #1;


            check_outputs(8'hBB);
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
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h",
                         expected_data_out);
                $display("  Got:      data_out=%h",
                         data_out);
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
        $dumpvars(0,clk, data_in, rd, reset, wr, data_out);
    end

endmodule
