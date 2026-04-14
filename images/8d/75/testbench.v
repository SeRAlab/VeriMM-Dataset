`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [1:0] coin;
    reg item;
    reg reset;
    wire [5:0] change;
    wire dispense;
    wire [5:0] price;
    wire [3:0] stock_candy;
    wire [3:0] stock_chips;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .coin(coin),
        .item(item),
        .reset(reset),
        .change(change),
        .dispense(dispense),
        .price(price),
        .stock_candy(stock_candy),
        .stock_chips(stock_chips)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            coin = 2'b00;
            item = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Candy Exact Change (5+10)", test_num);
            reset_dut();
            item = 0;
            @(posedge clk);
            coin = 2'b01;
            @(posedge clk);
            coin = 2'b10;
            @(posedge clk);
            coin = 2'b00;
            repeat(2) @(posedge clk);

            #1;


            check_outputs(6'd0, 1'b1, 6'd15, 4'd9, 4'd10);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Chips Exact Change (25)", test_num);
            reset_dut();
            item = 1;
            @(posedge clk);
            coin = 2'b11;
            @(posedge clk);
            coin = 2'b00;
            repeat(2) @(posedge clk);

            #1;


            check_outputs(6'd0, 1'b1, 6'd25, 4'd10, 4'd9);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Candy Overpayment (25 for 15)", test_num);
            reset_dut();
            item = 0;
            @(posedge clk);
            coin = 2'b11;
            @(posedge clk);
            coin = 2'b00;
            repeat(2) @(posedge clk);

            #1;


            check_outputs(6'd10, 1'b1, 6'd15, 4'd9, 4'd10);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Chips Overpayment (10+10+10 for 25)", test_num);
            reset_dut();
            item = 1;
            @(posedge clk);
            coin = 2'b10;
            @(posedge clk);
            coin = 2'b10;
            @(posedge clk);
            coin = 2'b10;
            @(posedge clk);
            coin = 2'b00;
            repeat(2) @(posedge clk);

            #1;


            check_outputs(6'd5, 1'b1, 6'd25, 4'd10, 4'd9);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Insufficient Funds (10 for 15)", test_num);
            reset_dut();
            item = 0;
            @(posedge clk);
            coin = 2'b10;
            @(posedge clk);
            coin = 2'b00;
            repeat(2) @(posedge clk);

            #1;


            check_outputs(6'd0, 1'b0, 6'd15, 4'd10, 4'd10);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Chips with five 5c coins", test_num);
            reset_dut();
            item = 1;
            @(posedge clk);
            coin = 2'b01;
            @(posedge clk); coin = 2'b01;
            @(posedge clk); coin = 2'b01;
            @(posedge clk); coin = 2'b01;
            @(posedge clk); coin = 2'b01;
            @(posedge clk);
            coin = 2'b00;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(6'd0, 1'b1, 6'd25, 4'd10, 4'd9);
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
        input [5:0] expected_change;
        input expected_dispense;
        input [5:0] expected_price;
        input [3:0] expected_stock_candy;
        input [3:0] expected_stock_chips;
        begin
            if (expected_change === (expected_change ^ change ^ expected_change) &&
                expected_dispense === (expected_dispense ^ dispense ^ expected_dispense) &&
                expected_price === (expected_price ^ price ^ expected_price) &&
                expected_stock_candy === (expected_stock_candy ^ stock_candy ^ expected_stock_candy) &&
                expected_stock_chips === (expected_stock_chips ^ stock_chips ^ expected_stock_chips)) begin
                $display("PASS");
                $display("  Outputs: change=%h, dispense=%b, price=%h, stock_candy=%h, stock_chips=%h",
                         change, dispense, price, stock_candy, stock_chips);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: change=%h, dispense=%b, price=%h, stock_candy=%h, stock_chips=%h",
                         expected_change, expected_dispense, expected_price, expected_stock_candy, expected_stock_chips);
                $display("  Got:      change=%h, dispense=%b, price=%h, stock_candy=%h, stock_chips=%h",
                         change, dispense, price, stock_candy, stock_chips);
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
        $dumpvars(0,clk, coin, item, reset, change, dispense, price, stock_candy, stock_chips);
    end

endmodule
