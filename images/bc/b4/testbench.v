`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [1:0] coin_in;
    reg dispense;
    reg reset;
    wire [3:0] product_count;
    wire product_dispensed;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .coin_in(coin_in),
        .dispense(dispense),
        .reset(reset),
        .product_count(product_count),
        .product_dispensed(product_dispensed)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            coin_in = 2'b00;
            dispense = 0;
            repeat(2) @(posedge clk);
            #1 reset = 0;
            repeat(1) @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Running Testcase 001: Initial Reset State");
            reset_dut();

            #1;


            check_outputs(4'd10, 1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("Running Testcase 002: Single 20-unit coin transaction");
            reset_dut();
            coin_in = 2'b11;
            @(posedge clk);
            #1 coin_in = 2'b00;
            dispense = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(4'd9, 1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("Running Testcase 003: Multiple coins (10+10) transaction");
            reset_dut();
            coin_in = 2'b10;
            @(posedge clk);
            #1 coin_in = 2'b10;
            @(posedge clk);
            #1 coin_in = 2'b00;
            dispense = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(4'd9, 1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("Running Testcase 004: Insufficient funds (10+5)");
            reset_dut();
            coin_in = 2'b10;
            @(posedge clk);
            #1 coin_in = 2'b01;
            @(posedge clk);
            #1 coin_in = 2'b00;
            dispense = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(4'd10, 1'b0);
        end
        endtask

    task testcase005;

        begin
            $display("Running Testcase 005: Multiple consecutive transactions");
            reset_dut();


            coin_in = 2'b11;
            @(posedge clk);
            #1 dispense = 1; coin_in = 0;
            @(posedge clk);


            #1 dispense = 0;
            coin_in = 2'b11;
            @(posedge clk);
            #1 dispense = 1; coin_in = 0;
            @(posedge clk);

            #1 #1;
 check_outputs(4'd8, 1'b1);
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
        input [3:0] expected_product_count;
        input expected_product_dispensed;
        begin
            if (expected_product_count === (expected_product_count ^ product_count ^ expected_product_count) &&
                expected_product_dispensed === (expected_product_dispensed ^ product_dispensed ^ expected_product_dispensed)) begin
                $display("PASS");
                $display("  Outputs: product_count=%h, product_dispensed=%b",
                         product_count, product_dispensed);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: product_count=%h, product_dispensed=%b",
                         expected_product_count, expected_product_dispensed);
                $display("  Got:      product_count=%h, product_dispensed=%b",
                         product_count, product_dispensed);
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
        $dumpvars(0,clk, coin_in, dispense, reset, product_count, product_dispensed);
    end

endmodule
