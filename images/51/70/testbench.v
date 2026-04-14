`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] in;
    reg reset;
    reg shift_dir;
    reg shift_mode;
    wire [7:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .in(in),
        .reset(reset),
        .shift_dir(shift_dir),
        .shift_mode(shift_mode),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            in = 8'h00;
            shift_dir = 0;
            shift_mode = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Reset Check");
            reset_dut();

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Parallel Load 8'hA5");
            reset_dut();
            in = 8'hA5;
            shift_mode = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Serial Shift Down (Right) 1 bit");
            reset_dut();

            in = 8'h80;
            shift_mode = 1;
            @(posedge clk);
            #1;

            shift_mode = 0;
            shift_dir = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h40);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Serial Shift Up (Left) 1 bit");
            reset_dut();

            in = 8'h01;
            shift_mode = 1;
            @(posedge clk);
            #1;

            shift_mode = 0;
            shift_dir = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h02);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Multiple Serial Shifts Down (4 bits)");
            reset_dut();

            in = 8'hF0;
            shift_mode = 1;
            @(posedge clk);
            #1;

            shift_mode = 0;
            shift_dir = 0;
            repeat(4) @(posedge clk);
            #1;
            #1;

            check_outputs(8'h0F);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Multiple Serial Shifts Up (4 bits)");
            reset_dut();

            in = 8'h0F;
            shift_mode = 1;
            @(posedge clk);
            #1;

            shift_mode = 0;
            shift_dir = 1;
            repeat(4) @(posedge clk);
            #1;
            #1;

            check_outputs(8'hF0);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Shift out all bits (Down)");
            reset_dut();
            in = 8'h01;
            shift_mode = 1;
            @(posedge clk);
            #1;
            shift_mode = 0;
            shift_dir = 0;
            repeat(2) @(posedge clk);
            #1;
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
        input [7:0] expected_out;
        begin
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
        $dumpvars(0,clk, in, reset, shift_dir, shift_mode, out);
    end

endmodule
