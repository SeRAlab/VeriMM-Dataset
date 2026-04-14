`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg RST;
    wire C_out;
    wire [3:0] S;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .RST(RST),
        .C_out(C_out),
        .S(S)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case 001: 5 + 3 = 8, Carry = 0");

            RST = 1; A = 4'h5; B = 4'h3; #10;

            RST = 0; #10;

            #1;


            check_outputs(1'b0, 4'h8);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case 002: Reset assertion while inputs are active");

            RST = 1; A = 4'hF; B = 4'hF; #10;

            #1;


            check_outputs(1'b0, 4'h0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case 003: 8 + 8 = 0, Carry = 1");

            RST = 1; A = 4'h0; B = 4'h0; #10;

            RST = 0; A = 4'h8; B = 4'h8; #10;

            #1;


            check_outputs(1'b1, 4'h0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case 004: 15 + 15 = 14, Carry = 1");

            RST = 1; A = 4'h0; B = 4'h0; #10;

            RST = 0; A = 4'hF; B = 4'hF; #10;

            #1;


            check_outputs(1'b1, 4'hE);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case 005: 0 + 0 = 0, Carry = 0");

            RST = 1; A = 4'hF; B = 4'hF; #10;

            RST = 0; A = 4'h0; B = 4'h0; #10;

            #1;


            check_outputs(1'b0, 4'h0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case 006: 15 + 1 = 0, Carry = 1");

            RST = 1; A = 4'h0; B = 4'h0; #10;

            RST = 0; A = 4'hF; B = 4'h1; #10;

            #1;


            check_outputs(1'b1, 4'h0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case 007: 7 + 2 = 9, Carry = 0 (Post-reset sequence)");

            RST = 1; A = 4'hA; B = 4'hA; #10;

            RST = 0; #5;

            A = 4'h7; B = 4'h2; #10;

            #1;


            check_outputs(1'b0, 4'h9);
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
        input expected_C_out;
        input [3:0] expected_S;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_C_out === (expected_C_out ^ C_out ^ expected_C_out) &&
                expected_S === (expected_S ^ S ^ expected_S)) begin
                $display("PASS");
                $display("  Outputs: C_out=%b, S=%h",
                         C_out, S);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: C_out=%b, S=%h",
                         expected_C_out, expected_S);
                $display("  Got:      C_out=%b, S=%h",
                         C_out, S);
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
