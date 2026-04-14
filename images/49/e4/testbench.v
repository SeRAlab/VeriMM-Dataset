`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg enable;
    reg reset;
    wire [3:0] count;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data_in(data_in),
        .enable(enable),
        .reset(reset),
        .count(count),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            enable = 0;
            data_in = 8'h00;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Reset Verification", test_num);
            reset_dut();
            #1;

            check_outputs(4'h0, 8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Single Operation", test_num);
            reset_dut();
            data_in = 8'hA5;
            enable = 1;
            @(posedge clk);
            #1;
            enable = 0;
            #1;

            check_outputs(4'h1, 8'h05);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Multiple Operations", test_num);
            reset_dut();
            enable = 1;
            data_in = 8'h11; @(posedge clk); #1;
            data_in = 8'h22; @(posedge clk); #1;
            data_in = 8'h33; @(posedge clk); #1;
            enable = 0;
            #1;

            check_outputs(4'h3, 8'h03);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Enable Gating", test_num);
            reset_dut();

            enable = 1; data_in = 8'hAA; @(posedge clk); #1;
            enable = 0; data_in = 8'hBB; @(posedge clk); #1;
            enable = 1; data_in = 8'hCC; @(posedge clk); #1;

            enable = 0;
            #1;

            check_outputs(4'h2, 8'h0C);
        end
        endtask

    task testcase005;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Counter Rollover", test_num);
            reset_dut();
            enable = 1;
            data_in = 8'hFF;
            for (i = 0; i < 16; i = i + 1) begin
                @(posedge clk);
                #1;
            end
            enable = 0;
            #1;

            check_outputs(4'h0, 8'h0F);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Masking Verification", test_num);
            reset_dut();
            data_in = 8'hF0;
            enable = 1;
            @(posedge clk);
            #1;
            enable = 0;
            #1;

            check_outputs(4'h1, 8'h00);
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
        input [3:0] expected_count;
        input [7:0] expected_data_out;
        begin
            if (expected_count === (expected_count ^ count ^ expected_count) &&
                expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: count=%h, data_out=%h",
                         count, data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count=%h, data_out=%h",
                         expected_count, expected_data_out);
                $display("  Got:      count=%h, data_out=%h",
                         count, data_out);
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
        $dumpvars(0,clk, data_in, enable, reset, count, data_out);
    end

endmodule
