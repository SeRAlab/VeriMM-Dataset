`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg M;
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
        .M(M),
        .S(S),
        .V(V)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            A = 4'd5;
            B = 4'd3;
            M = 1'b0;
            $display("Testcase %0d: Addition (5 + 3)", test_num);
            #1;

            check_outputs(4'd8, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            A = 4'd10;
            B = 4'd7;
            M = 1'b0;
            $display("Testcase %0d: Addition (10 + 7) - Expect Overflow", test_num);

            #1;


            check_outputs(4'd1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            A = 4'd15;
            B = 4'd15;
            M = 1'b0;
            $display("Testcase %0d: Addition (15 + 15) - Expect Overflow", test_num);

            #1;


            check_outputs(4'd14, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            A = 4'd12;
            B = 4'd4;
            M = 1'b1;
            $display("Testcase %0d: Subtraction (12 - 4)", test_num);
            #1;

            check_outputs(4'd8, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            A = 4'd9;
            B = 4'd9;
            M = 1'b1;
            $display("Testcase %0d: Subtraction (9 - 9)", test_num);
            #1;

            check_outputs(4'd0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            A = 4'd2;
            B = 4'd5;
            M = 1'b1;
            $display("Testcase %0d: Subtraction (2 - 5) - Expect Negative Overflow", test_num);

            #1;


            check_outputs(4'd13, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            A = 4'd0;
            B = 4'd15;
            M = 1'b1;
            $display("Testcase %0d: Subtraction (0 - 15) - Expect Negative Overflow", test_num);

            #1;


            check_outputs(4'd1, 1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            A = 4'd8;
            B = 4'd7;
            M = 1'b0;
            $display("Testcase %0d: Addition (8 + 7) - Edge of overflow", test_num);
            #1;

            check_outputs(4'd15, 1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            A = 4'd8;
            B = 4'd8;
            M = 1'b0;
            $display("Testcase %0d: Addition (8 + 8) - Exactly 16", test_num);
            #1;

            check_outputs(4'd0, 1'b1);
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
