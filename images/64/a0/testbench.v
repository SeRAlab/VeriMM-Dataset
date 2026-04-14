`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg btn_a;
    reg btn_b;
    reg btn_c;
    reg clk;
    reg coin_slot;
    wire item_x;
    wire item_y;
    wire item_z;
    wire out_of_stock;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .btn_a(btn_a),
        .btn_b(btn_b),
        .btn_c(btn_c),
        .clk(clk),
        .coin_slot(coin_slot),
        .item_x(item_x),
        .item_y(item_y),
        .item_z(item_z),
        .out_of_stock(out_of_stock)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            btn_a = 0;
            btn_b = 0;
            btn_c = 0;
            coin_slot = 0;
            repeat(5) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            insert_coins(3);
            btn_a = 1; @(posedge clk);
            btn_a = 0; @(posedge clk);
            $display("Test 001: Buy Item X (75 cents)");
            #1;

            check_outputs(1, 0, 0, 0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            insert_coins(3);
            btn_b = 1; @(posedge clk);
            btn_b = 0; @(posedge clk);
            $display("Test 002: Buy Item Y (75 cents)");
            #1;

            check_outputs(0, 1, 0, 0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            insert_coins(3);
            btn_c = 1; @(posedge clk);
            btn_c = 0; @(posedge clk);
            $display("Test 003: Buy Item Z (75 cents)");
            #1;

            check_outputs(0, 0, 1, 0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            insert_coins(2);
            btn_a = 1; @(posedge clk);
            btn_a = 0; @(posedge clk);
            $display("Test 004: Insufficient money for Item X (50 cents)");
            #1;

            check_outputs(0, 0, 0, 0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            btn_a = 1; @(posedge clk);
            btn_a = 0;
            insert_coins(3);
            $display("Test 005: Select then insert 75 cents");
            #1;

            check_outputs(1, 0, 0, 0);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            insert_coins(4);
            btn_b = 1; @(posedge clk);
            btn_b = 0; @(posedge clk);
            $display("Test 006: Buy Item Y with 100 cents (should dispense)");
            #1;

            check_outputs(0, 1, 0, 0);
        end
        endtask

    task testcase007;

        integer k;
        begin
            reset_dut();
            $display("Test 007: Attempt to deplete stock of all items");

            for(k = 0; k < 5; k = k + 1) begin
                insert_coins(3);
                btn_a = 1; @(posedge clk); btn_a = 0; @(posedge clk);
                insert_coins(3);
                btn_b = 1; @(posedge clk); btn_b = 0; @(posedge clk);
                insert_coins(3);
                btn_c = 1; @(posedge clk); btn_c = 0; @(posedge clk);
            end

            if (out_of_stock === 1) begin
                #1;

                check_outputs(item_x, item_y, item_z, 1);
            end else begin

                #1;


                check_outputs(item_x, item_y, item_z, 0);
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
        input expected_item_x;
        input expected_item_y;
        input expected_item_z;
        input expected_out_of_stock;
        begin
            if (expected_item_x === (expected_item_x ^ item_x ^ expected_item_x) &&
                expected_item_y === (expected_item_y ^ item_y ^ expected_item_y) &&
                expected_item_z === (expected_item_z ^ item_z ^ expected_item_z) &&
                expected_out_of_stock === (expected_out_of_stock ^ out_of_stock ^ expected_out_of_stock)) begin
                $display("PASS");
                $display("  Outputs: item_x=%b, item_y=%b, item_z=%b, out_of_stock=%b",
                         item_x, item_y, item_z, out_of_stock);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: item_x=%b, item_y=%b, item_z=%b, out_of_stock=%b",
                         expected_item_x, expected_item_y, expected_item_z, expected_out_of_stock);
                $display("  Got:      item_x=%b, item_y=%b, item_z=%b, out_of_stock=%b",
                         item_x, item_y, item_z, out_of_stock);
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
        $dumpvars(0,btn_a, btn_b, btn_c, clk, coin_slot, item_x, item_y, item_z, out_of_stock);
    end

endmodule
