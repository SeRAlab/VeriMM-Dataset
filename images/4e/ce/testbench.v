`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] x;
    reg [15:0] y;
    wire [31:0] product;

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
        $display("Test Case %0d: Positive * Positive (5 * 4)", test_num);
        x = 16'sd5;
        y = 16'sd4;
        #1;

        check_outputs(32'sd20);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Positive * Negative (10 * -2)", test_num);
        x = 16'sd10;
        y = -16'sd2;
        #1;

        check_outputs(-32'sd20);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Negative * Positive (-15 * 3)", test_num);
        x = -16'sd15;
        y = 16'sd3;
        #1;

        check_outputs(-32'sd45);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Negative * Negative (-10 * -10)", test_num);
        x = -16'sd10;
        y = -16'sd10;
        #1;

        check_outputs(32'sd100);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Multiplication by Zero (0 * -123)", test_num);
        x = 16'sd0;
        y = -16'sd123;
        #1;

        check_outputs(32'sd0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Max Positive * 1 (32767 * 1)", test_num);
        x = 16'h7FFF;
        y = 16'sd1;
        #1;

        check_outputs(32'h00007FFF);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Min Negative * 1 (-32768 * 1)", test_num);
        x = 16'h8000;
        y = 16'sd1;
        #1;

        check_outputs(32'hFFFF8000);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Max Positive * Max Positive (32767 * 32767)", test_num);
        x = 16'h7FFF;
        y = 16'h7FFF;
        #1;

        check_outputs(32'sd32767 * 32767);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Min Negative * Min Negative (-32768 * -32768)", test_num);
        x = 16'h8000;
        y = 16'h8000;

        #1;


        check_outputs(32'h40000000);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Min Negative * -1 (-32768 * -1)", test_num);
        x = 16'h8000;
        y = -16'sd1;
        #1;

        check_outputs(32'sd32768);
    end
        endtask

    task testcase011;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Large Negative * Large Positive (-1000 * 2000)", test_num);
        x = -16'sd1000;
        y = 16'sd2000;
        #1;

        check_outputs(-32'sd2000000);
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
        input [31:0] expected_product;
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
