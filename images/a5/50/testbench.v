`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] M;
    reg clk;
    reg [7:0] in;
    reg rst;
    wire [31:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .M(M),
        .clk(clk),
        .in(in),
        .rst(rst),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            M = 0;
            in = 0;
            repeat(2) @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Running Testcase 001: M=4, Constant Inputs (25)");
            reset_dut();
            M = 8'd4;
            in = 8'd25; @(posedge clk);
            in = 8'd25; @(posedge clk);
            in = 8'd25; @(posedge clk);
            in = 8'd25; @(posedge clk);

            repeat(1) @(posedge clk);
            #1;

            check_outputs(32'd25);
        end
        endtask

    task testcase002;

        begin
            $display("Running Testcase 002: M=2, Varying Inputs (10, 21)");
            reset_dut();
            M = 8'd2;
            in = 8'd10; @(posedge clk);
            in = 8'd21; @(posedge clk);

            repeat(1) @(posedge clk);
            #1;

            check_outputs(32'd15);
        end
        endtask

    task testcase003;

        begin
            $display("Running Testcase 003: M=1, Single Input (100)");
            reset_dut();
            M = 8'd1;
            in = 8'd100; @(posedge clk);

            repeat(1) @(posedge clk);
            #1;

            check_outputs(32'd100);
        end
        endtask

    task testcase004;

        begin
            $display("Running Testcase 004: M=3, All Inputs Zero");
            reset_dut();
            M = 8'd3;
            in = 8'd0; @(posedge clk);
            in = 8'd0; @(posedge clk);
            in = 8'd0; @(posedge clk);

            repeat(1) @(posedge clk);
            #1;

            check_outputs(32'd0);
        end
        endtask

    task testcase005;

        begin
            $display("Running Testcase 005: M=5, Max Inputs (255)");
            reset_dut();
            M = 8'd5;
            in = 8'd255; @(posedge clk);
            in = 8'd255; @(posedge clk);
            in = 8'd255; @(posedge clk);
            in = 8'd255; @(posedge clk);
            in = 8'd255; @(posedge clk);

            repeat(1) @(posedge clk);
            #1;

            check_outputs(32'd255);
        end
        endtask

    task testcase006;

        integer i;
        begin
            $display("Running Testcase 006: M=10, Inputs 1 to 10");
            reset_dut();
            M = 8'd10;
            for (i=1; i<=10; i=i+1) begin
                in = i; @(posedge clk);
            end

            repeat(1) @(posedge clk);
            #1;

            check_outputs(32'd5);
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
        input [31:0] expected_out;
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
        $dumpvars(0,M, clk, in, rst, out);
    end

endmodule
