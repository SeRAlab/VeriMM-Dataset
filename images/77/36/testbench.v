`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg coin_inserted;
    reg item_dispensed;
    reg item_selected;
    reg reset;
    wire dispense_item;
    wire item_not_available;
    wire ready_to_dispense;
    wire return_change;

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
        .item_not_available(item_not_available),
        .ready_to_dispense(ready_to_dispense),
        .return_change(return_change)
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
            item_selected = 0;
            item_dispensed = 0;
            repeat(2) @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Normal Purchase - Dispensing Item", test_num);
            reset_dut();
            coin_inserted = 1;
            item_selected = 1;
            @(posedge clk);
            #2;

            #1;


            check_outputs(1, 0, 1, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Coin Only - Returning Change", test_num);
            reset_dut();
            coin_inserted = 1;
            item_selected = 0;
            @(posedge clk);
            #2;

            #1;


            check_outputs(0, 0, 0, 1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Item Selection Without Coin - Error State", test_num);
            reset_dut();
            coin_inserted = 0;
            item_selected = 1;
            @(posedge clk);
            #2;

            #1;


            check_outputs(0, 1, 0, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Complete Transaction Flow to IDLE", test_num);
            reset_dut();

            coin_inserted = 1;
            item_selected = 1;
            @(posedge clk);
            #1;
            coin_inserted = 0;
            item_selected = 0;

            item_dispensed = 1;
            @(posedge clk);
            #2;

            #1;


            check_outputs(0, 0, 0, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Stay in IDLE state", test_num);
            reset_dut();
            repeat(3) @(posedge clk);
            #2;

            #1;


            check_outputs(0, 0, 0, 0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Automatic return to IDLE from error state", test_num);
            reset_dut();
            item_selected = 1;
            @(posedge clk);
            #1;
            item_selected = 0;
            repeat(2) @(posedge clk);
            #2;

            #1;


            check_outputs(0, 0, 0, 0);
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
        input expected_item_not_available;
        input expected_ready_to_dispense;
        input expected_return_change;
        begin
            if (expected_dispense_item === (expected_dispense_item ^ dispense_item ^ expected_dispense_item) &&
                expected_item_not_available === (expected_item_not_available ^ item_not_available ^ expected_item_not_available) &&
                expected_ready_to_dispense === (expected_ready_to_dispense ^ ready_to_dispense ^ expected_ready_to_dispense) &&
                expected_return_change === (expected_return_change ^ return_change ^ expected_return_change)) begin
                $display("PASS");
                $display("  Outputs: dispense_item=%b, item_not_available=%b, ready_to_dispense=%b, return_change=%b",
                         dispense_item, item_not_available, ready_to_dispense, return_change);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dispense_item=%b, item_not_available=%b, ready_to_dispense=%b, return_change=%b",
                         expected_dispense_item, expected_item_not_available, expected_ready_to_dispense, expected_return_change);
                $display("  Got:      dispense_item=%b, item_not_available=%b, ready_to_dispense=%b, return_change=%b",
                         dispense_item, item_not_available, ready_to_dispense, return_change);
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
        $dumpvars(0,clk, coin_inserted, item_dispensed, item_selected, reset, dispense_item, item_not_available, ready_to_dispense, return_change);
    end

endmodule
