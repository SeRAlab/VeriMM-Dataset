`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] a;
    reg [1:0] b;
    wire [1:0] f_and;
    wire [1:0] f_xor;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .f_and(f_and),
        .f_xor(f_xor)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case 001: a=00, b=00");
            a = 2'b00;
            b = 2'b00;
            #1;

            check_outputs(2'b00, 2'b00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case 002: a=11, b=11");
            a = 2'b11;
            b = 2'b11;
            #1;

            check_outputs(2'b11, 2'b00);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case 003: a=10, b=01");
            a = 2'b10;
            b = 2'b01;
            #1;

            check_outputs(2'b00, 2'b11);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case 004: a=11, b=01");
            a = 2'b11;
            b = 2'b01;
            #1;

            check_outputs(2'b01, 2'b10);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case 005: a=01, b=11");
            a = 2'b01;
            b = 2'b11;
            #1;

            check_outputs(2'b01, 2'b10);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case 006: a=10, b=11");
            a = 2'b10;
            b = 2'b11;
            #1;

            check_outputs(2'b10, 2'b01);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case 007: a=00, b=10");
            a = 2'b00;
            b = 2'b10;
            #1;

            check_outputs(2'b00, 2'b10);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case 008: a=01, b=00");
            a = 2'b01;
            b = 2'b00;
            #1;

            check_outputs(2'b00, 2'b01);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case 009: a=10, b=10");
            a = 2'b10;
            b = 2'b10;
            #1;

            check_outputs(2'b10, 2'b00);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case 010: a=01, b=01");
            a = 2'b01;
            b = 2'b01;
            #1;

            check_outputs(2'b01, 2'b00);
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
        input [1:0] expected_f_and;
        input [1:0] expected_f_xor;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_f_and === (expected_f_and ^ f_and ^ expected_f_and) &&
                expected_f_xor === (expected_f_xor ^ f_xor ^ expected_f_xor)) begin
                $display("PASS");
                $display("  Outputs: f_and=%h, f_xor=%h",
                         f_and, f_xor);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: f_and=%h, f_xor=%h",
                         expected_f_and, expected_f_xor);
                $display("  Got:      f_and=%h, f_xor=%h",
                         f_and, f_xor);
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
