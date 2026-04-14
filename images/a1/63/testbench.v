`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg i_a;
    reg i_b;
    reg i_cin;
    wire o_cout;
    wire o_result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .i_a(i_a),
        .i_b(i_b),
        .i_cin(i_cin),
        .o_cout(o_cout),
        .o_result(o_result)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case 001: i_a=0, i_b=0, i_cin=0");
        i_a = 0; i_b = 0; i_cin = 0;
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case 002: i_a=0, i_b=0, i_cin=1");
        i_a = 0; i_b = 0; i_cin = 1;
        #1;

        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case 003: i_a=0, i_b=1, i_cin=0");
        i_a = 0; i_b = 1; i_cin = 0;
        #1;

        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case 004: i_a=0, i_b=1, i_cin=1");
        i_a = 0; i_b = 1; i_cin = 1;
        #1;

        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case 005: i_a=1, i_b=0, i_cin=0");
        i_a = 1; i_b = 0; i_cin = 0;
        #1;

        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case 006: i_a=1, i_b=0, i_cin=1");
        i_a = 1; i_b = 0; i_cin = 1;
        #1;

        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case 007: i_a=1, i_b=1, i_cin=0");
        i_a = 1; i_b = 1; i_cin = 0;
        #1;

        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test Case 008: i_a=1, i_b=1, i_cin=1");
        i_a = 1; i_b = 1; i_cin = 1;
        #1;

        check_outputs(1'b1, 1'b1);
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
        input expected_o_cout;
        input expected_o_result;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_o_cout === (expected_o_cout ^ o_cout ^ expected_o_cout) &&
                expected_o_result === (expected_o_result ^ o_result ^ expected_o_result)) begin
                $display("PASS");
                $display("  Outputs: o_cout=%b, o_result=%b",
                         o_cout, o_result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o_cout=%b, o_result=%b",
                         expected_o_cout, expected_o_result);
                $display("  Got:      o_cout=%b, o_result=%b",
                         o_cout, o_result);
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
