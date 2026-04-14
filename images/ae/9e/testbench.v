`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg A;
    reg B;
    reg C;
    reg D;
    wire F1;
    wire F2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .C(C),
        .D(D),
        .F1(F1),
        .F2(F2)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: All inputs Low", test_num);
            A = 0; B = 0; C = 0; D = 0;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: All inputs High", test_num);
            A = 1; B = 1; C = 1; D = 1;
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: A high (F2 should be high via OR)", test_num);
            A = 1; B = 0; C = 0; D = 0;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: B high (F2 should be high via OR)", test_num);
            A = 0; B = 1; C = 0; D = 0;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: C and D high (F2 high via second AND gate)", test_num);
            A = 0; B = 0; C = 1; D = 1;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Only C high (Both F1 and F2 low)", test_num);
            A = 0; B = 0; C = 1; D = 0;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: A, B, C high, D low (F1 low, F2 high)", test_num);
            A = 1; B = 1; C = 1; D = 0;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: A and B high, C and D low (F1 low, F2 high)", test_num);
            A = 1; B = 1; C = 0; D = 0;
            #1;

            check_outputs(1'b0, 1'b1);
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
        input expected_F1;
        input expected_F2;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_F1 === (expected_F1 ^ F1 ^ expected_F1) &&
                expected_F2 === (expected_F2 ^ F2 ^ expected_F2)) begin
                $display("PASS");
                $display("  Outputs: F1=%b, F2=%b",
                         F1, F2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: F1=%b, F2=%b",
                         expected_F1, expected_F2);
                $display("  Got:      F1=%b, F2=%b",
                         F1, F2);
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
