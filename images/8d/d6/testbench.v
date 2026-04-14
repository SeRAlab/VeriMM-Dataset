`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] x;
    reg [3:0] y;
    wire [7:0] product;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .x(x),
        .y(y),
        .product(product)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Zero product (0 x 0)", test_num);
            x = 4'd0;
            y = 4'd0;
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Maximum product (15 x 15)", test_num);
            x = 4'd15;
            y = 4'd15;
            #1;

            check_outputs(8'd225);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Multiplicative Identity (1 x 1)", test_num);
            x = 4'd1;
            y = 4'd1;
            #1;

            check_outputs(8'd1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Zero multiplication (15 x 0)", test_num);
            x = 4'd15;
            y = 4'd0;
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Zero multiplication (0 x 15)", test_num);
            x = 4'd0;
            y = 4'd15;
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Typical values (7 x 3)", test_num);
            x = 4'd7;
            y = 4'd3;
            #1;

            check_outputs(8'd21);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Powers of 2 (4 x 4)", test_num);
            x = 4'd4;
            y = 4'd4;
            #1;

            check_outputs(8'd16);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Large and small values (13 x 2)", test_num);
            x = 4'd13;
            y = 4'd2;
            #1;

            check_outputs(8'd26);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Square of 10 (10 x 10)", test_num);
            x = 4'd10;
            y = 4'd10;
            #1;

            check_outputs(8'd100);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Max input with unit (15 x 1)", test_num);
            x = 4'd15;
            y = 4'd1;
            #1;

            check_outputs(8'd15);
        end
        endtask

    task testcase011;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Prime factors (5 x 11)", test_num);
            x = 4'd5;
            y = 4'd11;
            #1;

            check_outputs(8'd55);
        end
        endtask

    task testcase012;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Values near 16 boundaries (14 x 9)", test_num);
            x = 4'd14;
            y = 4'd9;
            #1;

            check_outputs(8'd126);
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
        testcase009();
        testcase010();
        testcase011();
        testcase012();
        
        
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
        input [7:0] expected_product;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_product === (expected_product ^ product ^ expected_product)) begin
                $display("PASS");
                $display("  Outputs: product=%h",
                         product);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: product=%h",
                         expected_product);
                $display("  Got:      product=%h",
                         product);
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
