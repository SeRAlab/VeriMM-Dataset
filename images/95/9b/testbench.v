`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg A;
    reg B;
    reg C_N;
    reg D_N;
    wire Y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .C_N(C_N),
        .D_N(D_N),
        .Y(Y)
    );
    task testcase001;

        begin
            $display("Testcase 001: All logical inputs low (The only '1' output condition)");
            A = 0; B = 0; C_N = 1; D_N = 1;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Logical A high");
            A = 1; B = 0; C_N = 1; D_N = 1;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Logical B high");
            A = 0; B = 1; C_N = 1; D_N = 1;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Logical C high (C_N pin low)");
            A = 0; B = 0; C_N = 0; D_N = 1;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Logical D high (D_N pin low)");
            A = 0; B = 0; C_N = 1; D_N = 0;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: All active-high pins high, all active-low pins low");
            A = 1; B = 1; C_N = 0; D_N = 0;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: All physical pins low");
            A = 0; B = 0; C_N = 0; D_N = 0;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: All physical pins high");
            A = 1; B = 1; C_N = 1; D_N = 1;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase009;

        begin
            $display("Testcase 009: Mixed logical states (A and C high)");
            A = 1; B = 0; C_N = 0; D_N = 1;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase010;

        begin
            $display("Testcase 010: Mixed logical states (B and D high)");
            A = 0; B = 1; C_N = 1; D_N = 0;
            #1;

            check_outputs(0);
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
        input expected_Y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Y === (expected_Y ^ Y ^ expected_Y)) begin
                $display("PASS");
                $display("  Outputs: Y=%b",
                         Y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Y=%b",
                         expected_Y);
                $display("  Got:      Y=%b",
                         Y);
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
