`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] MULTIPLICAND;
    reg [3:0] MULTIPLIER;
    wire [7:0] PRODUCT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .MULTIPLICAND(MULTIPLICAND),
        .MULTIPLIER(MULTIPLIER),
        .PRODUCT(PRODUCT)
    );
    task testcase001;

        begin
            test_num = 1;
            MULTIPLICAND = 4'd10;
            MULTIPLIER = 4'd0;
            $display("Test %0d: 10 * 0", test_num);
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            MULTIPLICAND = 4'd0;
            MULTIPLIER = 4'd5;
            $display("Test %0d: 0 * 5", test_num);
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            MULTIPLICAND = 4'd7;
            MULTIPLIER = 4'd1;
            $display("Test %0d: 7 * 1", test_num);
            #1;

            check_outputs(8'd7);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            MULTIPLICAND = 4'd1;
            MULTIPLIER = 4'd13;
            $display("Test %0d: 1 * 13", test_num);
            #1;

            check_outputs(8'd13);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            MULTIPLICAND = 4'd15;
            MULTIPLIER = 4'd15;
            $display("Test %0d: 15 * 15 (Max Value)", test_num);
            #1;

            check_outputs(8'd225);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            MULTIPLICAND = 4'd2;
            MULTIPLIER = 4'd4;
            $display("Test %0d: 2 * 4 (Powers of 2)", test_num);
            #1;

            check_outputs(8'd8);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            MULTIPLICAND = 4'd10;
            MULTIPLIER = 4'd5;
            $display("Test %0d: 10 * 5 (Alternating bits)", test_num);
            #1;

            check_outputs(8'd50);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            MULTIPLICAND = 4'd13;
            MULTIPLIER = 4'd7;
            $display("Test %0d: 13 * 7", test_num);
            #1;

            check_outputs(8'd91);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            MULTIPLICAND = 4'd3;
            MULTIPLIER = 4'd9;
            $display("Test %0d: 3 * 9", test_num);
            #1;

            check_outputs(8'd27);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            MULTIPLICAND = 4'd12;
            MULTIPLIER = 4'd11;
            $display("Test %0d: 12 * 11", test_num);
            #1;

            check_outputs(8'd132);
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
        input [7:0] expected_PRODUCT;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_PRODUCT === (expected_PRODUCT ^ PRODUCT ^ expected_PRODUCT)) begin
                $display("PASS");
                $display("  Outputs: PRODUCT=%h",
                         PRODUCT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: PRODUCT=%h",
                         expected_PRODUCT);
                $display("  Got:      PRODUCT=%h",
                         PRODUCT);
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
