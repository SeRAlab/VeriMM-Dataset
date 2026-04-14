`timescale 1ns/1ps

module JK_latch_tb;

    // Testbench signals (combinational circuit)
    reg Enable;
    reg J;
    reg K;
    wire Q;
    wire Qn;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    JK_latch dut (
        .Enable(Enable),
        .J(J),
        .K(K),
        .Q(Q),
        .Qn(Qn)
    );
    task testcase001;

        begin
            $display("Testcase 001: Set Output (J=1, K=0, Enable=1)");
            test_num = test_num + 1;

            Enable = 1; J = 0; K = 1; #10;

            Enable = 1; J = 1; K = 0; #10;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Reset Output (J=0, K=1, Enable=1)");
            test_num = test_num + 1;

            Enable = 1; J = 1; K = 0; #10;

            Enable = 1; J = 0; K = 1; #10;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Hold State via Enable=0");
            test_num = test_num + 1;

            Enable = 1; J = 1; K = 0; #10;

            Enable = 0; J = 0; K = 1; #10;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Hold State via J=0, K=0");
            test_num = test_num + 1;

            Enable = 1; J = 0; K = 1; #10;

            Enable = 1; J = 0; K = 0; #10;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Toggle Output (0 to 1)");
            test_num = test_num + 1;

            Enable = 1; J = 0; K = 1; #10;

            Enable = 1; J = 1; K = 1; #10;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Toggle Output (1 to 0)");
            test_num = test_num + 1;

            Enable = 1; J = 1; K = 0; #10;

            Enable = 1; J = 1; K = 1; #10;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Ignore inputs when Enable is low");
            test_num = test_num + 1;

            Enable = 1; J = 0; K = 1; #10;

            Enable = 0; J = 1; K = 1; #10;
            J = 1; K = 0; #10;
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
        $display("JK_latch Testbench");
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
        input expected_Qn;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Q === (expected_Q ^ Q ^ expected_Q) &&
                expected_Qn === (expected_Qn ^ Qn ^ expected_Qn)) begin
                $display("PASS");
                $display("  Outputs: Q=%b, Qn=%b",
                         Q, Qn);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%b, Qn=%b",
                         expected_Q, expected_Qn);
                $display("  Got:      Q=%b, Qn=%b",
                         Q, Qn);
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
