`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg button;
    reg clk;
    reg coin;
    reg [1:0] drink_code;
    reg reset;
    wire [1:0] change;
    wire [1:0] dispensed_drink;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .button(button),
        .clk(clk),
        .coin(coin),
        .drink_code(drink_code),
        .reset(reset),
        .change(change),
        .dispensed_drink(dispensed_drink)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            button = 0;
            coin = 0;
            drink_code = 2'b00;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("testcase001: Checking Reset state...");
            reset_dut();

            #1;


            check_outputs(2'b00, 2'b00);
        end
        endtask

    task testcase002;

        begin
            $display("testcase002: Single coin, select drink 01, dispense drink...");
            reset_dut();

            coin = 1;
            @(posedge clk);
            coin = 0;
            @(posedge clk);

            drink_code = 2'b01;
            button = 1;
            @(posedge clk);
            button = 0;
            @(posedge clk);

            #1;


            check_outputs(2'b00, 2'b01);
        end
        endtask

    task testcase003;

        begin
            $display("testcase003: No coins, select drink 01, should not dispense...");
            reset_dut();
            drink_code = 2'b01;
            button = 1;
            @(posedge clk);
            button = 0;
            @(posedge clk);

            #1;


            check_outputs(2'b00, 2'b00);
        end
        endtask

    task testcase004;

        begin
            $display("testcase004: Multiple coins, select drink 01, expect change...");
            reset_dut();

            repeat(3) begin
                coin = 1;
                @(posedge clk);
                coin = 0;
                @(posedge clk);
            end

            drink_code = 2'b01;
            button = 1;
            @(posedge clk);
            button = 0;
            @(posedge clk);


            #1;



            check_outputs(2'b10, 2'b01);
        end
        endtask

    task testcase005;

        begin
            $display("testcase005: Two coins, select drink 10...");
            reset_dut();

            repeat(2) begin
                coin = 1;
                @(posedge clk);
            end
            coin = 0;
            @(posedge clk);

            drink_code = 2'b10;
            button = 1;
            @(posedge clk);
            button = 0;
            @(posedge clk);

            #1;


            check_outputs(2'b00, 2'b10);
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
        input [1:0] expected_change;
        input [1:0] expected_dispensed_drink;
        begin
            if (expected_change === (expected_change ^ change ^ expected_change) &&
                expected_dispensed_drink === (expected_dispensed_drink ^ dispensed_drink ^ expected_dispensed_drink)) begin
                $display("PASS");
                $display("  Outputs: change=%h, dispensed_drink=%h",
                         change, dispensed_drink);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: change=%h, dispensed_drink=%h",
                         expected_change, expected_dispensed_drink);
                $display("  Got:      change=%h, dispensed_drink=%h",
                         change, dispensed_drink);
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
        $dumpvars(0,button, clk, coin, drink_code, reset, change, dispensed_drink);
    end

endmodule
