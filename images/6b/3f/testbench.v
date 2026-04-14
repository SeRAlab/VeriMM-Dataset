`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg CIN;
    wire COUT;
    wire [3:0] S;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .CIN(CIN),
        .COUT(COUT),
        .S(S)
    );
    task testcase001;

        begin
            $display("\nTestcase 001: All zeros (0 + 0 + 0)");
            A = 4'd0; B = 4'd0; CIN = 0;
            #1;

            check_outputs(0, 4'd0);
        end
        endtask

    task testcase002;

        begin
            $display("\nTestcase 002: Minimum Carry-In (0 + 0 + 1)");
            A = 4'd0; B = 4'd0; CIN = 1;
            #1;

            check_outputs(0, 4'd1);
        end
        endtask

    task testcase003;

        begin
            $display("\nTestcase 003: Simple addition without carry (5 + 3 + 0)");
            A = 4'd5; B = 4'd3; CIN = 0;
            #1;

            check_outputs(0, 4'd8);
        end
        endtask

    task testcase004;

        begin
            $display("\nTestcase 004: Addition with internal carry propagation (7 + 1 + 0)");
            A = 4'b0111; B = 4'b0001; CIN = 0;
            #1;

            check_outputs(0, 4'b1000);
        end
        endtask

    task testcase005;

        begin
            $display("\nTestcase 005: Maximum sum without carry-out (15 + 0 + 0)");
            A = 4'hF; B = 4'h0; CIN = 0;
            #1;

            check_outputs(0, 4'hF);
        end
        endtask

    task testcase006;

        begin
            $display("\nTestcase 006: Carry-out generation (15 + 1 + 0)");
            A = 4'hF; B = 4'h1; CIN = 0;
            #1;

            check_outputs(1, 4'h0);
        end
        endtask

    task testcase007;

        begin
            $display("\nTestcase 007: Carry-out with CIN (15 + 0 + 1)");
            A = 4'hF; B = 4'h0; CIN = 1;
            #1;

            check_outputs(1, 4'h0);
        end
        endtask

    task testcase008;

        begin
            $display("\nTestcase 008: Alternating bits (10 + 5 + 0)");
            A = 4'b1010; B = 4'b0101; CIN = 0;
            #1;

            check_outputs(0, 4'hF);
        end
        endtask

    task testcase009;

        begin
            $display("\nTestcase 009: Full sum (15 + 15 + 1)");
            A = 4'hF; B = 4'hF; CIN = 1;
            #1;

            check_outputs(1, 4'hF);
        end
        endtask

    task testcase010;

        begin
            $display("\nTestcase 010: Mid-range overflow (8 + 8 + 0)");
            A = 4'd8; B = 4'd8; CIN = 0;
            #1;

            check_outputs(1, 4'd0);
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
        input expected_COUT;
        input [3:0] expected_S;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_COUT === (expected_COUT ^ COUT ^ expected_COUT) &&
                expected_S === (expected_S ^ S ^ expected_S)) begin
                $display("PASS");
                $display("  Outputs: COUT=%b, S=%h",
                         COUT, S);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: COUT=%b, S=%h",
                         expected_COUT, expected_S);
                $display("  Got:      COUT=%b, S=%h",
                         COUT, S);
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
