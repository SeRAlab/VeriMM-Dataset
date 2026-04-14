`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] BIN;
    reg clk;
    wire [3:0] BCD_HIGH1;
    wire [3:0] BCD_HIGH2;
    wire [3:0] BCD_LOW1;
    wire [3:0] BCD_LOW2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .BIN(BIN),
        .clk(clk),
        .BCD_HIGH1(BCD_HIGH1),
        .BCD_HIGH2(BCD_HIGH2),
        .BCD_LOW1(BCD_LOW1),
        .BCD_LOW2(BCD_LOW2)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            BIN = 8'h00;
            repeat(2) @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: BIN = 8'h00 (Zeros)", test_num);
            BIN = 8'h00;
            repeat(2) @(posedge clk);
            #1;

            #1;


            check_outputs(4'd0, 4'd0, 4'd0, 4'd0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: BIN = 8'hA0 (High Nibble 10)", test_num);
            BIN = 8'hA0;
            repeat(2) @(posedge clk);
            #1;

            #1;


            check_outputs(4'd1, 4'd0, 4'd0, 4'd0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: BIN = 8'h0A (Low Nibble 10)", test_num);
            BIN = 8'h0A;
            repeat(2) @(posedge clk);
            #1;

            #1;


            check_outputs(4'd0, 4'd1, 4'd0, 4'd0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: BIN = 8'hFF (Both Nibbles 15)", test_num);
            BIN = 8'hFF;
            repeat(2) @(posedge clk);
            #1;

            #1;


            check_outputs(4'd1, 4'd1, 4'd5, 4'd5);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: BIN = 8'h47 (Nibbles 4 and 7)", test_num);
            BIN = 8'h47;
            repeat(2) @(posedge clk);
            #1;

            #1;


            check_outputs(4'd0, 4'd0, 4'd4, 4'd7);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: BIN = 8'hC3 (Nibbles 12 and 3)", test_num);
            BIN = 8'hC3;
            repeat(2) @(posedge clk);
            #1;

            #1;


            check_outputs(4'd1, 4'd0, 4'd2, 4'd3);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: BIN = 8'h2B (Nibbles 2 and 11)", test_num);
            BIN = 8'h2B;
            repeat(2) @(posedge clk);
            #1;

            #1;


            check_outputs(4'd0, 4'd1, 4'd2, 4'd1);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: BIN = 8'h99 (Nibbles 9 and 9)", test_num);
            BIN = 8'h99;
            repeat(2) @(posedge clk);
            #1;

            #1;


            check_outputs(4'd0, 4'd0, 4'd9, 4'd9);
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
        input [3:0] expected_BCD_HIGH1;
        input [3:0] expected_BCD_HIGH2;
        input [3:0] expected_BCD_LOW1;
        input [3:0] expected_BCD_LOW2;
        begin
            if (expected_BCD_HIGH1 === (expected_BCD_HIGH1 ^ BCD_HIGH1 ^ expected_BCD_HIGH1) &&
                expected_BCD_HIGH2 === (expected_BCD_HIGH2 ^ BCD_HIGH2 ^ expected_BCD_HIGH2) &&
                expected_BCD_LOW1 === (expected_BCD_LOW1 ^ BCD_LOW1 ^ expected_BCD_LOW1) &&
                expected_BCD_LOW2 === (expected_BCD_LOW2 ^ BCD_LOW2 ^ expected_BCD_LOW2)) begin
                $display("PASS");
                $display("  Outputs: BCD_HIGH1=%h, BCD_HIGH2=%h, BCD_LOW1=%h, BCD_LOW2=%h",
                         BCD_HIGH1, BCD_HIGH2, BCD_LOW1, BCD_LOW2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: BCD_HIGH1=%h, BCD_HIGH2=%h, BCD_LOW1=%h, BCD_LOW2=%h",
                         expected_BCD_HIGH1, expected_BCD_HIGH2, expected_BCD_LOW1, expected_BCD_LOW2);
                $display("  Got:      BCD_HIGH1=%h, BCD_HIGH2=%h, BCD_LOW1=%h, BCD_LOW2=%h",
                         BCD_HIGH1, BCD_HIGH2, BCD_LOW1, BCD_LOW2);
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
        $dumpvars(0,BIN, clk, BCD_HIGH1, BCD_HIGH2, BCD_LOW1, BCD_LOW2);
    end

endmodule
