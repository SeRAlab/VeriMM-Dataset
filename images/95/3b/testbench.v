`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clear;
    reg clk;
    reg [7:0] in;
    reg load;
    reg reset;
    wire [15:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clear(clear),
        .clk(clk),
        .in(in),
        .load(load),
        .reset(reset),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(posedge clk);
            reset = 1;
            load = 0;
            clear = 0;
            in = 0;
            @(posedge clk);
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Reset", test_num);
            reset_dut();
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Single Accumulation", test_num);
            reset_dut();
            @(posedge clk);
            in = 8'hA5;
            load = 1;
            @(posedge clk);
            load = 0;
            #1;

            check_outputs(16'h00A5);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Multiple Accumulations", test_num);
            reset_dut();
            @(posedge clk);
            in = 8'h10; load = 1;
            @(posedge clk);
            in = 8'h20; load = 1;
            @(posedge clk);
            in = 8'h05; load = 1;
            @(posedge clk);
            load = 0;
            #1;

            check_outputs(16'h0035);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Clear Signal", test_num);
            reset_dut();
            @(posedge clk);
            in = 8'hFF; load = 1;
            @(posedge clk);
            clear = 1; load = 0;
            @(posedge clk);
            clear = 0;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Load Off State Retention", test_num);
            reset_dut();
            @(posedge clk);
            in = 8'h55; load = 1;
            @(posedge clk);
            in = 8'hAA; load = 0;
            @(posedge clk);
            #1;

            check_outputs(16'h0055);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Clear Priority over Load", test_num);
            reset_dut();
            @(posedge clk);
            in = 8'h11; load = 1;
            @(posedge clk);
            in = 8'h22; load = 1; clear = 1;
            @(posedge clk);
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: 16-bit Accumulation Range", test_num);
            reset_dut();
            @(posedge clk);
            in = 8'hFF; load = 1;
            repeat(10) @(posedge clk);
            load = 0;
            #1;

            check_outputs(16'h0AF5);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset Priority", test_num);
            reset_dut();
            @(posedge clk);
            in = 8'hFF; load = 1;
            @(posedge clk);
            reset = 1; in = 8'hAA; load = 1; clear = 0;
            @(posedge clk);
            reset = 0;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: 16-bit Overflow", test_num);
            reset_dut();

            @(posedge clk);
            in = 8'hFF; load = 1;
            repeat(256) @(posedge clk);
            @(posedge clk);
            in = 8'h01; load = 1;
            @(posedge clk);
            load = 0;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Max Input Accumulation", test_num);
            reset_dut();
            @(posedge clk);
            in = 8'hFF; load = 1;
            @(posedge clk);
            in = 8'hFF; load = 1;
            @(posedge clk);
            load = 0;
            #1;

            check_outputs(16'h01FE);
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
        input [15:0] expected_out;
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
        $dumpvars(0,clear, clk, in, load, reset, out);
    end

endmodule
