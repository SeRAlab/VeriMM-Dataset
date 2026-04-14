`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] col;
    wire [7:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .col(col),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            col = 4'b0000;
            repeat(3) @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            col = 4'h1; @(posedge clk);
            col = 4'h2; @(posedge clk);
            #1;
            $display("Test Case 001: Basic shift 1 -> 2");
            #1;

            check_outputs(8'h12);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            col = 4'hA; @(posedge clk);
            col = 4'h5; @(posedge clk);
            #1;
            $display("Test Case 002: Alternating pattern A -> 5");
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            col = 4'hF; @(posedge clk);
            col = 4'h0; @(posedge clk);
            #1;
            $display("Test Case 003: Shift from All-Ones to Zero");
            #1;

            check_outputs(8'hF0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            col = 4'h3; @(posedge clk);
            col = 4'h3; @(posedge clk);
            #1;
            $display("Test Case 004: Repeated key state 3 -> 3");
            #1;

            check_outputs(8'h33);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            col = 4'h8; @(posedge clk);
            col = 4'h4; @(posedge clk);
            col = 4'h2; @(posedge clk);
            col = 4'h1; @(posedge clk);
            #1;
            $display("Test Case 005: Multi-cycle sequence 8-4-2-1 (checking last two)");
            #1;

            check_outputs(8'h21);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            reset_dut();
            col = 4'hF; @(posedge clk);
            col = 4'hF; @(posedge clk);
            #1;
            $display("Test Case 006: Max value 0xFF");
            #1;

            check_outputs(8'hFF);
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
        $dumpvars(0,clk, col, out);
    end

endmodule
