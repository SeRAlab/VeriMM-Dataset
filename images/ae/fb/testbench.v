`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg vga_clk;
    wire blank;
    wire [11:0] column;
    wire hsync;
    wire line_clk;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .vga_clk(vga_clk),
        .blank(blank),
        .column(column),
        .hsync(hsync),
        .line_clk(line_clk)
    );

    // Clock generation (10ns period)
    initial begin
        vga_clk = 0;
        forever #5 vga_clk = ~vga_clk;
    end

        task reset_dut;

        begin


            @(posedge vga_clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Checking Start of Active Display (Pixel 0)", test_num);
            reset_dut();

            while (column !== 0) @(posedge vga_clk);
            #2;
            #1;

            check_outputs(0, 12'd0, 1, line_clk);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Checking End of Active Display (Pixel 639)", test_num);
            reset_dut();
            while (column !== 12'd639) @(posedge vga_clk);
            #2;
            #1;

            check_outputs(0, 12'd639, 1, line_clk);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Checking Start of Blanking (Pixel 640)", test_num);
            reset_dut();
            while (column !== 12'd640) @(posedge vga_clk);
            #2;
            #1;

            check_outputs(1, 12'd640, 1, line_clk);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Checking Start of Hsync Pulse (Pixel 656)", test_num);
            reset_dut();
            while (column !== 12'd656) @(posedge vga_clk);
            #2;
            #1;

            check_outputs(1, 12'd656, 0, line_clk);
        end
        endtask

    task testcase005;

        reg prev_line_clk;
        begin
            test_num = 5;
            $display("Testcase %03d: Checking Line Rollover and line_clk toggle", test_num);
            reset_dut();
            while (column !== 12'd799) @(posedge vga_clk);
            prev_line_clk = line_clk;
            @(posedge vga_clk);
            #2;

            if (line_clk !== prev_line_clk) begin
                #1;

                check_outputs(0, 12'd0, 1, line_clk);
            end else begin
                $display("FAIL: line_clk did not toggle at rollover");
                fail_count = fail_count + 1;
            end
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
        input expected_blank;
        input [11:0] expected_column;
        input expected_hsync;
        input expected_line_clk;
        begin
            if (expected_blank === (expected_blank ^ blank ^ expected_blank) &&
                expected_column === (expected_column ^ column ^ expected_column) &&
                expected_hsync === (expected_hsync ^ hsync ^ expected_hsync) &&
                expected_line_clk === (expected_line_clk ^ line_clk ^ expected_line_clk)) begin
                $display("PASS");
                $display("  Outputs: blank=%b, column=%h, hsync=%b, line_clk=%b",
                         blank, column, hsync, line_clk);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: blank=%b, column=%h, hsync=%b, line_clk=%b",
                         expected_blank, expected_column, expected_hsync, expected_line_clk);
                $display("  Got:      blank=%b, column=%h, hsync=%b, line_clk=%b",
                         blank, column, hsync, line_clk);
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
        $dumpvars(0,vga_clk, blank, column, hsync, line_clk);
    end

endmodule
