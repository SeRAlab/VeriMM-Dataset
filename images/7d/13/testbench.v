`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg carry_in;
    reg clk;
    reg en;
    reg rst;
    wire carry_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .carry_in(carry_in),
        .clk(clk),
        .en(en),
        .rst(rst),
        .carry_out(carry_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            en = 0;
            carry_in = 0;
            @(negedge clk);
            rst = 0;
            @(negedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Reset Check");
            reset_dut();

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Enable=1, Carry_in=1");
            reset_dut();
            @(negedge clk);
            en = 1;
            carry_in = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Enable=1, Carry_in=0");
            reset_dut();
            @(negedge clk);
            en = 1;
            carry_in = 1;
            @(posedge clk);
            @(negedge clk);
            carry_in = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Enable=0 (Hold High)");
            reset_dut();

            @(negedge clk);
            en = 1;
            carry_in = 1;
            @(posedge clk);

            @(negedge clk);
            en = 0;
            carry_in = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Reset Priority");
            reset_dut();
            @(negedge clk);
            en = 1;
            carry_in = 1;
            rst = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
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
        input expected_carry_out;
        begin
            if (expected_carry_out === (expected_carry_out ^ carry_out ^ expected_carry_out)) begin
                $display("PASS");
                $display("  Outputs: carry_out=%b",
                         carry_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: carry_out=%b",
                         expected_carry_out);
                $display("  Got:      carry_out=%b",
                         carry_out);
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
        $dumpvars(0,carry_in, clk, en, rst, carry_out);
    end

endmodule
