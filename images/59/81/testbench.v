`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    wire _EQL;
    wire _GT;
    wire _LT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        ._EQL(_EQL),
        ._GT(_GT),
        ._LT(_LT)
    );
    task testcase001;

        begin
            $display("Testcase 001: A=0, B=0 (Equality)");
            A = 4'd0; B = 4'd0;
            #1;

            check_outputs(1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: A=15, B=15 (Max Equality)");
            A = 4'd15; B = 4'd15;
            #1;

            check_outputs(1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: A=15, B=0 (A Greater Than B)");
            A = 4'd15; B = 4'd0;
            #1;

            check_outputs(1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: A=0, B=15 (A Less Than B)");
            A = 4'd0; B = 4'd15;
            #1;

            check_outputs(1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: A=8, B=4 (A Greater Than B)");
            A = 4'd8; B = 4'd4;
            #1;

            check_outputs(1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: A=3, B=7 (A Less Than B)");
            A = 4'd3; B = 4'd7;
            #1;

            check_outputs(1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: A=10, B=10 (Mid Equality)");
            A = 4'd10; B = 4'd10;
            #1;

            check_outputs(1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: A=1, B=0 (Boundary GT)");
            A = 4'd1; B = 4'd0;
            #1;

            check_outputs(1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase009;

        begin
            $display("Testcase 009: A=0, B=1 (Boundary LT)");
            A = 4'd0; B = 4'd1;
            #1;

            check_outputs(1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase010;

        begin
            $display("Testcase 010: A=5, B=10 (Random LT)");
            A = 4'd5; B = 4'd10;
            #1;

            check_outputs(1'b0, 1'b0, 1'b1);
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
        input expected__EQL;
        input expected__GT;
        input expected__LT;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected__EQL === (expected__EQL ^ _EQL ^ expected__EQL) &&
                expected__GT === (expected__GT ^ _GT ^ expected__GT) &&
                expected__LT === (expected__LT ^ _LT ^ expected__LT)) begin
                $display("PASS");
                $display("  Outputs: _EQL=%b, _GT=%b, _LT=%b",
                         _EQL, _GT, _LT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: _EQL=%b, _GT=%b, _LT=%b",
                         expected__EQL, expected__GT, expected__LT);
                $display("  Got:      _EQL=%b, _GT=%b, _LT=%b",
                         _EQL, _GT, _LT);
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
