`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] money_in;
    reg [1:0] product_sel;
    wire [3:0] change;
    wire dispense;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .money_in(money_in),
        .product_sel(product_sel),
        .change(change),
        .dispense(dispense)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Product 0 (Cost 2), Money 5", test_num);
            product_sel = 2'b00;
            money_in = 4'd5;
            #1;

            check_outputs(4'd3, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Product 0 (Cost 2), Money 1", test_num);
            product_sel = 2'b00;
            money_in = 4'd1;
            #1;

            check_outputs(4'd0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Product 1 (Cost 4), Money 4", test_num);
            product_sel = 2'b01;
            money_in = 4'd4;
            #1;

            check_outputs(4'd0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Product 1 (Cost 4), Money 10", test_num);
            product_sel = 2'b01;
            money_in = 4'd10;
            #1;

            check_outputs(4'd6, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Product 2 (Cost 6), Money 5", test_num);
            product_sel = 2'b10;
            money_in = 4'd5;
            #1;

            check_outputs(4'd0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Product 2 (Cost 6), Money 6", test_num);
            product_sel = 2'b10;
            money_in = 4'd6;
            #1;

            check_outputs(4'd0, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Product 3 (Cost 8), Money 15", test_num);
            product_sel = 2'b11;
            money_in = 4'd15;
            #1;

            check_outputs(4'd7, 1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Product 3 (Cost 8), Money 2", test_num);
            product_sel = 2'b11;
            money_in = 4'd2;
            #1;

            check_outputs(4'd0, 1'b0);
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
        input [3:0] expected_change;
        input expected_dispense;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_change === (expected_change ^ change ^ expected_change) &&
                expected_dispense === (expected_dispense ^ dispense ^ expected_dispense)) begin
                $display("PASS");
                $display("  Outputs: change=%h, dispense=%b",
                         change, dispense);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: change=%h, dispense=%b",
                         expected_change, expected_dispense);
                $display("  Got:      change=%h, dispense=%b",
                         change, dispense);
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
