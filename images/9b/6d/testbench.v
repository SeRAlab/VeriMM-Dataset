`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] a;
    reg [31:0] b;
    reg [1:0] op;
    reg ready;
    wire [31:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .op(op),
        .ready(ready),
        .result(result)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Addition (10 + 20)", test_num);
        a = 32'sd10;
        b = 32'sd20;
        op = 2'b00;
        ready = 1'b1;
        #1;

        check_outputs(32'sd30);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Addition (-50 + 20)", test_num);
        a = -32'sd50;
        b = 32'sd20;
        op = 2'b00;
        ready = 1'b1;
        #1;

        check_outputs(-32'sd30);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Subtraction (100 - 40)", test_num);
        a = 32'sd100;
        b = 32'sd40;
        op = 2'b01;
        ready = 1'b1;
        #1;

        check_outputs(32'sd60);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Subtraction (10 - 50)", test_num);
        a = 32'sd10;
        b = 32'sd50;
        op = 2'b01;
        ready = 1'b1;
        #1;

        check_outputs(-32'sd40);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Multiplication (12 * 10)", test_num);
        a = 32'sd12;
        b = 32'sd10;
        op = 2'b10;
        ready = 1'b1;
        #1;

        check_outputs(32'sd120);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Multiplication (-5 * 4)", test_num);
        a = -32'sd5;
        b = 32'sd4;
        op = 2'b10;
        ready = 1'b1;
        #1;

        check_outputs(-32'sd20);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Multiplication (-6 * -7)", test_num);
        a = -32'sd6;
        b = -32'sd7;
        op = 2'b10;
        ready = 1'b1;
        #1;

        check_outputs(32'sd42);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Division (100 / 5)", test_num);
        a = 32'sd100;
        b = 32'sd5;
        op = 2'b11;
        ready = 1'b1;
        #1;

        check_outputs(32'sd20);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Division (-80 / 4)", test_num);
        a = -32'sd80;
        b = 32'sd4;
        op = 2'b11;
        ready = 1'b1;
        #1;

        check_outputs(-32'sd20);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Division with truncation (7 / 2)", test_num);
        a = 32'sd7;
        b = 32'sd2;
        op = 2'b11;
        ready = 1'b1;
        #1;

        check_outputs(32'sd3);
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
        input [31:0] expected_result;
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
