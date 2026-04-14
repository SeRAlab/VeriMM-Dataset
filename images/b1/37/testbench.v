`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    reg sreset;
    wire carry;
    wire [1:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .enable(enable),
        .sreset(sreset),
        .carry(carry),
        .count(count)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            sreset = 1;
            enable = 0;
            @(posedge clk);
            #1;
            sreset = 0;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Basic Counting to 3");
            reset_dut();
            enable = 1;

            repeat(3) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 2'b11);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Enable Low Behavior");
            reset_dut();
            enable = 1;
            @(posedge clk);
            enable = 0;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 2'b01);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Wrap-around 3 to 0");
            reset_dut();
            enable = 1;
            repeat(4) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 2'b00);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Synchronous Reset Mid-count");
            reset_dut();
            enable = 1;
            repeat(2) @(posedge clk);
            sreset = 1;
            @(posedge clk);
            sreset = 0;
            #1;
            #1;

            check_outputs(1'b0, 2'b00);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Carry Bit with Enable");
            reset_dut();
            enable = 1;
            repeat(3) @(posedge clk);
            enable = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, 2'b11);
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
        input expected_carry;
        input [1:0] expected_count;
        begin
            if (expected_carry === (expected_carry ^ carry ^ expected_carry) &&
                expected_count === (expected_count ^ count ^ expected_count)) begin
                $display("PASS");
                $display("  Outputs: carry=%b, count=%h",
                         carry, count);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: carry=%b, count=%h",
                         expected_carry, expected_count);
                $display("  Got:      carry=%b, count=%h",
                         carry, count);
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
        $dumpvars(0,clk, enable, sreset, carry, count);
    end

endmodule
