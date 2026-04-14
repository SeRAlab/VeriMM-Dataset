`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [1:0] code;
    reg rst;
    wire [3:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .code(code),
        .rst(rst),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            code = 2'b00;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning Testcase 001: Reset State Check");
            reset_dut();

            #1;


            check_outputs(4'b0001);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning Testcase 002: Transition to State 1 (code 01)");
            reset_dut();
            code = 2'b01;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'b0010);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning Testcase 003: Transition to State 2 (code 10)");
            reset_dut();
            code = 2'b10;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'b0100);
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning Testcase 004: Transition to State 3 (code 11)");
            reset_dut();
            code = 2'b11;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'b1000);
        end
        endtask

    task testcase005;

        begin
            $display("\nRunning Testcase 005: Multi-step Sequential Transitions");
            reset_dut();
            code = 2'b01;
            @(posedge clk);
            #1;
            code = 2'b10;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'b0100);
        end
        endtask

    task testcase006;

        begin
            $display("\nRunning Testcase 006: Transition back to State 0");
            reset_dut();
            code = 2'b11;
            @(posedge clk);
            #1;
            code = 2'b00;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'b0001);
        end
        endtask

    task testcase007;

        begin
            $display("\nRunning Testcase 007: Mid-operation Reset Check");
            reset_dut();
            code = 2'b11;
            @(posedge clk);
            #1;
            rst = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'b0001);
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
        $dumpvars(0,clk, code, rst, out);
    end

endmodule
