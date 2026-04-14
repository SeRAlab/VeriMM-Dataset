`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg coin;
    reg product;
    reg reset;
    wire dispense;
    wire enough_coins;
    wire out_of_stock;
    wire ready;

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
        .dispense(dispense),
        .enough_coins(enough_coins),
        .out_of_stock(out_of_stock),
        .ready(ready)
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
        #1 reset = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        reset_dut();

        product = 1;
        @(posedge clk);
        #1 product = 0;

        coin = 1;
        @(posedge clk);
        #1 coin = 0;

        #1;


        check_outputs(1'b1, 1'b1, 1'b0, 1'b0);
    end
        endtask

    task testcase002;

    begin
        reset_dut();

        product = 1;
        @(posedge clk);
        #1 product = 0;

        @(posedge clk);

        #1;


        check_outputs(1'b0, 1'b0, 1'b0, 1'b1);
    end
        endtask

    task testcase003;

    begin
        reset_dut();

        product = 1;
        @(posedge clk);
        #1 product = 0;

        coin = 1;
        @(posedge clk);
        #1 coin = 0;

        @(posedge clk);

        #1;


        check_outputs(1'b0, 1'b0, 1'b0, 1'b0);
    end
        endtask

    task testcase004;

    begin
        reset_dut();

        product = 1;
        @(posedge clk);
        #1 product = 0;

        reset = 1;
        @(posedge clk);
        #1 reset = 0;

        #1;


        check_outputs(1'b0, 1'b0, 1'b0, 1'b0);
    end
        endtask

    task testcase005;

    begin
        reset_dut();

        @(posedge clk);
        @(posedge clk);

        #1;


        check_outputs(1'b0, 1'b0, 1'b0, 1'b0);
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
        input expected_dispense;
        input expected_enough_coins;
        input expected_out_of_stock;
        input expected_ready;
        begin
            if (expected_dispense === (expected_dispense ^ dispense ^ expected_dispense) &&
                expected_enough_coins === (expected_enough_coins ^ enough_coins ^ expected_enough_coins) &&
                expected_out_of_stock === (expected_out_of_stock ^ out_of_stock ^ expected_out_of_stock) &&
                expected_ready === (expected_ready ^ ready ^ expected_ready)) begin
                $display("PASS");
                $display("  Outputs: dispense=%b, enough_coins=%b, out_of_stock=%b, ready=%b",
                         dispense, enough_coins, out_of_stock, ready);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dispense=%b, enough_coins=%b, out_of_stock=%b, ready=%b",
                         expected_dispense, expected_enough_coins, expected_out_of_stock, expected_ready);
                $display("  Got:      dispense=%b, enough_coins=%b, out_of_stock=%b, ready=%b",
                         dispense, enough_coins, out_of_stock, ready);
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
        $dumpvars(0,clk, coin, product, reset, dispense, enough_coins, out_of_stock, ready);
    end

endmodule
