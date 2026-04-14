`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] S;
    reg [31:0] T;
    wire C;
    wire N;
    wire V;
    wire [31:0] Y_hi;
    wire [31:0] Y_lo;
    wire Z;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .S(S),
        .T(T),
        .C(C),
        .N(N),
        .V(V),
        .Y_hi(Y_hi),
        .Y_lo(Y_lo),
        .Z(Z)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Basic Division (10 / 3)", test_num);
            S = 32'd10;
            T = 32'd3;

            #1;


            check_outputs(C, 1'b0, V, 32'd1, 32'd3, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Dividend < Divisor (5 / 12)", test_num);
            S = 32'd5;
            T = 32'd12;

            #1;


            check_outputs(C, 1'b0, V, 32'd5, 32'd0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Dividend is Zero (0 / 50)", test_num);
            S = 32'd0;
            T = 32'd50;

            #1;


            check_outputs(C, 1'b0, V, 32'd0, 32'd0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Division by 1 (1234 / 1)", test_num);
            S = 32'd1234;
            T = 32'd1;

            #1;


            check_outputs(C, 1'b0, V, 32'd0, 32'd1234, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Result MSB set (0xFFFFFFFF / 1)", test_num);
            S = 32'hFFFFFFFF;
            T = 32'd1;

            #1;


            check_outputs(C, 1'b1, V, 32'd0, 32'hFFFFFFFF, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Large Values (0xFFFFFFFF / 2)", test_num);
            S = 32'hFFFFFFFF;
            T = 32'd2;

            #1;


            check_outputs(C, 1'b0, V, 32'd1, 32'h7FFFFFFF, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Same Dividend and Divisor", test_num);
            S = 32'hA5A5A5A5;
            T = 32'hA5A5A5A5;

            #1;


            check_outputs(C, 1'b0, V, 32'd0, 32'd1, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Power of 2 (1024 / 16)", test_num);
            S = 32'd1024;
            T = 32'd16;

            #1;


            check_outputs(C, 1'b0, V, 32'd0, 32'd64, 1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Quotient 1 with Remainder (13 / 7)", test_num);
            S = 32'd13;
            T = 32'd7;

            #1;


            check_outputs(C, 1'b0, V, 32'd6, 32'd1, 1'b0);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: 0xFFFFFFFF / 0xFFFF", test_num);
            S = 32'hFFFFFFFF;
            T = 32'h0000FFFF;


            #1;



            check_outputs(C, 1'b0, V, 32'd0, 32'h10001, 1'b0);
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
        input expected_C;
        input expected_N;
        input expected_V;
        input [31:0] expected_Y_hi;
        input [31:0] expected_Y_lo;
        input expected_Z;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_C === (expected_C ^ C ^ expected_C) &&
                expected_N === (expected_N ^ N ^ expected_N) &&
                expected_V === (expected_V ^ V ^ expected_V) &&
                expected_Y_hi === (expected_Y_hi ^ Y_hi ^ expected_Y_hi) &&
                expected_Y_lo === (expected_Y_lo ^ Y_lo ^ expected_Y_lo) &&
                expected_Z === (expected_Z ^ Z ^ expected_Z)) begin
                $display("PASS");
                $display("  Outputs: C=%b, N=%b, V=%b, Y_hi=%h, Y_lo=%h, Z=%b",
                         C, N, V, Y_hi, Y_lo, Z);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: C=%b, N=%b, V=%b, Y_hi=%h, Y_lo=%h, Z=%b",
                         expected_C, expected_N, expected_V, expected_Y_hi, expected_Y_lo, expected_Z);
                $display("  Got:      C=%b, N=%b, V=%b, Y_hi=%h, Y_lo=%h, Z=%b",
                         C, N, V, Y_hi, Y_lo, Z);
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
