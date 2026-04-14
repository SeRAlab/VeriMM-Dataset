`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg E;
    reg R;
    reg S;
    wire Q;
    wire Qbar;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .E(E),
        .R(R),
        .S(S),
        .Q(Q),
        .Qbar(Qbar)
    );
    task testcase001;

        begin
            test_num = 1;

            E = 1; S = 0; R = 1;
            #10;
            $display("Testcase %0d: Basic Reset (E=1, S=0, R=1)", test_num);
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;

            E = 1; S = 0; R = 1;
            #10;

            E = 1; S = 1; R = 0;
            #10;
            $display("Testcase %0d: Basic Set (E=1, S=1, R=0)", test_num);
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;

            E = 1; S = 0; R = 1;
            #10;

            E = 1; S = 1; R = 0;
            #10;

            E = 0; S = 0; R = 1;
            #10;
            $display("Testcase %0d: Memory Hold Set (E=0, S=0, R=1 after Set)", test_num);
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;

            E = 1; S = 0; R = 1;
            #10;

            E = 0; S = 1; R = 0;
            #10;
            $display("Testcase %0d: Memory Hold Reset (E=0, S=1, R=0 after Reset)", test_num);
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;

            E = 1; S = 0; R = 1;
            #10;

            E = 1; S = 0; R = 0;
            #10;
            $display("Testcase %0d: Hold while Enabled (E=1, S=0, R=0 after Reset)", test_num);
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;

            E = 1; S = 0; R = 1;
            #10;

            E = 1; S = 1; R = 0;
            #10;

            E = 1; S = 0; R = 0;
            #10;
            $display("Testcase %0d: Hold while Enabled (E=1, S=0, R=0 after Set)", test_num);
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;

            E = 1; S = 0; R = 1;
            #10;

            E = 1; S = 1; R = 0;
            #10;

            E = 1; S = 0; R = 1;
            #10;
            $display("Testcase %0d: Rapid Toggle back to Reset", test_num);
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
        input expected_Q;
        input expected_Qbar;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Q === (expected_Q ^ Q ^ expected_Q) &&
                expected_Qbar === (expected_Qbar ^ Qbar ^ expected_Qbar)) begin
                $display("PASS");
                $display("  Outputs: Q=%b, Qbar=%b",
                         Q, Qbar);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%b, Qbar=%b",
                         expected_Q, expected_Qbar);
                $display("  Got:      Q=%b, Qbar=%b",
                         Q, Qbar);
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
