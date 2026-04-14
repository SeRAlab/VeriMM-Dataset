`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] binary_in;
    wire [3:0] hundreds;
    wire [3:0] ones;
    wire [3:0] tens;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .binary_in(binary_in),
        .hundreds(hundreds),
        .ones(ones),
        .tens(tens)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test %0d: Binary Input 0", test_num);
        binary_in = 8'd0;
        #1;

        check_outputs(4'd0, 4'd0, 4'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %0d: Binary Input 123", test_num);
        binary_in = 8'd123;
        #1;

        check_outputs(4'd1, 4'd3, 4'd2);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %0d: Binary Input 255 (Max)", test_num);
        binary_in = 8'd255;
        #1;

        check_outputs(4'd2, 4'd5, 4'd5);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %0d: Binary Input 7 (Single Digit)", test_num);
        binary_in = 8'd7;
        #1;

        check_outputs(4'd0, 4'd7, 4'd0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %0d: Binary Input 42 (Two Digits)", test_num);
        binary_in = 8'd42;
        #1;

        check_outputs(4'd0, 4'd2, 4'd4);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test %0d: Binary Input 100", test_num);
        binary_in = 8'd100;
        #1;

        check_outputs(4'd1, 4'd0, 4'd0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test %0d: Binary Input 99", test_num);
        binary_in = 8'd99;
        #1;

        check_outputs(4'd0, 4'd9, 4'd9);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test %0d: Binary Input 201", test_num);
        binary_in = 8'd201;
        #1;

        check_outputs(4'd2, 4'd1, 4'd0);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test %0d: Binary Input 150", test_num);
        binary_in = 8'd150;
        #1;

        check_outputs(4'd1, 4'd0, 4'd5);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Test %0d: Binary Input 10", test_num);
        binary_in = 8'd10;
        #1;

        check_outputs(4'd0, 4'd0, 4'd1);
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
        input [3:0] expected_hundreds;
        input [3:0] expected_ones;
        input [3:0] expected_tens;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_hundreds === (expected_hundreds ^ hundreds ^ expected_hundreds) &&
                expected_ones === (expected_ones ^ ones ^ expected_ones) &&
                expected_tens === (expected_tens ^ tens ^ expected_tens)) begin
                $display("PASS");
                $display("  Outputs: hundreds=%h, ones=%h, tens=%h",
                         hundreds, ones, tens);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: hundreds=%h, ones=%h, tens=%h",
                         expected_hundreds, expected_ones, expected_tens);
                $display("  Got:      hundreds=%h, ones=%h, tens=%h",
                         hundreds, ones, tens);
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
