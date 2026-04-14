`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [2:0] coin;
    reg [1:0] product;
    reg reset;
    wire [2:0] change;
    wire dispense;
    wire [3:0] display;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .coin(coin),
        .product(product),
        .reset(reset),
        .change(change),
        .dispense(dispense),
        .display(display)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            coin = 0;
            product = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Test Case 001: Exact payment for Product 1");
            reset_dut();
            product = 2'b01;
            coin = 3'b010;
            @(posedge clk);
            #1;
            coin = 3'b000;
            @(posedge clk);
            #1;

            #1;


            check_outputs(3'b000, 1'b1, 4'h0);
        end
        endtask

    task testcase002;

        begin
            $display("Test Case 002: Overpayment for Product 0");
            reset_dut();
            product = 2'b00;
            coin = 3'b010;
            @(posedge clk);
            #1;
            coin = 3'b000;
            @(posedge clk);
            #1;

            #1;


            check_outputs(3'b001, 1'b1, 4'h1);
        end
        endtask

    task testcase003;

        begin
            $display("Test Case 003: Multiple coins for Product 2");
            reset_dut();
            product = 2'b10;
            coin = 3'b010;
            @(posedge clk);
            #1;
            coin = 3'b001;
            @(posedge clk);
            #1;
            coin = 3'b000;
            @(posedge clk);
            #1;

            #1;


            check_outputs(3'b000, 1'b1, 4'h0);
        end
        endtask

    task testcase004;

        begin
            $display("Test Case 004: Insufficient funds for Product 3");
            reset_dut();
            product = 2'b11;
            coin = 3'b010;
            @(posedge clk);
            #1;
            coin = 3'b000;
            @(posedge clk);
            #1;

            #1;


            check_outputs(3'b000, 1'b0, 4'h2);
        end
        endtask

    task testcase005;

        begin
            $display("Test Case 005: Large overpayment");
            reset_dut();
            product = 2'b00;
            coin = 3'b100;
            @(posedge clk);
            #1;
            coin = 3'b000;
            @(posedge clk);
            #1;

            #1;


            check_outputs(3'b011, 1'b1, 4'h3);
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
        input [2:0] expected_change;
        input expected_dispense;
        input [3:0] expected_display;
        begin
            if (expected_change === (expected_change ^ change ^ expected_change) &&
                expected_dispense === (expected_dispense ^ dispense ^ expected_dispense) &&
                expected_display === (expected_display ^ display ^ expected_display)) begin
                $display("PASS");
                $display("  Outputs: change=%h, dispense=%b, display=%h",
                         change, dispense, display);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: change=%h, dispense=%b, display=%h",
                         expected_change, expected_dispense, expected_display);
                $display("  Got:      change=%h, dispense=%b, display=%h",
                         change, dispense, display);
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
        $dumpvars(0,clk, coin, product, reset, change, dispense, display);
    end

endmodule
