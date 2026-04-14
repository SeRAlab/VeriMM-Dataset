`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg clk_ena;
    reg rst;
    reg [7:0] si;
    wire [7:0] so;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .clk_ena(clk_ena),
        .rst(rst),
        .si(si),
        .so(so)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            clk_ena = 0;
            si = 8'h00;
            @(posedge clk);
            #2 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase 001: Reset Check");
            reset_dut();

            #1;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase 002: Basic Shift 4 Stages");
            reset_dut();

            @(posedge clk);
            clk_ena = 1;
            si = 8'hA5;
            @(posedge clk);
            si = 8'h11;
            @(posedge clk);
            si = 8'h22;
            @(posedge clk);
            si = 8'h33;
            @(posedge clk);

            #1;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase 003: Clock Enable Stall Check");
            reset_dut();

            @(posedge clk);
            clk_ena = 1;
            si = 8'h55;
            @(posedge clk);

            clk_ena = 0;
            repeat (5) @(posedge clk);

            clk_ena = 1;
            si = 8'h00;
            repeat (3) @(posedge clk);

            #1;
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase 004: Sequence Propagation Check");
            reset_dut();

            @(posedge clk);
            clk_ena = 1;
            si = 8'h01; @(posedge clk);
            si = 8'h02; @(posedge clk);
            si = 8'h03; @(posedge clk);
            si = 8'h04; @(posedge clk);

            #1;
            #1;

            check_outputs(8'h01);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase 005: Mid-operation Reset");
            reset_dut();

            @(posedge clk);
            clk_ena = 1;
            si = 8'hFF;
            @(posedge clk);
            @(posedge clk);

            rst = 1;
            @(posedge clk);
            #1 rst = 0;

            repeat (4) @(posedge clk);

            #1;
            #1;

            check_outputs(8'h00);
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
        input [7:0] expected_so;
        begin
            if (expected_so === (expected_so ^ so ^ expected_so)) begin
                $display("PASS");
                $display("  Outputs: so=%h",
                         so);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: so=%h",
                         expected_so);
                $display("  Got:      so=%h",
                         so);
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
        $dumpvars(0,clk, clk_ena, rst, si, so);
    end

endmodule
