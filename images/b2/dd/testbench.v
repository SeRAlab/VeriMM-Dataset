`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg A;
    reg B;
    reg C;
    wire Y1;
    wire Y2;
    wire Y3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .C(C),
        .Y1(Y1),
        .Y2(Y2),
        .Y3(Y3)
    );
    task testcase001;

        begin
            test_num = 1;
            A = 0; B = 0; C = 0;

            #1;


            check_outputs(0, 0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            A = 1; B = 0; C = 0;

            #1;


            check_outputs(1, 0, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            A = 0; B = 1; C = 0;

            #1;


            check_outputs(0, 1, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            A = 1; B = 1; C = 0;

            #1;


            check_outputs(1, 1, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            A = 0; B = 0; C = 1;

            #1;


            check_outputs(0, 0, 0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            A = 1; B = 0; C = 1;

            #1;


            check_outputs(0, 0, 0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            A = 0; B = 1; C = 1;

            #1;


            check_outputs(0, 0, 1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            A = 1; B = 1; C = 1;

            #1;


            check_outputs(0, 0, 1);
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
        input expected_Y1;
        input expected_Y2;
        input expected_Y3;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Y1 === (expected_Y1 ^ Y1 ^ expected_Y1) &&
                expected_Y2 === (expected_Y2 ^ Y2 ^ expected_Y2) &&
                expected_Y3 === (expected_Y3 ^ Y3 ^ expected_Y3)) begin
                $display("PASS");
                $display("  Outputs: Y1=%b, Y2=%b, Y3=%b",
                         Y1, Y2, Y3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Y1=%b, Y2=%b, Y3=%b",
                         expected_Y1, expected_Y2, expected_Y3);
                $display("  Got:      Y1=%b, Y2=%b, Y3=%b",
                         Y1, Y2, Y3);
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
