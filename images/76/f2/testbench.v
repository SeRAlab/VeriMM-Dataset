`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg button1;
    reg button2;
    reg button3;
    reg coin;
    wire change;
    wire product1;
    wire product2;
    wire product3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .button1(button1),
        .button2(button2),
        .button3(button3),
        .coin(coin),
        .change(change),
        .product1(product1),
        .product2(product2),
        .product3(product3)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %03d: Idle state", test_num);
        coin = 0; button1 = 0; button2 = 0; button3 = 0;
        #1;

        check_outputs(0, 0, 0, 0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %03d: Button 1 selection without coin", test_num);
        coin = 0; button1 = 1; button2 = 0; button3 = 0;
        #1;

        check_outputs(0, 1, 0, 0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %03d: Button 2 selection without coin", test_num);
        coin = 0; button1 = 0; button2 = 1; button3 = 0;
        #1;

        check_outputs(0, 0, 1, 0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %03d: Button 3 selection without coin", test_num);
        coin = 0; button1 = 0; button2 = 0; button3 = 1;
        #1;

        check_outputs(0, 0, 0, 1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %03d: Coin inserted, no selection", test_num);
        coin = 1; button1 = 0; button2 = 0; button3 = 0;
        #1;

        check_outputs(1, 0, 0, 0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %03d: Coin inserted and Button 1 selected", test_num);
        coin = 1; button1 = 1; button2 = 0; button3 = 0;
        #1;

        check_outputs(0, 0, 0, 0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %03d: Multiple buttons without coin", test_num);
        coin = 0; button1 = 1; button2 = 1; button3 = 0;
        #1;

        check_outputs(0, 1, 1, 0);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %03d: Coin inserted with multiple buttons", test_num);
        coin = 1; button1 = 1; button2 = 1; button3 = 1;
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
        input expected_change;
        input expected_product1;
        input expected_product2;
        input expected_product3;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_change === (expected_change ^ change ^ expected_change) &&
                expected_product1 === (expected_product1 ^ product1 ^ expected_product1) &&
                expected_product2 === (expected_product2 ^ product2 ^ expected_product2) &&
                expected_product3 === (expected_product3 ^ product3 ^ expected_product3)) begin
                $display("PASS");
                $display("  Outputs: change=%b, product1=%b, product2=%b, product3=%b",
                         change, product1, product2, product3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: change=%b, product1=%b, product2=%b, product3=%b",
                         expected_change, expected_product1, expected_product2, expected_product3);
                $display("  Got:      change=%b, product1=%b, product2=%b, product3=%b",
                         change, product1, product2, product3);
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
