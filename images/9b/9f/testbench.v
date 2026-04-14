`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [1:0] i_transize;
    reg i_valid;
    reg rst;
    wire [1:0] i_transize_1;
    wire [1:0] i_transize_2;
    wire [1:0] i_transize_3;
    wire [1:0] i_transize_4;
    wire i_valid_4;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .i_transize(i_transize),
        .i_valid(i_valid),
        .rst(rst),
        .i_transize_1(i_transize_1),
        .i_transize_2(i_transize_2),
        .i_transize_3(i_transize_3),
        .i_transize_4(i_transize_4),
        .i_valid_4(i_valid_4)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            i_valid = 0;
            i_transize = 2'b00;
            repeat(2) @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Running Testcase 001: Reset State Check");
            reset_dut();

            #1;
            #1;

            check_outputs(2'b00, 2'b00, 2'b00, 2'b00, 1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("Running Testcase 002: Single Pulse Propagation");
            reset_dut();

            i_valid = 1; i_transize = 2'b11;
            @(posedge clk);
            i_valid = 0; i_transize = 2'b00;
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            #1;

            #1;


            check_outputs(2'b00, 2'b00, 2'b00, 2'b11, 1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("Running Testcase 003: Continuous Pipeline Flow");
            reset_dut();

            i_valid = 1; i_transize = 2'b01; @(posedge clk);
            i_valid = 1; i_transize = 2'b10; @(posedge clk);
            i_valid = 1; i_transize = 2'b11; @(posedge clk);
            i_valid = 1; i_transize = 2'b00; @(posedge clk);
            #1;
            #1;

            check_outputs(2'b00, 2'b11, 2'b10, 2'b01, 1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("Running Testcase 004: Intermittent Valid Signals");
            reset_dut();

            i_valid = 1; i_transize = 2'b11; @(posedge clk);

            i_valid = 0; i_transize = 2'b00; @(posedge clk);

            i_valid = 1; i_transize = 2'b10; @(posedge clk);

            i_valid = 0; i_transize = 2'b01; @(posedge clk);
            #1;


            #1;



            check_outputs(2'b01, 2'b10, 2'b00, 2'b11, 1'b1);
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
        input [1:0] expected_i_transize_1;
        input [1:0] expected_i_transize_2;
        input [1:0] expected_i_transize_3;
        input [1:0] expected_i_transize_4;
        input expected_i_valid_4;
        begin
            if (expected_i_transize_1 === (expected_i_transize_1 ^ i_transize_1 ^ expected_i_transize_1) &&
                expected_i_transize_2 === (expected_i_transize_2 ^ i_transize_2 ^ expected_i_transize_2) &&
                expected_i_transize_3 === (expected_i_transize_3 ^ i_transize_3 ^ expected_i_transize_3) &&
                expected_i_transize_4 === (expected_i_transize_4 ^ i_transize_4 ^ expected_i_transize_4) &&
                expected_i_valid_4 === (expected_i_valid_4 ^ i_valid_4 ^ expected_i_valid_4)) begin
                $display("PASS");
                $display("  Outputs: i_transize_1=%h, i_transize_2=%h, i_transize_3=%h, i_transize_4=%h, i_valid_4=%b",
                         i_transize_1, i_transize_2, i_transize_3, i_transize_4, i_valid_4);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: i_transize_1=%h, i_transize_2=%h, i_transize_3=%h, i_transize_4=%h, i_valid_4=%b",
                         expected_i_transize_1, expected_i_transize_2, expected_i_transize_3, expected_i_transize_4, expected_i_valid_4);
                $display("  Got:      i_transize_1=%h, i_transize_2=%h, i_transize_3=%h, i_transize_4=%h, i_valid_4=%b",
                         i_transize_1, i_transize_2, i_transize_3, i_transize_4, i_valid_4);
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
        $dumpvars(0,clk, i_transize, i_valid, rst, i_transize_1, i_transize_2, i_transize_3, i_transize_4, i_valid_4);
    end

endmodule
