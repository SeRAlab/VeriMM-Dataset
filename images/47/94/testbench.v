`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg clear;
    reg [1:0] mode;
    reg [7:0] num1;
    reg [7:0] num2;
    wire [15:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clear(clear),
        .mode(mode),
        .num1(num1),
        .num2(num2),
        .result(result)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Addition (Mode 0)", test_num);
        clear = 1; #10;
        clear = 0;
        num1 = 8'd25;
        num2 = 8'd35;
        mode = 2'b00;
        #1;

        check_outputs(16'd60);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Subtraction (Mode 1)", test_num);
        clear = 1; #10;
        clear = 0;
        num1 = 8'd100;
        num2 = 8'd40;
        mode = 2'b01;
        #1;

        check_outputs(16'd60);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Multiplication (Mode 2)", test_num);
        clear = 1; #10;
        clear = 0;
        num1 = 8'd12;
        num2 = 8'd12;
        mode = 2'b10;
        #1;

        check_outputs(16'd144);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Division (Mode 3)", test_num);
        clear = 1; #10;
        clear = 0;
        num1 = 8'd100;
        num2 = 8'd5;
        mode = 2'b11;
        #1;

        check_outputs(16'd20);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Clear Override Check", test_num);
        clear = 1;
        num1 = 8'd255;
        num2 = 8'd255;
        mode = 2'b10;
        #1;

        check_outputs(16'd0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Max Addition (255 + 255)", test_num);
        clear = 1; #10;
        clear = 0;
        num1 = 8'hFF;
        num2 = 8'hFF;
        mode = 2'b00;
        #1;

        check_outputs(16'd510);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Max Multiplication (255 * 255)", test_num);
        clear = 1; #10;
        clear = 0;
        num1 = 8'hFF;
        num2 = 8'hFF;
        mode = 2'b10;
        #1;

        check_outputs(16'd65025);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Division (Small/Large)", test_num);
        clear = 1; #10;
        clear = 0;
        num1 = 8'd5;
        num2 = 8'd10;
        mode = 2'b11;
        #1;

        check_outputs(16'd0);
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
        input [15:0] expected_result;
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
