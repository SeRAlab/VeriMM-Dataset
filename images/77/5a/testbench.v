`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] in;
    reg reset_n;
    wire [31:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .in(in),
        .reset_n(reset_n),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset_n = 0;
            in = 32'h0;
            @(posedge clk);
            #1;
            reset_n = 1;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Reset Verification");
            reset_dut();
            #1;

            check_outputs(32'h0000_0000);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Pattern 1-0-1 on Bit 0");
            reset_dut();
            in <= 32'h0000_0001; @(posedge clk);
            in <= 32'h0000_0000; @(posedge clk);
            in <= 32'h0000_0001; @(posedge clk);
            @(posedge clk);
            #1;

            check_outputs(32'h0000_0001);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Pattern 1-0-1 on Bit 31");
            reset_dut();
            in <= 32'h8000_0000; @(posedge clk);
            in <= 32'h0000_0000; @(posedge clk);
            in <= 32'h8000_0000; @(posedge clk);
            @(posedge clk);
            #1;

            check_outputs(32'h8000_0000);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Sticky Bit Verification");
            reset_dut();

            in <= 32'h0000_0020; @(posedge clk);
            in <= 32'h0000_0000; @(posedge clk);
            in <= 32'h0000_0020; @(posedge clk);
            @(posedge clk);

            in <= 32'h0000_0000; @(posedge clk);
            in <= 32'hFFFF_FFFF; @(posedge clk);
            #1;

            check_outputs(32'h0000_0020);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Multiple Bits Simultaneous Detection");
            reset_dut();
            in <= 32'hA000_000A; @(posedge clk);
            in <= 32'h0000_0000; @(posedge clk);
            in <= 32'hA000_000A; @(posedge clk);
            @(posedge clk);
            #1;

            check_outputs(32'hA000_000A);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Reset after successful capture");
            reset_dut();
            in <= 32'h1; @(posedge clk);
            in <= 32'h0; @(posedge clk);
            in <= 32'h1; @(posedge clk);
            @(posedge clk);

            if (out == 32'h1) begin
                reset_dut();
                #1;

                check_outputs(32'h0);
            end else begin
                $display("Subtest failed: Capture did not occur");
                fail_count = fail_count + 1;
            end
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: False Pattern 0-1-0");
            reset_dut();
            in <= 32'h0; @(posedge clk);
            in <= 32'h1; @(posedge clk);
            in <= 32'h0; @(posedge clk);
            @(posedge clk);
            #1;

            check_outputs(32'h0);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: Overlapping Pattern 1-0-1-0-1");
            reset_dut();
            in <= 32'h1; @(posedge clk);
            in <= 32'h0; @(posedge clk);
            in <= 32'h1; @(posedge clk);
            in <= 32'h0; @(posedge clk);
            in <= 32'h1; @(posedge clk);
            @(posedge clk);
            #1;

            check_outputs(32'h1);
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
        input [31:0] expected_out;
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
        $dumpvars(0,clk, in, reset_n, out);
    end

endmodule
