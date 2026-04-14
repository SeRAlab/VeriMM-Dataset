`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [1:0] S;
    wire [3:0] X;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .S(S),
        .X(X)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case 001: S=00 (Zero Output), A=4'b1010");
            A = 4'b1010;
            S = 2'b00;
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case 002: S=00 (Zero Output), A=4'b1111");
            A = 4'b1111;
            S = 2'b00;
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case 003: S=01 (One Output), A=4'b0000");
            A = 4'b0000;
            S = 2'b01;
            #1;

            check_outputs(4'b1111);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case 004: S=01 (One Output), A=4'b0101");
            A = 4'b0101;
            S = 2'b01;
            #1;

            check_outputs(4'b1111);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case 005: S=10, A=4'b1111 (Exception: Output should be 0000)");
            A = 4'b1111;
            S = 2'b10;
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case 006: S=10, A=4'b1010 (Retain A)");
            A = 4'b1010;
            S = 2'b10;
            #1;

            check_outputs(4'b1010);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case 007: S=10, A=4'b0000 (Retain A)");
            A = 4'b0000;
            S = 2'b10;
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test Case 008: S=11, A=4'b0000 (Exception: Output should be 1111)");
            A = 4'b0000;
            S = 2'b11;
            #1;

            check_outputs(4'b1111);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test Case 009: S=11, A=4'b0101 (Retain A)");
            A = 4'b0101;
            S = 2'b11;
            #1;

            check_outputs(4'b0101);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Test Case 010: S=11, A=4'b1111 (Retain A)");
            A = 4'b1111;
            S = 2'b11;
            #1;

            check_outputs(4'b1111);
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
        input [3:0] expected_X;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_X === (expected_X ^ X ^ expected_X)) begin
                $display("PASS");
                $display("  Outputs: X=%h",
                         X);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: X=%h",
                         expected_X);
                $display("  Got:      X=%h",
                         X);
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
