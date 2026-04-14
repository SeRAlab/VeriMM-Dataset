`timescale 1ns/1ps

module polynomial_evaluator_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] a0;
    reg [3:0] a1;
    reg [3:0] a2;
    reg [3:0] a3;
    reg [3:0] a4;
    reg [3:0] x;
    wire [15:0] result;

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
        .a4(a4),
        .x(x),
        .result(result)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All zeros", test_num);
            a4 = 4'd0; a3 = 4'd0; a2 = 4'd0; a1 = 4'd0; a0 = 4'd0; x = 4'd5;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Constant term only", test_num);
            a4 = 4'd0; a3 = 4'd0; a2 = 4'd0; a1 = 4'd0; a0 = 4'd12; x = 4'd7;
            #1;

            check_outputs(16'd12);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Linear polynomial (a1*x + a0)", test_num);
            a4 = 4'd0; a3 = 4'd0; a2 = 4'd0; a1 = 4'd5; a0 = 4'd2; x = 4'd3;

            #1;


            check_outputs(16'd17);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Quadratic polynomial", test_num);
            a4 = 4'd0; a3 = 4'd0; a2 = 4'd2; a1 = 4'd3; a0 = 4'd1; x = 4'd4;

            #1;


            check_outputs(16'd45);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Cubic polynomial", test_num);
            a4 = 4'd0; a3 = 4'd1; a2 = 4'd2; a1 = 4'd3; a0 = 4'd4; x = 4'd5;

            #1;


            check_outputs(16'd194);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Full quartic polynomial", test_num);
            a4 = 4'd1; a3 = 4'd2; a2 = 4'd3; a1 = 4'd4; a0 = 4'd5; x = 4'd2;

            #1;


            check_outputs(16'd57);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: x = 1 (Sum of coefficients)", test_num);
            a4 = 4'd15; a3 = 4'd15; a2 = 4'd15; a1 = 4'd15; a0 = 4'd15; x = 4'd1;

            #1;


            check_outputs(16'd75);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: x = 0 (Constant result)", test_num);
            a4 = 4'd10; a3 = 4'd10; a2 = 4'd10; a1 = 4'd10; a0 = 4'd10; x = 4'd0;
            #1;

            check_outputs(16'd10);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Large x with medium coefficients", test_num);
            a4 = 4'd0; a3 = 4'd2; a2 = 4'd10; a1 = 4'd5; a0 = 4'd0; x = 4'd8;

            #1;


            check_outputs(16'd1704);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: High result value near 16-bit limit", test_num);
            a4 = 4'd15; a3 = 4'd0; a2 = 4'd0; a1 = 4'd0; a0 = 4'd0; x = 4'd8;

            #1;


            check_outputs(16'hF000);
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
