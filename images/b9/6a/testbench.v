`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [1:0] coin;
    reg [1:0] dispense;
    reg reset;
    wire [1:0] change;
    wire dispenser1;
    wire dispenser2;
    wire dispenser3;
    wire dispenser4;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .coin(coin),
        .dispense(dispense),
        .reset(reset),
        .change(change),
        .dispenser1(dispenser1),
        .dispenser2(dispenser2),
        .dispenser3(dispenser3),
        .dispenser4(dispenser4)
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
        dispense = 0;
        @(posedge clk);
        #1 reset = 0;
        @(posedge clk);
    end
        endtask
    task insert_coin;

        input [1:0] coin_val;
        begin
            coin = coin_val;
            @(posedge clk);
            #1;
        end
        endtask

    task select_product;

        input [1:0] prod_val;
        begin
            dispense = prod_val;
            @(posedge clk);
            #1;
        end
        endtask

    task testcase001;

    begin
        test_num = 1;
        $display("Test Case 001: 50c exact (2x25c), Product 1");
        reset_dut();
        insert_coin(2'b10);
        insert_coin(2'b10);
        select_product(2'b00);
        #1;

        check_outputs(2'b00, 1, 0, 0, 0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case 002: 100c ($1 coin), Product 2, 50c change");
        reset_dut();
        insert_coin(2'b11);
        select_product(2'b01);
        #1;

        check_outputs(2'b10, 0, 1, 0, 0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case 003: 75c (3x25c), Product 3, 25c change");
        reset_dut();
        insert_coin(2'b10);
        insert_coin(2'b10);
        insert_coin(2'b10);
        select_product(2'b10);
        #1;

        check_outputs(2'b01, 0, 0, 1, 0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case 004: 50c (5x10c), Product 4");
        reset_dut();
        insert_coin(2'b01);
        insert_coin(2'b01);
        insert_coin(2'b01);
        insert_coin(2'b01);
        insert_coin(2'b01);
        select_product(2'b11);
        #1;

        check_outputs(2'b00, 0, 0, 0, 1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case 005: Accumulate 25c -> Reset -> Accumulate 25c -> Should not dispense");
        reset_dut();
        insert_coin(2'b10);
        reset_dut();
        insert_coin(2'b10);
        select_product(2'b00);
        #1;

        check_outputs(2'b00, 0, 0, 0, 0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case 006: Insufficient funds (35c), Product 1");
        reset_dut();
        insert_coin(2'b10);
        insert_coin(2'b01);
        select_product(2'b00);
        #1;

        check_outputs(2'b00, 0, 0, 0, 0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case 007: 125c ($1 + 25c), Product 1, 75c change");
        reset_dut();
        insert_coin(2'b11);
        insert_coin(2'b10);
        select_product(2'b00);
        #1;

        check_outputs(2'b11, 1, 0, 0, 0);
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
        input [1:0] expected_change;
        input expected_dispenser1;
        input expected_dispenser2;
        input expected_dispenser3;
        input expected_dispenser4;
        begin
            if (expected_change === (expected_change ^ change ^ expected_change) &&
                expected_dispenser1 === (expected_dispenser1 ^ dispenser1 ^ expected_dispenser1) &&
                expected_dispenser2 === (expected_dispenser2 ^ dispenser2 ^ expected_dispenser2) &&
                expected_dispenser3 === (expected_dispenser3 ^ dispenser3 ^ expected_dispenser3) &&
                expected_dispenser4 === (expected_dispenser4 ^ dispenser4 ^ expected_dispenser4)) begin
                $display("PASS");
                $display("  Outputs: change=%h, dispenser1=%b, dispenser2=%b, dispenser3=%b, dispenser4=%b",
                         change, dispenser1, dispenser2, dispenser3, dispenser4);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: change=%h, dispenser1=%b, dispenser2=%b, dispenser3=%b, dispenser4=%b",
                         expected_change, expected_dispenser1, expected_dispenser2, expected_dispenser3, expected_dispenser4);
                $display("  Got:      change=%h, dispenser1=%b, dispenser2=%b, dispenser3=%b, dispenser4=%b",
                         change, dispenser1, dispenser2, dispenser3, dispenser4);
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
        $dumpvars(0,clk, coin, dispense, reset, change, dispenser1, dispenser2, dispenser3, dispenser4);
    end

endmodule
