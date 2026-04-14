`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] A;
    reg [2:0] B;
    wire a_greater;
    wire b_greater;
    wire equal;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .a_greater(a_greater),
        .b_greater(b_greater),
        .equal(equal)
    );
    task testcase001;

        begin
            test_num = 1;
            A = 3'b000; B = 3'b000;
            $display("Test Case %0d: A=0, B=0 (Equal)", test_num);
            #1;

            check_outputs(0, 0, 1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            A = 3'b111; B = 3'b111;
            $display("Test Case %0d: A=7, B=7 (Equal)", test_num);
            #1;

            check_outputs(0, 0, 1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            A = 3'b100; B = 3'b100;
            $display("Test Case %0d: A=4, B=4 (Equal)", test_num);
            #1;

            check_outputs(0, 0, 1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            A = 3'b001; B = 3'b000;
            $display("Test Case %0d: A=1, B=0 (A Greater)", test_num);
            #1;

            check_outputs(1, 0, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            A = 3'b111; B = 3'b000;
            $display("Test Case %0d: A=7, B=0 (A Greater)", test_num);
            #1;

            check_outputs(1, 0, 0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            A = 3'b101; B = 3'b011;
            $display("Test Case %0d: A=5, B=3 (A Greater)", test_num);
            #1;

            check_outputs(1, 0, 0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            A = 3'b000; B = 3'b001;
            $display("Test Case %0d: A=0, B=1 (B Greater)", test_num);
            #1;

            check_outputs(0, 1, 0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            A = 3'b000; B = 3'b111;
            $display("Test Case %0d: A=0, B=7 (B Greater)", test_num);
            #1;

            check_outputs(0, 1, 0);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            A = 3'b010; B = 3'b110;
            $display("Test Case %0d: A=2, B=6 (B Greater)", test_num);
            #1;

            check_outputs(0, 1, 0);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            A = 3'b110; B = 3'b111;
            $display("Test Case %0d: A=6, B=7 (B Greater)", test_num);
            #1;

            check_outputs(0, 1, 0);
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
        input expected_a_greater;
        input expected_b_greater;
        input expected_equal;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_a_greater === (expected_a_greater ^ a_greater ^ expected_a_greater) &&
                expected_b_greater === (expected_b_greater ^ b_greater ^ expected_b_greater) &&
                expected_equal === (expected_equal ^ equal ^ expected_equal)) begin
                $display("PASS");
                $display("  Outputs: a_greater=%b, b_greater=%b, equal=%b",
                         a_greater, b_greater, equal);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: a_greater=%b, b_greater=%b, equal=%b",
                         expected_a_greater, expected_b_greater, expected_equal);
                $display("  Got:      a_greater=%b, b_greater=%b, equal=%b",
                         a_greater, b_greater, equal);
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
