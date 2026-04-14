`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] BCD;
    reg clk;
    reg rst;
    wire [7:0] DISPLAY;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .BCD(BCD),
        .clk(clk),
        .rst(rst),
        .DISPLAY(DISPLAY)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            BCD = 0;
            @(posedge clk);
            #1;
            rst = 0;

            repeat (5) @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            BCD = 4'd0;
            @(posedge clk); #1;
            $display("Test Case 001: BCD = 0");
            #1;

            check_outputs(8'h3F);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            BCD = 4'd1;
            @(posedge clk); #1;
            $display("Test Case 002: BCD = 1");
            #1;

            check_outputs(8'h06);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            BCD = 4'd2;
            @(posedge clk); #1;
            $display("Test Case 003: BCD = 2");
            #1;

            check_outputs(8'h5B);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            BCD = 4'd3;
            @(posedge clk); #1;
            $display("Test Case 004: BCD = 3");
            #1;

            check_outputs(8'h4F);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            BCD = 4'd4;
            @(posedge clk); #1;
            $display("Test Case 005: BCD = 4");
            #1;

            check_outputs(8'h66);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            BCD = 4'd5;
            @(posedge clk); #1;
            $display("Test Case 006: BCD = 5");
            #1;

            check_outputs(8'h6D);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            BCD = 4'd6;
            @(posedge clk); #1;
            $display("Test Case 007: BCD = 6");
            #1;

            check_outputs(8'h7D);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            reset_dut();
            BCD = 4'd7;
            @(posedge clk); #1;
            $display("Test Case 008: BCD = 7");
            #1;

            check_outputs(8'h07);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            reset_dut();
            BCD = 4'd8;
            @(posedge clk); #1;
            $display("Test Case 009: BCD = 8");
            #1;

            check_outputs(8'h7F);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            reset_dut();
            BCD = 4'd9;
            @(posedge clk); #1;
            $display("Test Case 010: BCD = 9");
            #1;

            check_outputs(8'h6F);
        end
        endtask

    task testcase011;

        begin
            test_num = 11;
            reset_dut();
            BCD = 4'd10;
            @(posedge clk); #1;
            $display("Test Case 011: BCD = 10 (Invalid)");
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase012;

        begin
            test_num = 12;
            reset_dut();
            BCD = 4'd15;
            @(posedge clk); #1;
            $display("Test Case 012: BCD = 15 (Invalid)");
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
        testcase006();
        testcase007();
        testcase008();
        testcase009();
        testcase010();
        testcase011();
        testcase012();
        
        
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
        input [7:0] expected_DISPLAY;
        begin
            if (expected_DISPLAY === (expected_DISPLAY ^ DISPLAY ^ expected_DISPLAY)) begin
                $display("PASS");
                $display("  Outputs: DISPLAY=%h",
                         DISPLAY);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: DISPLAY=%h",
                         expected_DISPLAY);
                $display("  Got:      DISPLAY=%h",
                         DISPLAY);
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
        $dumpvars(0,BCD, clk, rst, DISPLAY);
    end

endmodule
