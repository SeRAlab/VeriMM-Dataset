`timescale 1ns/1ps

module polynomial_evaluator_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] a;
    reg [3:0] b;
    reg [3:0] c;
    reg [3:0] x;
    wire [7:0] result;

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
            $display("Test %0d: All zeros (P(0) = 0*0^2 + 0*0 + 0)", test_num);
            a = 4'sd0; b = 4'sd0; c = 4'sd0; x = 4'sd0;
            #1;

            check_outputs(8'sh00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Small positive values (P(1) = 1*1^2 + 1*1 + 1)", test_num);
            a = 4'sd1; b = 4'sd1; c = 4'sd1; x = 4'sd1;
            #1;

            check_outputs(8'sh03);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Positive coefficients, positive x (P(4) = 1*4^2 + 2*4 + 3)", test_num);
            a = 4'sd1; b = 4'sd2; c = 4'sd3; x = 4'sd4;
            #1;

            check_outputs(8'sh1B);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Negative 'a' coefficient (P(5) = -1*5^2 + 1*5 + 1)", test_num);
            a = -4'sd1; b = 4'sd1; c = 4'sd1; x = 4'sd5;
            #1;

            check_outputs(8'shED);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Negative x and negative b (P(-2) = 2*(-2)^2 - 3*(-2) + 1)", test_num);
            a = 4'sd2; b = -4'sd3; c = 4'sd1; x = -4'sd2;
            #1;

            check_outputs(8'sh0F);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Linear case (a=0) (P(-4) = 0*x^2 + 4*(-4) + 7)", test_num);
            a = 4'sd0; b = 4'sd4; c = 4'sd7; x = -4'sd4;
            #1;

            check_outputs(8'shF7);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Large x, zero b (P(7) = 1*7^2 + 0*7 - 8)", test_num);
            a = 4'sd1; b = 4'sd0; c = -4'sd8; x = 4'sd7;
            #1;

            check_outputs(8'sh29);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: Large negative result (P(7) = -2*7^2 + 0 + 0)", test_num);
            a = -4'sd2; b = 4'sd0; c = 4'sd0; x = 4'sd7;
            #1;

            check_outputs(8'sh9E);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test %0d: Maximum negative x (P(-8) = 1*(-8)^2 + 7*(-8) + 7)", test_num);
            a = 4'sd1; b = 4'sd7; c = 4'sd7; x = -4'sd8;
            #1;

            check_outputs(8'sh0F);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Test %0d: All negative inputs (P(-4) = -1*(-4)^2 - 8*(-4) - 8)", test_num);
            a = -4'sd1; b = -4'sd8; c = -4'sd8; x = -4'sd4;
            #1;

            check_outputs(8'sh08);
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
