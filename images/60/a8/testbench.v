`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg a;
    reg async_reset;
    reg b;
    reg clk;
    reg reset;
    wire out;
    wire [3:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .async_reset(async_reset),
        .b(b),
        .clk(clk),
        .reset(reset),
        .out(out),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            async_reset = 1;
            reset = 0;
            a = 0;
            b = 0;
            #12;
            async_reset = 0;
            @(posedge clk);
            #1;
            reset = 1;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            a = 1; b = 0;


            repeat(7) @(posedge clk);

            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 4'b0000);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            a = 1; b = 1;
            repeat(8) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 4'b0000);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            repeat(4) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 4'd4);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            repeat(5) @(posedge clk);
            async_reset = 1;
            #5;
            async_reset = 0;
            #1;
            #1;

            check_outputs(1'b0, 4'b0000);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            repeat(5) @(posedge clk);
            reset = 1;
            @(posedge clk);
            reset = 0;
            #1;
            #1;

            check_outputs(1'b0, 4'b0000);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            a = 1; b = 0;
            repeat(8) @(posedge clk);
            a = 0; b = 0;
            repeat(3) @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 4'd3);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            a = 0; b = 0;
            repeat(8) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 4'b0000);
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
        input expected_out;
        input [3:0] expected_q;
        begin
            if (expected_out === (expected_out ^ out ^ expected_out) &&
                expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: out=%b, q=%h",
                         out, q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%b, q=%h",
                         expected_out, expected_q);
                $display("  Got:      out=%b, q=%h",
                         out, q);
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
        $dumpvars(0,a, async_reset, b, clk, reset, out, q);
    end

endmodule
