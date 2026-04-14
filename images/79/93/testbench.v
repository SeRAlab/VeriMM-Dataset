`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    wire C;
    wire [3:0] S;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .C(C),
        .S(S)
    );
    task testcase001;

    begin
        A = 4'd0; B = 4'd0;
        $display("Test Case 001: 0 + 0");
        #1;

        check_outputs(1'b0, 4'd0);
    end
        endtask

    task testcase002;

    begin
        A = 4'd1; B = 4'd1;
        $display("Test Case 002: 1 + 1");
        #1;

        check_outputs(1'b0, 4'd2);
    end
        endtask

    task testcase003;

    begin
        A = 4'd15; B = 4'd0;
        $display("Test Case 003: 15 + 0");
        #1;

        check_outputs(1'b0, 4'd15);
    end
        endtask

    task testcase004;

    begin
        A = 4'd15; B = 4'd1;
        $display("Test Case 004: 15 + 1 (Boundary Carry)");
        #1;

        check_outputs(1'b1, 4'd0);
    end
        endtask

    task testcase005;

    begin
        A = 4'd15; B = 4'd15;
        $display("Test Case 005: 15 + 15 (Max Inputs)");
        #1;

        check_outputs(1'b1, 4'd14);
    end
        endtask

    task testcase006;

    begin
        A = 4'd5; B = 4'd7;
        $display("Test Case 006: 5 + 7");
        #1;

        check_outputs(1'b0, 4'd12);
    end
        endtask

    task testcase007;

    begin
        A = 4'd10; B = 4'd6;
        $display("Test Case 007: 10 + 6 (Carry at 16)");
        #1;

        check_outputs(1'b1, 4'd0);
    end
        endtask

    task testcase008;

    begin
        A = 4'd9; B = 4'd8;
        $display("Test Case 008: 9 + 8");
        #1;

        check_outputs(1'b1, 4'd1);
    end
        endtask

    task testcase009;

    begin
        A = 4'd12; B = 4'd13;
        $display("Test Case 009: 12 + 13");
        #1;

        check_outputs(1'b1, 4'd9);
    end
        endtask

    task testcase010;

    begin
        A = 4'b1010; B = 4'b0101;
        $display("Test Case 010: Alternating Bits (10 + 5)");
        #1;

        check_outputs(1'b0, 4'b1111);
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
        input expected_C;
        input [3:0] expected_S;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_C === (expected_C ^ C ^ expected_C) &&
                expected_S === (expected_S ^ S ^ expected_S)) begin
                $display("PASS");
                $display("  Outputs: C=%b, S=%h",
                         C, S);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: C=%b, S=%h",
                         expected_C, expected_S);
                $display("  Got:      C=%b, S=%h",
                         C, S);
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
