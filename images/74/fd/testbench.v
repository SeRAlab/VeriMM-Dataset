`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [1:0] coin;
    reg dispense;
    reg reset;
    wire [3:0] display_message;
    wire [3:0] excess_money;
    wire [3:0] product_count;
    wire product_dispensed;

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
        .display_message(display_message),
        .excess_money(excess_money),
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
            coin = 2'b00;
            dispense = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Power-on Reset State", test_num);
            reset_dut();


            #1;



            check_outputs(4'h0, 4'h0, 4'hA, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Exact Amount Purchase", test_num);
            reset_dut();


            coin = 2'b01;
            @(posedge clk); #1;
            coin = 2'b00;


            @(posedge clk); #1;
            coin = 2'b01;
            @(posedge clk); #1;
            coin = 2'b00;


            dispense = 1;
            @(posedge clk); #1;
            dispense = 0;


            #1;



            check_outputs(4'h0, 4'h0, 4'h9, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Overpayment and Change", test_num);
            reset_dut();


            coin = 2'b10;
            @(posedge clk); #1;
            coin = 2'b00;


            @(posedge clk); #1;
            coin = 2'b01;
            @(posedge clk); #1;
            coin = 2'b00;


            dispense = 1;
            @(posedge clk); #1;
            dispense = 0;


            #1;



            check_outputs(4'h0, 4'h1, 4'h9, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Insufficient Funds", test_num);
            reset_dut();


            coin = 2'b01;
            @(posedge clk); #1;
            coin = 2'b00;


            dispense = 1;
            @(posedge clk); #1;
            dispense = 0;


            #1;



            check_outputs(4'h0, 4'h0, 4'hA, 1'b0);
        end
        endtask

    task testcase005;

        integer i;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Sold Out Condition", test_num);
            reset_dut();


            for (i = 0; i < 10; i = i + 1) begin
                coin = 2'b10;
                @(posedge clk); #1;
                coin = 2'b00;
                dispense = 1;
                @(posedge clk); #1;
                dispense = 0;
                @(posedge clk); #1;
            end


            coin = 2'b10;
            @(posedge clk); #1;
            coin = 2'b00;
            dispense = 1;
            @(posedge clk); #1;
            dispense = 0;



            #1;




            check_outputs(4'hE, 4'h0, 4'h0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Multiple Accumulation", test_num);
            reset_dut();


            coin = 2'b01; @(posedge clk); #1;
            coin = 2'b01; @(posedge clk); #1;
            coin = 2'b00;

            dispense = 1;
            @(posedge clk); #1;
            dispense = 0;

            #1;


            check_outputs(4'h0, 4'h0, 4'h9, 1'b1);
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
        input [3:0] expected_display_message;
        input [3:0] expected_excess_money;
        input [3:0] expected_product_count;
        input expected_product_dispensed;
        begin
            if (expected_display_message === (expected_display_message ^ display_message ^ expected_display_message) &&
                expected_excess_money === (expected_excess_money ^ excess_money ^ expected_excess_money) &&
                expected_product_count === (expected_product_count ^ product_count ^ expected_product_count) &&
                expected_product_dispensed === (expected_product_dispensed ^ product_dispensed ^ expected_product_dispensed)) begin
                $display("PASS");
                $display("  Outputs: display_message=%h, excess_money=%h, product_count=%h, product_dispensed=%b",
                         display_message, excess_money, product_count, product_dispensed);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: display_message=%h, excess_money=%h, product_count=%h, product_dispensed=%b",
                         expected_display_message, expected_excess_money, expected_product_count, expected_product_dispensed);
                $display("  Got:      display_message=%h, excess_money=%h, product_count=%h, product_dispensed=%b",
                         display_message, excess_money, product_count, product_dispensed);
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
        $dumpvars(0,clk, coin, dispense, reset, display_message, excess_money, product_count, product_dispensed);
    end

endmodule
