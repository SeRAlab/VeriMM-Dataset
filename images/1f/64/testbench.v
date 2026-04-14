`timescale 1ns/1ps

module polynomial_evaluator_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] a0;
    reg [3:0] a1;
    reg [3:0] a2;
    reg [3:0] a3;
    reg [3:0] x;
    wire [7:0] result;

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
        $display("Test %0d: Constant polynomial (a0 only)", test_num);
        a3 = 0; a2 = 0; a1 = 0; a0 = 4'd10; x = 4'd5;

        #1;


        check_outputs(8'd10);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Linear polynomial (a1*x + a0)", test_num);
        a3 = 0; a2 = 0; a1 = 4'd2; a0 = 4'd3; x = 4'd4;

        #1;


        check_outputs(8'd11);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Quadratic polynomial (a2*x^2 + a1*x + a0)", test_num);
        a3 = 0; a2 = 4'd1; a1 = 4'd2; a0 = 4'd1; x = 4'd3;

        #1;


        check_outputs(8'd16);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Cubic term only (a3*x^3)", test_num);
        a3 = 4'd1; a2 = 0; a1 = 0; a0 = 0; x = 4'd5;

        #1;


        check_outputs(8'd125);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: All coefficients = 1, x = 2", test_num);
        a3 = 4'd1; a2 = 4'd1; a1 = 4'd1; a0 = 4'd1; x = 4'd2;

        #1;


        check_outputs(8'd15);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Variable x is 0 (Result should be a0)", test_num);
        a3 = 4'd15; a2 = 4'd10; a1 = 4'd5; a0 = 4'd7; x = 4'd0;

        #1;


        check_outputs(8'd7);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: High value result within 8 bits", test_num);
        a3 = 0; a2 = 4'd1; a1 = 0; a0 = 4'd0; x = 4'd15;

        #1;


        check_outputs(8'd225);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Truncation check (Result exceeds 255)", test_num);
        a3 = 4'd1; a2 = 0; a1 = 0; a0 = 0; x = 4'd10;

        #1;


        check_outputs(8'hE8);
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
