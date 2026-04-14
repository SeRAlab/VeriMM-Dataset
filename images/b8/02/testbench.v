`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [4:0] BIN;
    reg clk;
    wire [3:0] BCD0;
    wire [3:0] BCD1;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .BIN(BIN),
        .clk(clk),
        .BCD0(BCD0),
        .BCD1(BCD1)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            BIN = 5'b0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning Test Case 001: BIN = 0");
            reset_dut();
            BIN = 5'd0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'h0, 4'h0);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning Test Case 002: BIN = 9");
            reset_dut();
            BIN = 5'd9;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'h9, 4'h0);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning Test Case 003: BIN = 10");
            reset_dut();
            BIN = 5'd10;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'h0, 4'h1);
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning Test Case 004: BIN = 19");
            reset_dut();
            BIN = 5'd19;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'h9, 4'h1);
        end
        endtask

    task testcase005;

        begin
            $display("\nRunning Test Case 005: BIN = 25");
            reset_dut();
            BIN = 5'd25;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'h5, 4'h2);
        end
        endtask

    task testcase006;

        begin
            $display("\nRunning Test Case 006: BIN = 31");
            reset_dut();
            BIN = 5'd31;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'h1, 4'h3);
        end
        endtask

    task testcase007;

        begin
            $display("\nRunning Test Case 007: BIN = 14");
            reset_dut();
            BIN = 5'd14;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'h4, 4'h1);
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
        input [3:0] expected_BCD0;
        input [3:0] expected_BCD1;
        begin
            if (expected_BCD0 === (expected_BCD0 ^ BCD0 ^ expected_BCD0) &&
                expected_BCD1 === (expected_BCD1 ^ BCD1 ^ expected_BCD1)) begin
                $display("PASS");
                $display("  Outputs: BCD0=%h, BCD1=%h",
                         BCD0, BCD1);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: BCD0=%h, BCD1=%h",
                         expected_BCD0, expected_BCD1);
                $display("  Got:      BCD0=%h, BCD1=%h",
                         BCD0, BCD1);
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
        $dumpvars(0,BIN, clk, BCD0, BCD1);
    end

endmodule
