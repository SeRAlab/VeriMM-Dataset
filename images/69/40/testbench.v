`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] alg_I;
    reg c1_enters;
    reg c2_enters;
    reg m1_enters;
    reg m2_enters;
    wire use_internal_x;
    wire use_internal_y;
    wire use_prev1;
    wire use_prev2;
    wire use_prevprev1;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .alg_I(alg_I),
        .c1_enters(c1_enters),
        .c2_enters(c2_enters),
        .m1_enters(m1_enters),
        .m2_enters(m2_enters),
        .use_internal_x(use_internal_x),
        .use_internal_y(use_internal_y),
        .use_prev1(use_prev1),
        .use_prev2(use_prev2),
        .use_prevprev1(use_prevprev1)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: All inputs zero, Algorithm 0", test_num);
            alg_I = 3'b000;
            m1_enters = 0;
            m2_enters = 0;
            c1_enters = 0;
            c2_enters = 0;

            #1;


            check_outputs(1'b0, 1'b0, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: m1_enters active, Algorithm 0", test_num);
            alg_I = 3'b000;
            m1_enters = 1;
            m2_enters = 0;
            c1_enters = 0;
            c2_enters = 0;


            #1;



            check_outputs(1'b0, 1'b0, 1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: m2_enters active, Algorithm 1", test_num);
            alg_I = 3'b001;
            m1_enters = 0;
            m2_enters = 1;
            c1_enters = 0;
            c2_enters = 0;
            #1;

            check_outputs(1'b0, 1'b0, 1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: c1_enters active, Algorithm 2", test_num);
            alg_I = 3'b010;
            m1_enters = 0;
            m2_enters = 0;
            c1_enters = 1;
            c2_enters = 0;
            #1;

            check_outputs(1'b1, 1'b0, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: c2_enters active, Algorithm 3", test_num);
            alg_I = 3'b011;
            m1_enters = 0;
            m2_enters = 0;
            c1_enters = 0;
            c2_enters = 1;
            #1;

            check_outputs(1'b0, 1'b1, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Multiple enters, Algorithm 4", test_num);
            alg_I = 3'b100;
            m1_enters = 1;
            m2_enters = 1;
            c1_enters = 0;
            c2_enters = 0;
            #1;

            check_outputs(1'b0, 1'b0, 1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case %0d: All inputs active, Algorithm 5", test_num);
            alg_I = 3'b101;
            m1_enters = 1;
            m2_enters = 1;
            c1_enters = 1;
            c2_enters = 1;

            #1;


            check_outputs(1'b1, 1'b1, 1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test Case %0d: Edge Case Algorithm 6", test_num);
            alg_I = 3'b110;
            m1_enters = 1;
            m2_enters = 0;
            c1_enters = 1;
            c2_enters = 0;
            #1;

            check_outputs(1'b1, 1'b0, 1'b1, 1'b0, 1'b1);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test Case %0d: Edge Case Algorithm 7", test_num);
            alg_I = 3'b111;
            m1_enters = 0;
            m2_enters = 1;
            c1_enters = 0;
            c2_enters = 1;
            #1;

            check_outputs(1'b0, 1'b1, 1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Test Case %0d: Full system activation", test_num);
            alg_I = 3'b111;
            m1_enters = 1;
            m2_enters = 1;
            c1_enters = 1;
            c2_enters = 1;
            #1;

            check_outputs(1'b1, 1'b1, 1'b1, 1'b1, 1'b1);
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
        input expected_use_internal_x;
        input expected_use_internal_y;
        input expected_use_prev1;
        input expected_use_prev2;
        input expected_use_prevprev1;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_use_internal_x === (expected_use_internal_x ^ use_internal_x ^ expected_use_internal_x) &&
                expected_use_internal_y === (expected_use_internal_y ^ use_internal_y ^ expected_use_internal_y) &&
                expected_use_prev1 === (expected_use_prev1 ^ use_prev1 ^ expected_use_prev1) &&
                expected_use_prev2 === (expected_use_prev2 ^ use_prev2 ^ expected_use_prev2) &&
                expected_use_prevprev1 === (expected_use_prevprev1 ^ use_prevprev1 ^ expected_use_prevprev1)) begin
                $display("PASS");
                $display("  Outputs: use_internal_x=%b, use_internal_y=%b, use_prev1=%b, use_prev2=%b, use_prevprev1=%b",
                         use_internal_x, use_internal_y, use_prev1, use_prev2, use_prevprev1);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: use_internal_x=%b, use_internal_y=%b, use_prev1=%b, use_prev2=%b, use_prevprev1=%b",
                         expected_use_internal_x, expected_use_internal_y, expected_use_prev1, expected_use_prev2, expected_use_prevprev1);
                $display("  Got:      use_internal_x=%b, use_internal_y=%b, use_prev1=%b, use_prev2=%b, use_prevprev1=%b",
                         use_internal_x, use_internal_y, use_prev1, use_prev2, use_prevprev1);
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
