`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg [2:0] op;
    wire [3:0] Z;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .op(op),
        .Z(Z)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            A = 4'd5;
            B = 4'd3;
            op = 3'b000;
            $display("Test %0d: Addition (5 + 3)", test_num);
            #1;

            check_outputs(4'd8);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            A = 4'd12;
            B = 4'd7;
            op = 3'b000;
            $display("Test %0d: Addition with Overflow (12 + 7 = 19 -> 3)", test_num);
            #1;

            check_outputs(4'd3);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            A = 4'd10;
            B = 4'd4;
            op = 3'b001;
            $display("Test %0d: Subtraction (10 - 4)", test_num);
            #1;

            check_outputs(4'd6);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            A = 4'd2;
            B = 4'd5;
            op = 3'b001;
            $display("Test %0d: Subtraction with Underflow (2 - 5 = -3 -> 13)", test_num);
            #1;

            check_outputs(4'd13);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            A = 4'b1100;
            B = 4'b1010;
            op = 3'b010;
            $display("Test %0d: Bitwise AND (1100 & 1010)", test_num);
            #1;

            check_outputs(4'b1000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            A = 4'b1100;
            B = 4'b1010;
            op = 3'b011;
            $display("Test %0d: Bitwise OR (1100 | 1010)", test_num);
            #1;

            check_outputs(4'b1110);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            A = 4'b1100;
            B = 4'b1010;
            op = 3'b100;
            $display("Test %0d: Bitwise XOR (1100 ^ 1010)", test_num);
            #1;

            check_outputs(4'b0110);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            A = 4'b1010;
            B = 4'b0000;
            op = 3'b101;
            $display("Test %0d: Bitwise NOT (~1010)", test_num);
            #1;

            check_outputs(4'b0101);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            A = 4'b1111;
            B = 4'b1111;
            op = 3'b110;
            $display("Test %0d: Invalid Operation (op=110)", test_num);
            #1;

            check_outputs(4'bxxxx);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            A = 4'b0000;
            B = 4'b0000;
            op = 3'b111;
            $display("Test %0d: Invalid Operation (op=111)", test_num);
            #1;

            check_outputs(4'bxxxx);
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
