`timescale 1ns/1ps

module fixed_point_multiplier_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] a;
    reg [15:0] b;
    wire [15:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fixed_point_multiplier dut (
        .a(a),
        .b(b),
        .result(result)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Multiplicative Identity (1.0 * 1.0)", test_num);
        a = 16'h0100;
        b = 16'h0100;
        #1;

        check_outputs(16'h0100);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Zero Property (2.5 * 0.0)", test_num);
        a = 16'h0280;
        b = 16'h0000;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Integer Multiplication (2.0 * 3.0)", test_num);
        a = 16'h0200;
        b = 16'h0300;
        #1;

        check_outputs(16'h0600);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Fractional Multiplication (0.5 * 0.5)", test_num);
        a = 16'h0080;
        b = 16'h0080;
        #1;

        check_outputs(16'h0040);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Mixed Number Multiplication (1.5 * 2.5)", test_num);
        a = 16'h0180;
        b = 16'h0280;
        #1;

        check_outputs(16'h03C0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Power of Two (4.0 * 4.0)", test_num);
        a = 16'h0400;
        b = 16'h0400;
        #1;

        check_outputs(16'h1000);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Small Fractional Multiplication (0.125 * 0.125)", test_num);
        a = 16'h0020;
        b = 16'h0020;
        #1;

        check_outputs(16'h0004);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Reciprocal Integers (16.0 * 0.0625)", test_num);
        a = 16'h1000;
        b = 16'h0010;
        #1;

        check_outputs(16'h0100);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Larger Integer (127.0 * 1.0)", test_num);
        a = 16'h7F00;
        b = 16'h0100;
        #1;

        check_outputs(16'h7F00);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Hex check (10.5 * 2.0)", test_num);
        a = 16'h0A80;
        b = 16'h0200;
        #1;

        check_outputs(16'h1500);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("fixed_point_multiplier Testbench");
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
