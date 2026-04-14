`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] in;
    reg mode;
    reg reset;
    wire [7:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .in(in),
        .mode(mode),
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
        reset = 1;
        in = 0;
        mode = 0;
        @(posedge clk);
        #1 reset = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        reset_dut();
        mode = 1;
        @(posedge clk);
        in = 8'hAA; @(posedge clk);
        in = 8'hAA; @(posedge clk);
        in = 8'hAA; @(posedge clk);
        in = 8'hBB; @(posedge clk);
        #2;
        #1;

        check_outputs(8'h03);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        reset_dut();
        mode = 0;
        in = 8'h55; @(posedge clk);
        in = 8'h04; @(posedge clk);
        repeat(3) @(posedge clk);
        #2;
        #1;

        check_outputs(8'h55);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        reset_dut();
        mode = 1;
        in = 8'h11; @(posedge clk);
        in = 8'h22; @(posedge clk);
        #2;
        #1;

        check_outputs(8'h01);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        reset_dut();
        mode = 0;
        in = 8'hCC; @(posedge clk);
        in = 8'h01; @(posedge clk);
        in = 8'hDD; @(posedge clk);
        in = 8'h01; @(posedge clk);
        #2;
        #1;

        check_outputs(8'hDD);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        reset_dut();
        mode = 1;
        in = 8'hFF;
        repeat(5) @(posedge clk);
        in = 8'h00; @(posedge clk);
        #2;
        #1;

        check_outputs(8'h05);
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
        $dumpvars(0,clk, in, mode, reset, out);
    end

endmodule
