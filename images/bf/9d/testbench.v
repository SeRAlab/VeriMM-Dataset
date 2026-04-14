`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg blank;
    reg clk;
    reg [10:0] hcount;
    reg [9:0] vcount;
    reg [15:0] x;
    reg [15:0] y;
    wire [11:0] addr;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .blank(blank),
        .clk(clk),
        .hcount(hcount),
        .vcount(vcount),
        .x(x),
        .y(y),
        .addr(addr)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            blank = 0;
            hcount = 0;
            vcount = 0;
            x = 16'hFFFF;
            y = 16'hFFFF;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            blank = 1;
            x = 16'd100;
            y = 16'd50;
            hcount = 11'd105;
            vcount = 10'd55;
            @(posedge clk);
            #1;
            $display("Testcase 001: Blank active");
            #1;

            check_outputs(12'h000);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            blank = 0;
            x = 16'd100;
            y = 16'd50;
            hcount = 11'd100;
            vcount = 10'd50;
            @(posedge clk);
            #1;
            $display("Testcase 002: Top-left corner (100, 50)");
            #1;

            check_outputs(12'h000);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            blank = 0;
            x = 16'd100;
            y = 16'd50;
            hcount = 11'd105;
            vcount = 10'd52;

            @(posedge clk);
            #1;
            $display("Testcase 003: Inside point (105, 52)");
            #1;

            check_outputs(12'h085);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            blank = 0;
            x = 16'd100;
            y = 16'd50;
            hcount = 11'd163;
            vcount = 10'd113;

            @(posedge clk);
            #1;
            $display("Testcase 004: Bottom-right corner (163, 113)");
            #1;

            check_outputs(12'hFFF);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            blank = 0;
            x = 16'd100;
            y = 16'd50;
            hcount = 11'd164;
            vcount = 10'd60;
            @(posedge clk);
            #1;
            $display("Testcase 005: Out of bounds (H too large)");
            #1;

            check_outputs(12'h000);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            blank = 0;
            x = 16'd100;
            y = 16'd50;
            hcount = 11'd110;
            vcount = 10'd114;
            @(posedge clk);
            #1;
            $display("Testcase 006: Out of bounds (V too large)");
            #1;

            check_outputs(12'h000);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = 7;
            blank = 0;
            x = 16'd100;
            y = 16'd50;
            hcount = 11'd99;
            vcount = 10'd60;
            @(posedge clk);
            #1;
            $display("Testcase 007: Out of bounds (H too small)");
            #1;

            check_outputs(12'h000);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            test_num = 8;
            blank = 0;
            x = 16'd100;
            y = 16'd50;
            hcount = 11'd110;
            vcount = 10'd49;
            @(posedge clk);
            #1;
            $display("Testcase 008: Out of bounds (V too small)");
            #1;

            check_outputs(12'h000);
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
        input [11:0] expected_addr;
        begin
            if (expected_addr === (expected_addr ^ addr ^ expected_addr)) begin
                $display("PASS");
                $display("  Outputs: addr=%h",
                         addr);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: addr=%h",
                         expected_addr);
                $display("  Got:      addr=%h",
                         addr);
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
        $dumpvars(0,blank, clk, hcount, vcount, x, y, addr);
    end

endmodule
