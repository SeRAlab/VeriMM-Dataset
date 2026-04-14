`timescale 1ns/1ps

module polynomial_evaluator_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] a0;
    reg [3:0] a1;
    reg [3:0] a2;
    reg [3:0] a3;
    reg [3:0] a4;
    reg [3:0] x;
    wire [7:0] P;

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
        .P(P)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case 001: x=0, result should be a0");
            a4 = 4'hA; a3 = 4'hB; a2 = 4'hC; a1 = 4'hD; a0 = 4'h5;
            x = 4'h0;

            #1;


            check_outputs(8'd5);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case 002: x=1, result should be sum of coefficients");
            a4 = 4'd1; a3 = 4'd2; a2 = 4'd3; a1 = 4'd4; a0 = 4'd5;
            x = 4'd1;

            #1;


            check_outputs(8'd15);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case 003: Linear polynomial P(x) = 2x + 3");
            a4 = 4'd0; a3 = 4'd0; a2 = 4'd0; a1 = 4'd2; a0 = 4'd3;
            x = 4'd10;

            #1;


            check_outputs(8'd23);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case 004: Quadratic polynomial P(x) = x^2 + 2x + 1");
            a4 = 4'd0; a3 = 4'd0; a2 = 4'd1; a1 = 4'd2; a0 = 4'd1;
            x = 4'd5;

            #1;


            check_outputs(8'd36);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case 005: Cubic polynomial P(x) = x^3 + x^2 + x + 1");
            a4 = 4'd0; a3 = 4'd1; a2 = 4'd1; a1 = 4'd1; a0 = 4'd1;
            x = 4'd4;

            #1;


            check_outputs(8'd85);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case 006: 4th degree P(x) = x^4");
            a4 = 4'd1; a3 = 4'd0; a2 = 4'd0; a1 = 4'd0; a0 = 4'd0;
            x = 4'd3;

            #1;


            check_outputs(8'd81);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case 007: Overflow test (Modulo 256)");
            a4 = 4'd1; a3 = 4'd5; a2 = 4'd0; a1 = 4'd0; a0 = 4'd0;
            x = 4'd4;


            #1;



            check_outputs(8'd64);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test Case 008: Maximum bit values for 2nd degree");
            a4 = 4'd0; a3 = 4'd0; a2 = 4'd0; a1 = 4'hF; a0 = 4'hF;
            x = 4'hF;

            #1;


            check_outputs(8'hF0);
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
        input [7:0] expected_P;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_P === (expected_P ^ P ^ expected_P)) begin
                $display("PASS");
                $display("  Outputs: P=%h",
                         P);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: P=%h",
                         expected_P);
                $display("  Got:      P=%h",
                         P);
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
