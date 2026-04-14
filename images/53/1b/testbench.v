`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg coin_inserted;
    reg item_dispensed;
    reg [1:0] item_selected;
    reg reset;
    wire dispense_item;
    wire return_coin;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .coin_inserted(coin_inserted),
        .item_dispensed(item_dispensed),
        .item_selected(item_selected),
        .reset(reset),
        .dispense_item(dispense_item),
        .return_coin(return_coin)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            coin_inserted = 0;
            item_selected = 2'b00;
            item_dispensed = 0;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            @(negedge clk);
            coin_inserted = 1;
            item_selected = 2'b01;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1, 0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            @(negedge clk);
            coin_inserted = 1;
            item_selected = 2'b10;
            @(posedge clk);
            @(negedge clk);
            item_dispensed = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(0, 1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            @(negedge clk);
            coin_inserted = 1;
            item_selected = 2'b11;
            @(posedge clk);
            @(negedge clk);
            item_dispensed = 1;
            @(posedge clk);
            @(posedge clk);
            #2;
            #1;

            check_outputs(0, 0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            @(negedge clk);
            coin_inserted = 1;
            item_selected = 2'b00;
            @(posedge clk);
            #2;
            #1;

            check_outputs(0, 0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            @(negedge clk);
            coin_inserted = 0;
            item_selected = 2'b01;
            @(posedge clk);
            #2;
            #1;

            check_outputs(0, 0);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            @(negedge clk);
            coin_inserted = 1;
            item_selected = 2'b10;
            @(posedge clk);
            #1 reset = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(0, 0);
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
        input expected_dispense_item;
        input expected_return_coin;
        begin
            if (expected_dispense_item === (expected_dispense_item ^ dispense_item ^ expected_dispense_item) &&
                expected_return_coin === (expected_return_coin ^ return_coin ^ expected_return_coin)) begin
                $display("PASS");
                $display("  Outputs: dispense_item=%b, return_coin=%b",
                         dispense_item, return_coin);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dispense_item=%b, return_coin=%b",
                         expected_dispense_item, expected_return_coin);
                $display("  Got:      dispense_item=%b, return_coin=%b",
                         dispense_item, return_coin);
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
        $dumpvars(0,clk, coin_inserted, item_dispensed, item_selected, reset, dispense_item, return_coin);
    end

endmodule
