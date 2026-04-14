`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] bin_in;
    reg clk;
    reg rst;
    wire done;
    wire [7:0] gray_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .bin_in(bin_in),
        .clk(clk),
        .rst(rst),
        .done(done),
        .gray_out(gray_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(posedge clk);
            rst = 1;
            bin_in = 8'h00;
            @(posedge clk);
            rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning Testcase 001: Input = 0");
            reset_dut();
            bin_in = 8'd0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 8'h00);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning Testcase 002: Input = 1");
            reset_dut();
            bin_in = 8'd1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 8'h01);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning Testcase 003: Input = 128");
            reset_dut();
            bin_in = 8'd128;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 8'hC0);
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning Testcase 004: Input = 255");
            reset_dut();
            bin_in = 8'd255;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 8'h80);
        end
        endtask

    task testcase005;

        begin
            $display("\nRunning Testcase 005: Input = 170 (0xAA)");
            reset_dut();
            bin_in = 8'hAA;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 8'hFF);
        end
        endtask

    task testcase006;

        begin
            $display("\nRunning Testcase 006: Input = 85 (0x55)");
            reset_dut();
            bin_in = 8'h55;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 8'h7F);
        end
        endtask

    task testcase007;

        begin
            $display("\nRunning Testcase 007: Input = 64");
            reset_dut();
            bin_in = 8'd64;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 8'h60);
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
        input expected_done;
        input [7:0] expected_gray_out;
        begin
            if (expected_done === (expected_done ^ done ^ expected_done) &&
                expected_gray_out === (expected_gray_out ^ gray_out ^ expected_gray_out)) begin
                $display("PASS");
                $display("  Outputs: done=%b, gray_out=%h",
                         done, gray_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: done=%b, gray_out=%h",
                         expected_done, expected_gray_out);
                $display("  Got:      done=%b, gray_out=%h",
                         done, gray_out);
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
        $dumpvars(0,bin_in, clk, rst, done, gray_out);
    end

endmodule
