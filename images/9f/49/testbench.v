`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] a;
    reg [3:0] b;
    reg [1:0] c;
    wire [3:0] d;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .c(c),
        .d(d)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Subtraction (Positive result: 10 - 3)", test_num);
        a = 4'd10; b = 4'd3; c = 2'd0;
        #1;

        check_outputs(4'd7);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Subtraction (Zero result: 7 - 7)", test_num);
        a = 4'd7; b = 4'd7; c = 2'd0;
        #1;

        check_outputs(4'd0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Subtraction (Wrap-around: 2 - 5)", test_num);
        a = 4'd2; b = 4'd5; c = 2'd0;
        #1;

        check_outputs(4'd13);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Addition (Small numbers: 4 + 5)", test_num);
        a = 4'd4; b = 4'd5; c = 2'd1;
        #1;

        check_outputs(4'd9);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Addition (Max value: 7 + 8)", test_num);
        a = 4'd7; b = 4'd8; c = 2'd1;
        #1;

        check_outputs(4'd15);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Addition (Overflow: 12 + 6)", test_num);
        a = 4'd12; b = 4'd6; c = 2'd1;
        #1;

        check_outputs(4'd2);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Multiplication (Small numbers: 3 * 4)", test_num);
        a = 4'd3; b = 4'd4; c = 2'd2;
        #1;

        check_outputs(4'd12);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Multiplication (By zero: 9 * 0)", test_num);
        a = 4'd9; b = 4'd0; c = 2'd2;
        #1;

        check_outputs(4'd0);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Multiplication (Overflow: 5 * 5)", test_num);
        a = 4'd5; b = 4'd5; c = 2'd2;
        #1;

        check_outputs(4'd9);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Multiplication (Large overflow: 15 * 2)", test_num);
        a = 4'd15; b = 4'd2; c = 2'd2;
        #1;

        check_outputs(4'd14);
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
        input [3:0] expected_d;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_d === (expected_d ^ d ^ expected_d)) begin
                $display("PASS");
                $display("  Outputs: d=%h",
                         d);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: d=%h",
                         expected_d);
                $display("  Got:      d=%h",
                         d);
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
