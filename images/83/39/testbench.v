`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg Cn;
    wire [3:0] S;
    wire V;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .Cn(Cn),
        .S(S),
        .V(V)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Addition (3 + 2)", test_num);
            A = 4'd3; B = 4'd2; Cn = 1'b0;
            #1;

            check_outputs(4'd5, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Addition (-3 + -2)", test_num);
            A = 4'b1101; B = 4'b1110; Cn = 1'b0;
            #1;

            check_outputs(4'b1011, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Addition (7 + -1)", test_num);
            A = 4'd7; B = 4'b1111; Cn = 1'b0;
            #1;

            check_outputs(4'd6, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Addition Overflow (5 + 4)", test_num);
            A = 4'd5; B = 4'd4; Cn = 1'b0;
            #1;

            check_outputs(4'b1001, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Addition Overflow (-5 + -4)", test_num);
            A = 4'b1011; B = 4'b1100; Cn = 1'b0;
            #1;

            check_outputs(4'b0111, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Subtraction (5 - 2)", test_num);
            A = 4'd5; B = 4'd2; Cn = 1'b1;
            #1;

            check_outputs(4'd3, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Subtraction (-2 - -5)", test_num);
            A = 4'b1110; B = 4'b1011; Cn = 1'b1;
            #1;

            check_outputs(4'd3, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Subtraction Overflow (5 - -4)", test_num);
            A = 4'd5; B = 4'b1100; Cn = 1'b1;
            #1;

            check_outputs(4'b1001, 1'b1);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Subtraction Overflow (-5 - 4)", test_num);
            A = 4'b1011; B = 4'd4; Cn = 1'b1;
            #1;

            check_outputs(4'b0111, 1'b1);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Addition Boundary (7 + 1)", test_num);
            A = 4'd7; B = 4'd1; Cn = 1'b0;
            #1;

            check_outputs(4'b1000, 1'b1);
        end
        endtask

    task testcase011;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Addition Boundary (-8 + -1)", test_num);
            A = 4'b1000; B = 4'b1111; Cn = 1'b0;
            #1;

            check_outputs(4'b0111, 1'b1);
        end
        endtask

    task testcase012;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Subtraction Zero (0 - 0)", test_num);
            A = 4'd0; B = 4'd0; Cn = 1'b1;
            #1;

            check_outputs(4'd0, 1'b0);
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
        testcase011();
        testcase012();
        
        
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
        input [3:0] expected_S;
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
