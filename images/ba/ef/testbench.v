`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] a;
    reg [3:0] b;
    reg [1:0] sel;
    wire [3:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .sel(sel),
        .result(result)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Addition - Simple (3 + 5)", test_num);
        a = 4'd3;
        b = 4'd5;
        sel = 2'b00;
        #1;

        check_outputs(4'd8);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Addition - Overflow (12 + 5)", test_num);
        a = 4'd12;
        b = 4'd5;
        sel = 2'b00;
        #1;

        check_outputs(4'd1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Subtraction - Simple (10 - 4)", test_num);
        a = 4'd10;
        b = 4'd4;
        sel = 2'b01;
        #1;

        check_outputs(4'd6);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Subtraction - Underflow (2 - 5)", test_num);
        a = 4'd2;
        b = 4'd5;
        sel = 2'b01;
        #1;

        check_outputs(4'd13);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Bitwise AND (1010 & 1100)", test_num);
        a = 4'b1010;
        b = 4'b1100;
        sel = 2'b10;
        #1;

        check_outputs(4'b1000);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Bitwise AND - Zero Result (1010 & 0101)", test_num);
        a = 4'b1010;
        b = 4'b0101;
        sel = 2'b10;
        #1;

        check_outputs(4'b0000);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Bitwise OR (1010 | 0101)", test_num);
        a = 4'b1010;
        b = 4'b0101;
        sel = 2'b11;
        #1;

        check_outputs(4'b1111);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Bitwise OR - No change (1111 | 0000)", test_num);
        a = 4'b1111;
        b = 4'b0000;
        sel = 2'b11;
        #1;

        check_outputs(4'b1111);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Maximum Values Addition (15 + 15)", test_num);
        a = 4'hF;
        b = 4'hF;
        sel = 2'b00;
        #1;

        check_outputs(4'hE);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Subtraction Identical Values (7 - 7)", test_num);
        a = 4'd7;
        b = 4'd7;
        sel = 2'b01;
        #1;

        check_outputs(4'd0);
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
        input [3:0] expected_result;
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
