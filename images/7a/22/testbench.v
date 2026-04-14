`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst_n;
    wire [12:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .rst_n(rst_n),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            #15;
            rst_n = 1;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase 001: Checking first captured random number (13 cycles)...");
            reset_dut();


            repeat(13) @(posedge clk);
            #2;



            first_val = out;
            if (out !== 13'hx && out !== 13'h0) begin
                $display("PASS: First capture = %h", out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: Invalid first capture = %h", out);
                fail_count = fail_count + 1;
            end
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase 002: Checking second captured random number (26 cycles total)...");
            reset_dut();


            repeat(26) @(posedge clk);
            #2;

            second_val = out;

            if (out !== first_val && out !== 13'h0) begin
                $display("PASS: Second capture changed to %h", out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: Output did not update correctly. Output: %h", out);
                fail_count = fail_count + 1;
            end
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase 003: Verifying reset consistency...");
            reset_dut();


            repeat(13) @(posedge clk);
            #2;


            if (out === first_val) begin
                $display("PASS: Reset restored the sequence. Output: %h", out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: Reset consistency check failed. Expected: %h, Got: %h", first_val, out);
                fail_count = fail_count + 1;
            end
        end
        endtask

    task testcase004;

        reg [12:0] temp_val;
        begin
            test_num = 4;
            $display("Testcase 004: Verifying output stability between capture cycles...");
            reset_dut();


            repeat(13) @(posedge clk);
            #2;
            temp_val = out;


            repeat(5) @(posedge clk);
            #2;

            if (out === temp_val) begin
                $display("PASS: Output remains stable between counter resets.");
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: Output changed mid-cycle. Got: %h, Expected: %h", out, temp_val);
                fail_count = fail_count + 1;
            end
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
        input [12:0] expected_out;
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
        $dumpvars(0,clk, rst_n, out);
    end

endmodule
