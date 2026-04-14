`timescale 1ns/1ps

module polynomial_evaluator_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] a;
    reg [3:0] b;
    reg [3:0] c;
    reg [3:0] d;
    reg [3:0] e;
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
        .e(e),
        .x(x),
        .result(result)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: All inputs zero", test_num);
            a = 4'd0; b = 4'd0; c = 4'd0; d = 4'd0; e = 4'd0; x = 4'd0;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Constant polynomial (P(x) = e)", test_num);
            a = 4'd0; b = 4'd0; c = 4'd0; d = 4'd0; e = 4'd15; x = 4'd10;
            #1;

            check_outputs(16'h000F);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Linear polynomial (P(x) = x)", test_num);
            a = 4'd0; b = 4'd0; c = 4'd0; d = 4'd1; e = 4'd0; x = 4'd12;
            #1;

            check_outputs(16'h000C);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Quadratic polynomial (P(x) = x^2)", test_num);
            a = 4'd0; b = 4'd0; c = 4'd1; d = 4'd0; e = 4'd0; x = 4'd10;
            #1;

            check_outputs(16'h0064);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Cubic polynomial (P(x) = x^3)", test_num);
            a = 4'd0; b = 4'd1; c = 4'd0; d = 4'd0; e = 4'd0; x = 4'd5;
            #1;

            check_outputs(16'h007D);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: 4th degree (P(x) = x^4)", test_num);
            a = 4'd1; b = 4'd0; c = 4'd0; d = 4'd0; e = 4'd0; x = 4'd4;
            #1;

            check_outputs(16'h0100);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: All coefficients one, x=2", test_num);
            a = 4'd1; b = 4'd1; c = 4'd1; d = 4'd1; e = 4'd1; x = 4'd2;
            #1;

            check_outputs(16'h001F);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: Mixed coefficients, x=8", test_num);
            a = 4'd0; b = 4'd0; c = 4'd2; d = 4'd5; e = 4'd10; x = 4'd8;
            #1;

            check_outputs(16'h00B2);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test %0d: Small coefficients, x=3", test_num);
            a = 4'd1; b = 4'd2; c = 4'd1; d = 4'd2; e = 4'd1; x = 4'd3;
            #1;

            check_outputs(16'h0097);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Test %0d: Large value near 16-bit limit", test_num);
            a = 4'd1; b = 4'd0; c = 4'd0; d = 4'd0; e = 4'd1; x = 4'd15;
            #1;

            check_outputs(16'hC5C2);
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
