`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk_s;
    reg [11:0] pixel_column;
    reg [11:0] pixel_row;
    wire [17:0] vid_addr;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk_s(clk_s),
        .pixel_column(pixel_column),
        .pixel_row(pixel_row),
        .vid_addr(vid_addr)
    );

    // Clock generation (10ns period)
    initial begin
        clk_s = 0;
        forever #5 clk_s = ~clk_s;
    end

        task reset_dut;

        begin
            pixel_column = 0;
            pixel_row = 0;
            @(posedge clk_s);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            pixel_column = 12'd0;
            pixel_row = 12'd0;
            @(posedge clk_s);
            #2;
            #1;

            check_outputs(18'h00000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            pixel_column = 12'd10;
            pixel_row = 12'd20;
            @(posedge clk_s);
            #2;

            #1;


            check_outputs(18'h01405);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            pixel_column = 12'd1023;
            pixel_row = 12'd1023;
            @(posedge clk_s);
            #2;

            #1;


            check_outputs(18'h3FFFF);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            pixel_column = 12'd640;
            pixel_row = 12'd480;
            @(posedge clk_s);
            #2;

            #1;


            check_outputs(18'h1E140);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            pixel_column = 12'd2048;
            pixel_row = 12'd2;
            @(posedge clk_s);
            #2;

            #1;


            check_outputs(18'h00200);
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
        input [17:0] expected_vid_addr;
        begin
            if (expected_vid_addr === (expected_vid_addr ^ vid_addr ^ expected_vid_addr)) begin
                $display("PASS");
                $display("  Outputs: vid_addr=%h",
                         vid_addr);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: vid_addr=%h",
                         expected_vid_addr);
                $display("  Got:      vid_addr=%h",
                         vid_addr);
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
        $dumpvars(0,clk_s, pixel_column, pixel_row, vid_addr);
    end

endmodule
