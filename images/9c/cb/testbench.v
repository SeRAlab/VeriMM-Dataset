`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg [3:0] C;
    reg [1:0] op;
    wire [3:0] Z;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .C(C),
        .op(op),
        .Z(Z)
    );
    task testcase001;

        begin
            test_num = 1;
            A = 4'd5; B = 4'd3; C = 4'd0; op = 2'b00;
            $display("Test Case %0d: Addition (5 + 3)", test_num);
            #1;

            check_outputs(4'd8);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            A = 4'd12; B = 4'd7; C = 4'd0; op = 2'b00;
            $display("Test Case %0d: Addition with Overflow (12 + 7)", test_num);
            #1;

            check_outputs(4'd3);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            A = 4'd10; B = 4'd4; C = 4'd0; op = 2'b01;
            $display("Test Case %0d: Subtraction (10 - 4)", test_num);
            #1;

            check_outputs(4'd6);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            A = 4'd2; B = 4'd5; C = 4'd0; op = 2'b01;
            $display("Test Case %0d: Subtraction with Underflow (2 - 5)", test_num);
            #1;

            check_outputs(4'd13);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            A = 4'b1010; B = 4'b1100; C = 4'd0; op = 2'b10;
            $display("Test Case %0d: Bitwise AND (1010 & 1100)", test_num);
            #1;

            check_outputs(4'b1000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            A = 4'b1111; B = 4'b0000; C = 4'd0; op = 2'b10;
            $display("Test Case %0d: Bitwise AND (1111 & 0000)", test_num);
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            A = 4'b1010; B = 4'b0101; C = 4'd0; op = 2'b11;
            $display("Test Case %0d: Bitwise OR (1010 | 0101)", test_num);
            #1;

            check_outputs(4'b1111);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            A = 4'b0011; B = 4'b0110; C = 4'd0; op = 2'b11;
            $display("Test Case %0d: Bitwise OR (0011 | 0110)", test_num);
            #1;

            check_outputs(4'b0111);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            A = 4'd15; B = 4'd1; C = 4'd0; op = 2'b00;
            $display("Test Case %0d: Addition Max Boundary (15 + 1)", test_num);
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            A = 4'd0; B = 4'd0; C = 4'd0; op = 2'b01;
            $display("Test Case %0d: Subtraction Zero (0 - 0)", test_num);
            #1;

            check_outputs(4'd0);
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
        input [3:0] expected_Z;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Z === (expected_Z ^ Z ^ expected_Z)) begin
                $display("PASS");
                $display("  Outputs: Z=%h",
                         Z);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Z=%h",
                         expected_Z);
                $display("  Got:      Z=%h",
                         Z);
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
