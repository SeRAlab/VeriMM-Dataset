`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] button;
    reg [7:0] money;
    reg [7:0] price;
    wire [7:0] change;
    wire [1:0] num_dispensed;
    wire [1:0] product;
    wire [7:0] total_money;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .button(button),
        .money(money),
        .price(price),
        .change(change),
        .num_dispensed(num_dispensed),
        .product(product),
        .total_money(total_money)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Exact amount provided for Product 1", test_num);
            button = 2'b01;
            money = 8'd50;
            price = 8'd50;

            #1;


            check_outputs(8'd0, 2'd1, 2'b01, 8'd50);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Sufficient funds with change for Product 2", test_num);
            button = 2'b10;
            money = 8'd100;
            price = 8'd75;

            #1;


            check_outputs(8'd25, 2'd1, 2'b10, 8'd75);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Insufficient funds for Product 3", test_num);
            button = 2'b11;
            money = 8'd40;
            price = 8'd60;

            #1;


            check_outputs(8'd40, 2'd0, 2'b00, 8'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Small price, large amount inserted for Product 0", test_num);
            button = 2'b00;
            money = 8'd200;
            price = 8'd5;

            #1;


            check_outputs(8'd195, 2'd1, 2'b00, 8'd5);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Zero money inserted", test_num);
            button = 2'b01;
            money = 8'd0;
            price = 8'd20;

            #1;


            check_outputs(8'd0, 2'd0, 2'b00, 8'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Boundary condition - money = price - 1", test_num);
            button = 2'b11;
            money = 8'd99;
            price = 8'd100;

            #1;


            check_outputs(8'd99, 2'd0, 2'b00, 8'd0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Boundary condition - money = price + 1", test_num);
            button = 2'b10;
            money = 8'd101;
            price = 8'd100;

            #1;


            check_outputs(8'd1, 2'd1, 2'b10, 8'd100);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Maximum values", test_num);
            button = 2'b11;
            money = 8'hFF;
            price = 8'hFF;

            #1;


            check_outputs(8'h00, 2'd1, 2'b11, 8'hFF);
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
        testcase008();
        
        
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
        input [7:0] expected_change;
        input [1:0] expected_num_dispensed;
        input [1:0] expected_product;
        input [7:0] expected_total_money;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_change === (expected_change ^ change ^ expected_change) &&
                expected_num_dispensed === (expected_num_dispensed ^ num_dispensed ^ expected_num_dispensed) &&
                expected_product === (expected_product ^ product ^ expected_product) &&
                expected_total_money === (expected_total_money ^ total_money ^ expected_total_money)) begin
                $display("PASS");
                $display("  Outputs: change=%h, num_dispensed=%h, product=%h, total_money=%h",
                         change, num_dispensed, product, total_money);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: change=%h, num_dispensed=%h, product=%h, total_money=%h",
                         expected_change, expected_num_dispensed, expected_product, expected_total_money);
                $display("  Got:      change=%h, num_dispensed=%h, product=%h, total_money=%h",
                         change, num_dispensed, product, total_money);
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

endmodule
