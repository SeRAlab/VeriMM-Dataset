`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] A;
    reg [31:0] B;
    reg C;
    wire [31:0] S;
    wire V;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .C(C),
        .S(S),
        .V(V)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Addition (Positive)", test_num);
            A = 32'sd100;
            B = 32'sd250;
            C = 1'b0;
            #1;

            check_outputs(32'sd350, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Addition (Negative)", test_num);
            A = -32'sd500;
            B = -32'sd1000;
            C = 1'b0;
            #1;

            check_outputs(-32'sd1500, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Addition Overflow (Pos + Pos)", test_num);
            A = 32'h7FFFFFFF;
            B = 32'h00000001;
            C = 1'b0;
            #1;

            check_outputs(32'h80000000, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Addition Overflow (Neg + Neg)", test_num);
            A = 32'h80000000;
            B = 32'hFFFFFFFF;
            C = 1'b0;
            #1;

            check_outputs(32'h7FFFFFFF, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Subtraction (Positive)", test_num);
            A = 32'sd1000;
            B = 32'sd400;
            C = 1'b1;
            #1;

            check_outputs(32'sd600, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Subtraction (Negative Result)", test_num);
            A = 32'sd100;
            B = 32'sd500;
            C = 1'b1;
            #1;

            check_outputs(-32'sd400, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Subtraction Overflow (Pos - Neg)", test_num);
            A = 32'h7FFFFFFF;
            B = 32'hFFFFFFFF;
            C = 1'b1;
            #1;

            check_outputs(32'h80000000, 1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Subtraction Overflow (Neg - Pos)", test_num);
            A = 32'h80000000;
            B = 32'h00000001;
            C = 1'b1;
            #1;

            check_outputs(32'h7FFFFFFF, 1'b1);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Mixed Sign Addition (No Overflow)", test_num);
            A = 32'h7FFFFFFF;
            B = 32'h80000000;
            C = 1'b0;
            #1;

            check_outputs(32'hFFFFFFFF, 1'b0);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Zero Operands", test_num);
            A = 32'sd0;
            B = 32'sd0;
            C = 1'b1;
            #1;

            check_outputs(32'sd0, 1'b0);
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
        input [31:0] expected_S;
        input expected_V;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_S === (expected_S ^ S ^ expected_S) &&
                expected_V === (expected_V ^ V ^ expected_V)) begin
                $display("PASS");
                $display("  Outputs: S=%h, V=%b",
                         S, V);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: S=%h, V=%b",
                         expected_S, expected_V);
                $display("  Got:      S=%h, V=%b",
                         S, V);
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
