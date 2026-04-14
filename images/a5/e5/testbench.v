`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] a;
    wire [4:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .y(y)
    );
    task testcase001;

    begin
        a = 5'b00000;
        $display("Test 001: Input all zeros");
        #1;

        check_outputs(calculate_expected(a));
    end
        endtask

    task testcase002;

    begin
        a = 5'b11111;
        $display("Test 002: Input all ones");
        #1;

        check_outputs(calculate_expected(a));
    end
        endtask

    task testcase003;

    begin
        a = 5'b10101;
        $display("Test 003: Alternating bits (10101)");
        #1;

        check_outputs(calculate_expected(a));
    end
        endtask

    task testcase004;

    begin
        a = 5'b01010;
        $display("Test 004: Alternating bits (01010)");
        #1;

        check_outputs(calculate_expected(a));
    end
        endtask

    task testcase005;

    begin
        a = 5'b10000;
        $display("Test 005: MSB only");
        #1;

        check_outputs(calculate_expected(a));
    end
        endtask

    task testcase006;

    begin
        a = 5'b00001;
        $display("Test 006: LSB only");
        #1;

        check_outputs(calculate_expected(a));
    end
        endtask

    task testcase007;

    begin
        a = 5'b00100;
        $display("Test 007: Middle bit only");
        #1;

        check_outputs(calculate_expected(a));
    end
        endtask

    task testcase008;

    begin
        a = 5'b11000;
        $display("Test 008: High nibble bits");
        #1;

        check_outputs(calculate_expected(a));
    end
        endtask

    task testcase009;

    begin
        a = 5'b00011;
        $display("Test 009: Low nibble bits");
        #1;

        check_outputs(calculate_expected(a));
    end
        endtask

    task testcase010;

    begin
        a = 5'b11100;
        $display("Test 010: Boundary transition");
        #1;

        check_outputs(calculate_expected(a));
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
        input [4:0] expected_y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_y === (expected_y ^ y ^ expected_y)) begin
                $display("PASS");
                $display("  Outputs: y=%h",
                         y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: y=%h",
                         expected_y);
                $display("  Got:      y=%h",
                         y);
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
