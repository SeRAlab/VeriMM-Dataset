`timescale 1ns/1ps

module polynomial_evaluator_tb;

    // Testbench signals (combinational circuit)
    reg [9:0] a0;
    reg [9:0] a1;
    reg [9:0] a2;
    reg [9:0] a3;
    reg [3:0] x;
    wire [9:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    polynomial_evaluator dut (
        .a0(a0),
        .a1(a1),
        .a2(a2),
        .a3(a3),
        .x(x),
        .result(result)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Constant Polynomial P(x) = 50", test_num);
        a0 = 10'd50; a1 = 10'd0; a2 = 10'd0; a3 = 10'd0; x = 4'd12;
        #1;

        check_outputs(10'd50);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Linear Polynomial P(x) = 10 + 5x", test_num);
        a0 = 10'd10; a1 = 10'd5; a2 = 10'd0; a3 = 10'd0; x = 4'd4;
        #1;

        check_outputs(10'd30);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Quadratic Polynomial P(x) = 1 + 3x + 2x^2", test_num);
        a0 = 10'd1; a1 = 10'd3; a2 = 10'd2; a3 = 10'd0; x = 4'd5;
        #1;

        check_outputs(10'd66);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Cubic Polynomial P(x) = x^3", test_num);
        a0 = 10'd0; a1 = 10'd0; a2 = 10'd0; a3 = 10'd1; x = 4'd10;
        #1;

        check_outputs(10'd1000);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Full Polynomial P(x) = 100 + 20x + 5x^2 + x^3", test_num);
        a0 = 10'd100; a1 = 10'd20; a2 = 10'd5; a3 = 10'd1; x = 4'd2;
        #1;

        check_outputs(10'd168);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Boundary check x = 0", test_num);
        a0 = 10'd777; a1 = 10'd10; a2 = 10'd10; a3 = 10'd10; x = 4'd0;
        #1;

        check_outputs(10'd777);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Boundary check x = 1 (Sum of coefficients)", test_num);
        a0 = 10'd100; a1 = 10'd100; a2 = 10'd100; a3 = 10'd100; x = 4'd1;
        #1;

        check_outputs(10'd400);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Maximum 10-bit value", test_num);
        a0 = 10'd1023; a1 = 10'd0; a2 = 10'd0; a3 = 10'd0; x = 4'd15;
        #1;

        check_outputs(10'd1023);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Significant Cubic Influence", test_num);
        a0 = 10'd1; a1 = 10'd1; a2 = 10'd1; a3 = 10'd1; x = 4'd9;
        #1;

        check_outputs(10'd820);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: High x sparse coefficients", test_num);
        a0 = 10'd1; a1 = 10'd2; a2 = 10'd3; a3 = 10'd0; x = 4'd10;
        #1;

        check_outputs(10'd321);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("polynomial_evaluator Testbench");
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
        input [9:0] expected_result;
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
