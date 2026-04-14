`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg A1;
    reg A2;
    reg A3;
    reg A4;
    wire [3:0] Y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A1(A1),
        .A2(A2),
        .A3(A3),
        .A4(A4),
        .Y(Y)
    );
    task testcase001;

    begin
        test_num = 1;
        A1 = 0; A2 = 0; A3 = 0; A4 = 0;
        $display("Test Case 001: Input A1-A4 = 0000");
        #1;

        check_outputs(4'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        A1 = 0; A2 = 0; A3 = 0; A4 = 1;
        $display("Test Case 002: Input A1-A4 = 0001");
        #1;

        check_outputs(4'd1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        A1 = 0; A2 = 0; A3 = 1; A4 = 0;
        $display("Test Case 003: Input A1-A4 = 0010");
        #1;

        check_outputs(4'd2);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        A1 = 0; A2 = 0; A3 = 1; A4 = 1;
        $display("Test Case 004: Input A1-A4 = 0011");
        #1;

        check_outputs(4'd3);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        A1 = 0; A2 = 1; A3 = 0; A4 = 0;
        $display("Test Case 005: Input A1-A4 = 0100");
        #1;

        check_outputs(4'd4);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        A1 = 0; A2 = 1; A3 = 0; A4 = 1;
        $display("Test Case 006: Input A1-A4 = 0101");
        #1;

        check_outputs(4'd5);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        A1 = 0; A2 = 1; A3 = 1; A4 = 0;
        $display("Test Case 007: Input A1-A4 = 0110");
        #1;

        check_outputs(4'd6);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        A1 = 0; A2 = 1; A3 = 1; A4 = 1;
        $display("Test Case 008: Input A1-A4 = 0111");
        #1;

        check_outputs(4'd7);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        A1 = 1; A2 = 0; A3 = 0; A4 = 0;
        $display("Test Case 009: Input A1-A4 = 1000");
        #1;

        check_outputs(4'd8);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        A1 = 1; A2 = 0; A3 = 0; A4 = 1;
        $display("Test Case 010: Input A1-A4 = 1001");
        #1;

        check_outputs(4'd9);
    end
        endtask

    task testcase011;

    begin
        test_num = 11;
        A1 = 1; A2 = 0; A3 = 1; A4 = 0;
        $display("Test Case 011: Input A1-A4 = 1010");
        #1;

        check_outputs(4'd10);
    end
        endtask

    task testcase012;

    begin
        test_num = 12;
        A1 = 1; A2 = 0; A3 = 1; A4 = 1;
        $display("Test Case 012: Input A1-A4 = 1011");
        #1;

        check_outputs(4'd11);
    end
        endtask

    task testcase013;

    begin
        test_num = 13;
        A1 = 1; A2 = 1; A3 = 0; A4 = 0;
        $display("Test Case 013: Input A1-A4 = 1100");
        #1;

        check_outputs(4'd12);
    end
        endtask

    task testcase014;

    begin
        test_num = 14;
        A1 = 1; A2 = 1; A3 = 0; A4 = 1;
        $display("Test Case 014: Input A1-A4 = 1101");
        #1;

        check_outputs(4'd13);
    end
        endtask

    task testcase015;

    begin
        test_num = 15;
        A1 = 1; A2 = 1; A3 = 1; A4 = 0;
        $display("Test Case 015: Input A1-A4 = 1110");
        #1;

        check_outputs(4'd14);
    end
        endtask

    task testcase016;

    begin
        test_num = 16;
        A1 = 1; A2 = 1; A3 = 1; A4 = 1;
        $display("Test Case 016: Input A1-A4 = 1111");
        #1;

        check_outputs(4'd15);
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
        testcase013();
        testcase014();
        testcase015();
        testcase016();
        
        
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
        input [3:0] expected_Y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Y === (expected_Y ^ Y ^ expected_Y)) begin
                $display("PASS");
                $display("  Outputs: Y=%h",
                         Y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Y=%h",
                         expected_Y);
                $display("  Got:      Y=%h",
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
