`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg dir;
    reg [3:0] in;
    reg rst;
    reg shift;
    wire [3:0] out;
    wire [3:0] shifted_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .dir(dir),
        .in(in),
        .rst(rst),
        .shift(shift),
        .out(out),
        .shifted_out(shifted_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            shift = 0;
            dir = 0;
            in = 4'b0000;
            @(posedge clk);
            #1 rst = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            in = 4'b1111;
            shift = 0;
            @(posedge clk);
            #1;

            rst = 1;
            @(posedge clk);
            #1;
            $display("Testcase 001: Synchronous Reset");
            #1;

            check_outputs(4'b0000, 4'b0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            in = 4'b1010;
            shift = 0;
            @(posedge clk);
            #1;
            $display("Testcase 002: Parallel Load (shift=0)");
            #1;

            check_outputs(4'b1010, 4'b0000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();

            in = 4'b1100; shift = 0;
            @(posedge clk); #1;

            shift = 1; dir = 0; in = 4'b0001;
            @(posedge clk); #1;

            $display("Testcase 003: Shift Left (dir=0)");
            #1;

            check_outputs(4'b1001, 4'b0001);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();

            in = 4'b0011; shift = 0;
            @(posedge clk); #1;

            shift = 1; dir = 1; in = 4'b1000;
            @(posedge clk); #1;

            $display("Testcase 004: Shift Right (dir=1)");
            #1;

            check_outputs(4'b1001, 4'b0001);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();

            in = 4'b0111; shift = 0;
            @(posedge clk); #1;

            shift = 1; dir = 0; in = 4'b0000;
            @(posedge clk); #1;

            $display("Testcase 005: Shift Left, pop 0");
            #1;

            check_outputs(4'b1110, 4'b0000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();

            in = 4'b1000; shift = 0; @(posedge clk); #1;

            shift = 1; dir = 0; in = 4'b0000; @(posedge clk); #1;

            shift = 1; dir = 0; in = 4'b0001; @(posedge clk); #1;
            $display("Testcase 006: Multi-cycle Shift Left");
            #1;

            check_outputs(4'b0001, 4'b0000);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();

            in = 4'b0001; shift = 0; @(posedge clk); #1;

            shift = 1; dir = 1; in = 4'b1000; @(posedge clk); #1;
            $display("Testcase 007: Shift Right sequence");
            #1;

            check_outputs(4'b1000, 4'b0001);
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
        input [3:0] expected_out;
        input [3:0] expected_shifted_out;
        begin
            if (expected_out === (expected_out ^ out ^ expected_out) &&
                expected_shifted_out === (expected_shifted_out ^ shifted_out ^ expected_shifted_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h, shifted_out=%h",
                         out, shifted_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h, shifted_out=%h",
                         expected_out, expected_shifted_out);
                $display("  Got:      out=%h, shifted_out=%h",
                         out, shifted_out);
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
        $dumpvars(0,clk, dir, in, rst, shift, out, shifted_out);
    end

endmodule
