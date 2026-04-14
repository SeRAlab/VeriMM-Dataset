`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg Cin;
    reg [3:0] S;
    wire Cout;
    wire [3:0] F;
    wire X;
    wire Y;
    wire Z;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .Cin(Cin),
        .S(S),
        .Cout(Cout),
        .F(F),
        .X(X),
        .Y(Y),
        .Z(Z)
    );
    task testcase001;

        begin
            $display("Testcase 001: Addition without Carry-In (2 + 3)");
            A = 4'd2; B = 4'd3; S = 4'b1001; Cin = 1'b0;


            #1;



            check_outputs(1'b0, 4'd5, 1'b1, 1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Addition with Carry-In (7 + 1 + 1)");
            A = 4'd7; B = 4'd1; S = 4'b1001; Cin = 1'b1;


            #1;



            check_outputs(1'b0, 4'd9, 1'b1, 1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Addition with Carry-Out (15 + 1)");
            A = 4'd15; B = 4'd1; S = 4'b1001; Cin = 1'b0;


            #1;



            check_outputs(1'b1, 4'd0, 1'b0, 1'b1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Subtraction A - B (10 - 4)");

            A = 4'd10; B = 4'd4; S = 4'b0110; Cin = 1'b1;

            #1;


            check_outputs(1'b1, 4'd6, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Transfer A (Pass-through)");

            A = 4'd12; B = 4'd0; S = 4'b1111; Cin = 1'b0;

            #1;


            check_outputs(1'b0, 4'd12, 1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Maximum values roll-over (15 + 15 + 1)");
            A = 4'd15; B = 4'd15; S = 4'b1001; Cin = 1'b1;

            #1;


            check_outputs(1'b1, 4'd15, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Zero flag check with Addition");
            A = 4'd0; B = 4'd0; S = 4'b1001; Cin = 1'b0;

            #1;


            check_outputs(1'b0, 4'd0, 1'b1, 1'b1, 1'b1);
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
        input expected_Cout;
        input [3:0] expected_F;
        input expected_X;
        input expected_Y;
        input expected_Z;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Cout === (expected_Cout ^ Cout ^ expected_Cout) &&
                expected_F === (expected_F ^ F ^ expected_F) &&
                expected_X === (expected_X ^ X ^ expected_X) &&
                expected_Y === (expected_Y ^ Y ^ expected_Y) &&
                expected_Z === (expected_Z ^ Z ^ expected_Z)) begin
                $display("PASS");
                $display("  Outputs: Cout=%b, F=%h, X=%b, Y=%b, Z=%b",
                         Cout, F, X, Y, Z);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Cout=%b, F=%h, X=%b, Y=%b, Z=%b",
                         expected_Cout, expected_F, expected_X, expected_Y, expected_Z);
                $display("  Got:      Cout=%b, F=%h, X=%b, Y=%b, Z=%b",
                         Cout, F, X, Y, Z);
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
