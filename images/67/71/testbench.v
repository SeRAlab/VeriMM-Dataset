`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [1:0] a;
    reg ce;
    reg clk;
    reg [7:0] data;
    wire [7:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .ce(ce),
        .clk(clk),
        .data(data),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            ce = 1;
            data = 8'h00;
            a = 0;
            repeat(5) @(posedge clk);
            ce = 0;
            #2;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            @(posedge clk);
            ce = 1; data = 8'hA1;
            @(posedge clk);
            ce = 1; data = 8'hB2;
            @(posedge clk);
            ce = 1; data = 8'hC3;
            @(posedge clk);
            ce = 1; data = 8'hD4;
            @(posedge clk);
            ce = 0;
            a = 2'd3;
            #1;
            #1;

            check_outputs(8'hA1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            @(posedge clk);
            ce = 1; data = 8'h11;
            @(posedge clk);
            ce = 1; data = 8'h22;
            @(posedge clk);
            ce = 1; data = 8'h33;
            @(posedge clk);
            ce = 1; data = 8'h44;
            @(posedge clk);
            ce = 0;
            a = 2'd0;
            #1;
            #1;

            check_outputs(8'h44);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            @(posedge clk);
            ce = 1; data = 8'hFF;
            @(posedge clk);
            ce = 0; data = 8'hEE;
            @(posedge clk);
            ce = 1; data = 8'hDD;
            @(posedge clk);
            ce = 0;
            a = 2'd1;
            #1;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase004;

        begin
            reset_dut();

            @(posedge clk); ce = 1; data = 8'h01;
            @(posedge clk); ce = 1; data = 8'h02;
            @(posedge clk); ce = 1; data = 8'h03;
            @(posedge clk); ce = 1; data = 8'h04;
            @(posedge clk); ce = 1; data = 8'h05;
            @(posedge clk); ce = 0;
            a = 2'd3;
            #1;
            #1;

            check_outputs(8'h02);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            @(posedge clk); ce = 1; data = 8'hAA;
            @(posedge clk); ce = 1; data = 8'hBB;
            @(posedge clk); ce = 0;

            a = 2'd0; #1;
            if (q !== 8'hBB) fail_count = fail_count + 1; else pass_count = pass_count + 1;

            a = 2'd1; #1;
            #1;

            check_outputs(8'hAA);
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
        input [7:0] expected_q;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: q=%h",
                         q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%h",
                         expected_q);
                $display("  Got:      q=%h",
                         q);
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
        $dumpvars(0,a, ce, clk, data, q);
    end

endmodule
