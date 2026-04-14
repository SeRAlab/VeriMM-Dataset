`timescale 1ns/1ps

module polynomial_evaluator_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] a;
    reg [7:0] b;
    reg [7:0] c;
    reg [7:0] x;
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
        .x(x),
        .result(result)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: All zeros", test_num);
            a = 8'd0;
            b = 8'd0;
            c = 8'd0;
            x = 8'd0;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Constant term only (P(x) = c)", test_num);
            a = 8'd0;
            b = 8'd0;
            c = 8'd127;
            x = 8'd55;
            #1;

            check_outputs(16'h007F);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Linear term only (P(x) = bx)", test_num);
            a = 8'd0;
            b = 8'd10;
            c = 8'd0;
            x = 8'd25;
            #1;

            check_outputs(16'h00FA);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Quadratic term only (P(x) = ax^2)", test_num);
            a = 8'd2;
            b = 8'd0;
            c = 8'd0;
            x = 8'd12;
            #1;

            check_outputs(16'h0120);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Typical values", test_num);
            a = 8'd3;
            b = 8'd5;
            c = 8'd10;
            x = 8'd4;
            #1;

            check_outputs(16'h004E);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: x = 1 (P(1) = a + b + c)", test_num);
            a = 8'd100;
            b = 8'd50;
            c = 8'd25;
            x = 8'd1;
            #1;

            check_outputs(16'h00AF);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Large result fitting 16-bit", test_num);
            a = 8'd1;
            b = 8'd1;
            c = 8'd1;
            x = 8'd255;
            #1;

            check_outputs(16'hFF01);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: Overflow check (modulo 2^16)", test_num);


            a = 8'd10;
            b = 8'd0;
            c = 8'd0;
            x = 8'd200;
            #1;

            check_outputs(16'h1A80);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Testcase %0d: Small coefficients, medium x", test_num);
            a = 8'd1;
            b = 8'd2;
            c = 8'd3;
            x = 8'd100;
            #1;

            check_outputs(16'h27D3);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Testcase %0d: Max coefficients at x=2", test_num);
            a = 8'hFF;
            b = 8'hFF;
            c = 8'hFF;
            x = 8'd2;
            #1;

            check_outputs(16'h06FA);
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
