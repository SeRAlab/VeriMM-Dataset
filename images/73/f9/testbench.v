`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] DATA_IN;
    reg clk;
    wire [6:0] SEVEN_SEG_OUT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .DATA_IN(DATA_IN),
        .clk(clk),
        .SEVEN_SEG_OUT(SEVEN_SEG_OUT)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            DATA_IN = 4'b0;
            repeat(5) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            DATA_IN = 4'd0;
            repeat(4) @(posedge clk);
            #1;
            $display("Test Case 001: Input = 0");
            #1;

            check_outputs(7'h3F);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            DATA_IN = 4'd1;
            repeat(4) @(posedge clk);
            #1;
            $display("Test Case 002: Input = 1");
            #1;

            check_outputs(7'h06);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            DATA_IN = 4'd2;
            repeat(4) @(posedge clk);
            #1;
            $display("Test Case 003: Input = 2");
            #1;

            check_outputs(7'h5B);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            DATA_IN = 4'd3;
            repeat(4) @(posedge clk);
            #1;
            $display("Test Case 004: Input = 3");
            #1;

            check_outputs(7'h4F);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            DATA_IN = 4'd4;
            repeat(4) @(posedge clk);
            #1;
            $display("Test Case 005: Input = 4");
            #1;

            check_outputs(7'h66);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            DATA_IN = 4'd5;
            repeat(4) @(posedge clk);
            #1;
            $display("Test Case 006: Input = 5");
            #1;

            check_outputs(7'h6D);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            DATA_IN = 4'd6;
            repeat(4) @(posedge clk);
            #1;
            $display("Test Case 007: Input = 6");
            #1;

            check_outputs(7'h7D);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            DATA_IN = 4'd7;
            repeat(4) @(posedge clk);
            #1;
            $display("Test Case 008: Input = 7");
            #1;

            check_outputs(7'h07);
        end
        endtask

    task testcase009;

        begin
            reset_dut();
            DATA_IN = 4'd8;
            repeat(4) @(posedge clk);
            #1;
            $display("Test Case 009: Input = 8");
            #1;

            check_outputs(7'h7F);
        end
        endtask

    task testcase010;

        begin
            reset_dut();
            DATA_IN = 4'd9;
            repeat(4) @(posedge clk);
            #1;
            $display("Test Case 010: Input = 9");
            #1;

            check_outputs(7'h6F);
        end
        endtask

    task testcase011;

        begin
            reset_dut();
            DATA_IN = 4'd10;
            repeat(4) @(posedge clk);
            #1;
            $display("Test Case 011: Input = 10 (Error State)");

            #1;


            check_outputs(7'h00);
        end
        endtask

    task testcase012;

        begin
            reset_dut();
            DATA_IN = 4'd15;
            repeat(4) @(posedge clk);
            #1;
            $display("Test Case 012: Input = 15 (Error State)");
            #1;

            check_outputs(7'h00);
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
        input [6:0] expected_SEVEN_SEG_OUT;
        begin
            if (expected_SEVEN_SEG_OUT === (expected_SEVEN_SEG_OUT ^ SEVEN_SEG_OUT ^ expected_SEVEN_SEG_OUT)) begin
                $display("PASS");
                $display("  Outputs: SEVEN_SEG_OUT=%h",
                         SEVEN_SEG_OUT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: SEVEN_SEG_OUT=%h",
                         expected_SEVEN_SEG_OUT);
                $display("  Got:      SEVEN_SEG_OUT=%h",
                         SEVEN_SEG_OUT);
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
        $dumpvars(0,DATA_IN, clk, SEVEN_SEG_OUT);
    end

endmodule
