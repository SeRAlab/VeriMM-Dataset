`timescale 1ns/1ps

module logistic_regression_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] w1;
    reg [3:0] w2;
    reg [3:0] x1;
    reg [3:0] x2;
    wire result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    logistic_regression dut (
        .w1(w1),
        .w2(w2),
        .x1(x1),
        .x2(x2),
        .result(result)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case 001: All zeros (Linear sum = 0)");
            w1 = 4'sb0000; x1 = 4'sb0000;
            w2 = 4'sb0000; x2 = 4'sb0000;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case 002: Positive weights and inputs");
            w1 = 4'sb0010; x1 = 4'sb0011;
            w2 = 4'sb0001; x2 = 4'sb0010;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case 003: Negative weight with positive input");
            w1 = 4'sb1110; x1 = 4'sb0011;
            w2 = 4'sb1111; x2 = 4'sb0010;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case 004: Negative weights and negative inputs (Result Positive)");
            w1 = 4'sb1110; x1 = 4'sb1110;
            w2 = 4'sb1101; x2 = 4'sb1111;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case 005: Large magnitude negative result");
            w1 = 4'sb1000; x1 = 4'sb0111;
            w2 = 4'sb1000; x2 = 4'sb0111;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case 006: Weighted sum resulting in exactly zero (Boundary)");
            w1 = 4'sb0010; x1 = 4'sb0100;
            w2 = 4'sb1110; x2 = 4'sb0100;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case 007: Opposing large products (Slightly negative)");
            w1 = 4'sb0111; x1 = 4'sb0111;
            w2 = 4'sb1000; x2 = 4'sb0111;

            #1;


            check_outputs(1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("logistic_regression Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        
        
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
        input expected_result;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: result=%b",
                         result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: result=%b",
                         expected_result);
                $display("  Got:      result=%b",
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
