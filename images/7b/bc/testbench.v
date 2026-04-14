`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg coin_10;
    reg coin_25;
    reg coin_5;
    reg reset;
    wire product_dispensed;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .coin_10(coin_10),
        .coin_25(coin_25),
        .coin_5(coin_5),
        .reset(reset),
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
            coin_5 = 0;
            coin_10 = 0;
            coin_25 = 0;
            repeat(2) @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task insert_5;

        begin
            @(posedge clk); #1; coin_5 = 1;
            @(posedge clk); #1; coin_5 = 0;
        end
        endtask

    task insert_10;

        begin
            @(posedge clk); #1; coin_10 = 1;
            @(posedge clk); #1; coin_10 = 0;
        end
        endtask

    task insert_25;

        begin
            @(posedge clk); #1; coin_25 = 1;
            @(posedge clk); #1; coin_25 = 0;
        end
        endtask

    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Insert 25 + 25 = 50 cents (Exact)", test_num);
            reset_dut();
            insert_25();
            insert_25();
            @(posedge clk); #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Insert 10*5 = 50 cents (Exact)", test_num);
            reset_dut();
            insert_10();
            insert_10();
            insert_10();
            insert_10();
            insert_10();
            @(posedge clk); #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Insert 25*3 = 75 cents (Exceed)", test_num);
            reset_dut();
            insert_25();
            insert_25();
            insert_25();
            @(posedge clk); #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Insert 25 + 10 + 10 = 45 cents (Under)", test_num);
            reset_dut();
            insert_25();
            insert_10();
            insert_10();
            @(posedge clk); #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Insert 25 + 10 + 10 + 5 = 50 cents (Mix)", test_num);
            reset_dut();
            insert_25();
            insert_10();
            insert_10();
            insert_5();
            @(posedge clk); #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset during transaction", test_num);
            reset_dut();
            insert_25();
            insert_10();

            reset = 1; #10; reset = 0;
            @(posedge clk); #1;
            insert_10();
            @(posedge clk); #1;
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
        input expected_product_dispensed;
        begin
            if (expected_product_dispensed === (expected_product_dispensed ^ product_dispensed ^ expected_product_dispensed)) begin
                $display("PASS");
                $display("  Outputs: product_dispensed=%b",
                         product_dispensed);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: product_dispensed=%b",
                         expected_product_dispensed);
                $display("  Got:      product_dispensed=%b",
                         product_dispensed);
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
        $dumpvars(0,clk, coin_10, coin_25, coin_5, reset, product_dispensed);
    end

endmodule
