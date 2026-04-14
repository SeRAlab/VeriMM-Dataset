`timescale 1ns/1ps

module polynomial_evaluator_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] a;
    reg [3:0] b;
    reg [3:0] c;
    reg [3:0] d;
    reg [3:0] x;
    wire [15:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    polynomial_evaluator dut (
        .a(a),
        .b(b),
        .c(c),
        .d(d),
        .x(x),
        .result(result)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All inputs zero (P(0) = 0*0^3 + 0*0^2 + 0*0 + 0)", test_num);
            a = 4'd0; b = 4'd0; c = 4'd0; d = 4'd0; x = 4'd0;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Only constant term d (x=0)", test_num);
            a = 4'd5; b = 4'd2; c = 4'd1; d = 4'd10; x = 4'd0;
            #1;

            check_outputs(16'h000A);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: x=1 (Sum of coefficients: 1+2+3+4)", test_num);
            a = 4'd1; b = 4'd2; c = 4'd3; d = 4'd4; x = 4'd1;
            #1;

            check_outputs(16'h000A);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Simple quadratic (a=0, x=2)", test_num);
            a = 4'd0; b = 4'd1; c = 4'd1; d = 4'd1; x = 4'd2;

            #1;


            check_outputs(16'h0007);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Pure cubic (b,c,d=0, x=3)", test_num);
            a = 4'd1; b = 4'd0; c = 4'd0; d = 4'd0; x = 4'd3;

            #1;


            check_outputs(16'h001B);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Medium values (x=4)", test_num);
            a = 4'd2; b = 4'd1; c = 4'd5; d = 4'd3; x = 4'd4;

            #1;


            check_outputs(16'h00A7);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Larger x value (x=10)", test_num);
            a = 4'd1; b = 4'd1; c = 4'd1; d = 4'd1; x = 4'd10;

            #1;


            check_outputs(16'h0457);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Maximum possible inputs (a,b,c,d,x=15)", test_num);
            a = 4'd15; b = 4'd15; c = 4'd15; d = 4'd15; x = 4'd15;

            #1;


            check_outputs(16'hD3E0);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Only linear term (a,b,d=0, x=12)", test_num);
            a = 4'd0; b = 4'd0; c = 4'd2; d = 4'd0; x = 4'd12;

            #1;


            check_outputs(16'h0018);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: High coefficients, small x (x=2)", test_num);
            a = 4'd10; b = 4'd10; c = 4'd10; d = 4'd10; x = 4'd2;

            #1;


            check_outputs(16'h0096);
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
