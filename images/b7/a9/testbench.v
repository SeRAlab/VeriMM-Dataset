`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] digit;
    reg [15:0] nonce;
    reg reset;
    wire [15:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .digit(digit),
        .nonce(nonce),
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

            reset = 0;
            nonce = 16'h0000;
            digit = 16'h0000;
            #10;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            nonce = 16'hA5A5;
            #5;
            #1;

            check_outputs(16'hA5A5);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            reset = 1;
            digit = 16'h1234;

            @(negedge clk);
            #1;
            #1;

            check_outputs(16'h1234);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            reset = 1;
            digit = 16'h8888;
            @(negedge clk);
            #1;
            digit = 16'h9999;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'h8888);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            reset = 1;

            digit = 16'hAAAA;
            @(negedge clk);

            digit = 16'hBBBB;
            @(negedge clk);

            digit = 16'hCCCC;
            @(negedge clk);
            #1;
            #1;

            check_outputs(16'hCCCC);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;

            reset = 1;
            digit = 16'hFFFF;
            @(negedge clk);
            #1;


            reset = 0;
            nonce = 16'h55AA;
            #5;
            #1;

            check_outputs(16'h55AA);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            reset = 0;
            nonce = 16'h7777;
            digit = 16'hEEEE;
            @(negedge clk);
            #1;

            #1;


            check_outputs(16'h7777);
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
        $dumpvars(0,clk, digit, nonce, reset, out);
    end

endmodule
