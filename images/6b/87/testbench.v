`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] a;
    reg [7:0] b;
    wire [7:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .result(result)
    );
    task testcase001;

    begin
        test_num = 1;
        a = 8'd10;
        b = 8'd5;
        $display("Test %0d: a=%d, b=%d (a > b, sum)", test_num, a, b);
        #1;

        check_outputs(8'd15);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        a = 8'd200;
        b = 8'd100;
        $display("Test %0d: a=%d, b=%d (a > b, sum with overflow)", test_num, a, b);
        #1;

        check_outputs(8'd44);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        a = 8'd50;
        b = 8'd100;
        $display("Test %0d: a=%d, b=%d (a < b, difference)", test_num, a, b);
        #1;

        check_outputs(8'd206);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        a = 8'd0;
        b = 8'd1;
        $display("Test %0d: a=%d, b=%d (a < b, difference underflow)", test_num, a, b);
        #1;

        check_outputs(8'd255);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        a = 8'hAA;
        b = 8'hAA;
        $display("Test %0d: a=%h, b=%h (a == b, bitwise AND)", test_num, a, b);
        #1;

        check_outputs(8'hAA);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        a = 8'd0;
        b = 8'd0;
        $display("Test %0d: a=%d, b=%d (a == b, zero)", test_num, a, b);
        #1;

        check_outputs(8'd0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        a = 8'd255;
        b = 8'd255;
        $display("Test %0d: a=%d, b=%d (a == b, all ones)", test_num, a, b);
        #1;

        check_outputs(8'd255);
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
        input [7:0] expected_result;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: result=%h",
                         result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: result=%h",
                         expected_result);
                $display("  Got:      result=%h",
                         result);
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
