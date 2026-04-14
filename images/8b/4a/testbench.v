`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [10:0] hcount;
    reg [9:0] vcount;
    wire [11:0] pixel;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .hcount(hcount),
        .vcount(vcount),
        .pixel(pixel)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            hcount <= 11'd0;
            vcount <= 10'd0;
            @(posedge clk);
            #2;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            hcount <= 11'd0;
            vcount <= 10'd100;
            @(posedge clk);
            #2;
            #1;

            check_outputs(12'hFFF);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            hcount <= 11'd768;
            vcount <= 10'd100;
            @(posedge clk);
            #2;
            #1;

            check_outputs(12'hFFF);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            hcount <= 11'd200;
            vcount <= 10'd30;
            @(posedge clk);
            #2;
            #1;

            check_outputs(12'hFFF);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            hcount <= 11'd200;
            vcount <= 10'd568;
            @(posedge clk);
            #2;
            #1;

            check_outputs(12'hFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            hcount <= 11'd0;
            vcount <= 10'd30;
            @(posedge clk);
            #2;
            #1;

            check_outputs(12'hFFF);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            hcount <= 11'd100;
            vcount <= 10'd100;
            @(posedge clk);
            #2;
            #1;

            check_outputs(12'h000);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            hcount <= 11'd1;
            vcount <= 10'd100;
            @(posedge clk);
            #2;
            #1;

            check_outputs(12'h000);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            reset_dut();
            hcount <= 11'd767;
            vcount <= 10'd100;
            @(posedge clk);
            #2;
            #1;

            check_outputs(12'h000);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            reset_dut();
            hcount <= 11'd768;
            vcount <= 10'd568;
            @(posedge clk);
            #2;
            #1;

            check_outputs(12'hFFF);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            reset_dut();
            hcount <= 11'd1023;
            vcount <= 10'd767;
            @(posedge clk);
            #2;
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
        testcase009();
        testcase010();
        
        
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
        input [11:0] expected_pixel;
        begin
            if (expected_pixel === (expected_pixel ^ pixel ^ expected_pixel)) begin
                $display("PASS");
                $display("  Outputs: pixel=%h",
                         pixel);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: pixel=%h",
                         expected_pixel);
                $display("  Got:      pixel=%h",
                         pixel);
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
        $dumpvars(0,clk, hcount, vcount, pixel);
    end

endmodule
