`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] a;
    reg [3:0] b;
    reg cin;
    reg [3:0] f;
    wire [7:0] d;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .cin(cin),
        .f(f),
        .d(d)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case 001: Bitwise Negation (~a)");
            a = 4'b1010; b = 4'b0000; cin = 1'b0; f = 4'h0;
            #1;

            check_outputs(8'h05);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case 002: Addition with Carry (a + b + cin)");
            a = 4'd15; b = 4'd1; cin = 1'b1; f = 4'h1;
            #1;

            check_outputs(8'h11);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case 003: Subtraction (a - b)");
            a = 4'd10; b = 4'd4; cin = 1'b0; f = 4'h2;
            #1;

            check_outputs(8'h06);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case 004: Logical AND (a & b)");
            a = 4'b1100; b = 4'b1010; cin = 1'b0; f = 4'h3;
            #1;

            check_outputs(8'h08);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case 005: Logical OR (a | b)");
            a = 4'b1100; b = 4'b1010; cin = 1'b0; f = 4'h4;
            #1;

            check_outputs(8'h0E);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case 006: Logical XOR (a ^ b)");
            a = 4'b1100; b = 4'b1010; cin = 1'b0; f = 4'h5;
            #1;

            check_outputs(8'h06);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case 007: Multiplication (a * b)");
            a = 4'd15; b = 4'd15; cin = 1'b0; f = 4'h6;
            #1;

            check_outputs(8'hE1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case 008: Division (a / b)");
            a = 4'd15; b = 4'd3; cin = 1'b0; f = 4'h7;
            #1;

            check_outputs(8'h05);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case 009: Shift Left (a << 1)");
            a = 4'b0111; b = 4'b0000; cin = 1'b0; f = 4'h8;
            #1;

            check_outputs(8'h0E);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case 010: Shift Right (a >> 1)");
            a = 4'b1000; b = 4'b0000; cin = 1'b0; f = 4'h9;
            #1;

            check_outputs(8'h04);
        end
        endtask

    task testcase011;

        begin
            test_num = test_num + 1;
            $display("Test Case 011: Increment (a + 1)");
            a = 4'd15; b = 4'd0; cin = 1'b0; f = 4'hA;
            #1;

            check_outputs(8'h10);
        end
        endtask

    task testcase012;

        begin
            test_num = test_num + 1;
            $display("Test Case 012: Decrement (a - 1)");
            a = 4'd0; b = 4'd0; cin = 1'b0; f = 4'hB;
            #1;

            check_outputs(8'hFF);
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
        testcase011();
        testcase012();
        
        
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
        input [7:0] expected_d;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_d === (expected_d ^ d ^ expected_d)) begin
                $display("PASS");
                $display("  Outputs: d=%h",
                         d);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: d=%h",
                         expected_d);
                $display("  Got:      d=%h",
                         d);
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
