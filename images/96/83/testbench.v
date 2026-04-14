`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] condition;
    reg [31:0] data_0;
    reg [31:0] data_1;
    reg [31:0] data_2;
    reg [31:0] data_3;
    reg [31:0] data_4;
    reg [31:0] data_5;
    reg [31:0] data_6;
    reg [31:0] data_7;
    wire [31:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .condition(condition),
        .data_0(data_0),
        .data_1(data_1),
        .data_2(data_2),
        .data_3(data_3),
        .data_4(data_4),
        .data_5(data_5),
        .data_6(data_6),
        .data_7(data_7),
        .data_out(data_out)
    );
    task testcase001;

        begin
            $display("Test Case 001: Selecting data_0");
            condition = 3'd0;
            data_0 = 32'hAAAA_0000; data_1 = 32'hBBBB_1111; data_2 = 32'hCCCC_2222; data_3 = 32'hDDDD_3333;
            data_4 = 32'hEEEE_4444; data_5 = 32'hFFFF_5555; data_6 = 32'h0000_6666; data_7 = 32'h1111_7777;
            #1;

            check_outputs(data_0);
        end
        endtask

    task testcase002;

        begin
            $display("Test Case 002: Selecting data_1");
            condition = 3'd1;
            data_0 = 32'hAAAA_0000; data_1 = 32'hBBBB_1111; data_2 = 32'hCCCC_2222; data_3 = 32'hDDDD_3333;
            data_4 = 32'hEEEE_4444; data_5 = 32'hFFFF_5555; data_6 = 32'h0000_6666; data_7 = 32'h1111_7777;
            #1;

            check_outputs(data_1);
        end
        endtask

    task testcase003;

        begin
            $display("Test Case 003: Selecting data_2");
            condition = 3'd2;
            data_0 = 32'hAAAA_0000; data_1 = 32'hBBBB_1111; data_2 = 32'hCCCC_2222; data_3 = 32'hDDDD_3333;
            data_4 = 32'hEEEE_4444; data_5 = 32'hFFFF_5555; data_6 = 32'h0000_6666; data_7 = 32'h1111_7777;
            #1;

            check_outputs(data_2);
        end
        endtask

    task testcase004;

        begin
            $display("Test Case 004: Selecting data_3");
            condition = 3'd3;
            data_0 = 32'hAAAA_0000; data_1 = 32'hBBBB_1111; data_2 = 32'hCCCC_2222; data_3 = 32'hDDDD_3333;
            data_4 = 32'hEEEE_4444; data_5 = 32'hFFFF_5555; data_6 = 32'h0000_6666; data_7 = 32'h1111_7777;
            #1;

            check_outputs(data_3);
        end
        endtask

    task testcase005;

        begin
            $display("Test Case 005: Selecting data_4");
            condition = 3'd4;
            data_0 = 32'hAAAA_0000; data_1 = 32'hBBBB_1111; data_2 = 32'hCCCC_2222; data_3 = 32'hDDDD_3333;
            data_4 = 32'hEEEE_4444; data_5 = 32'hFFFF_5555; data_6 = 32'h0000_6666; data_7 = 32'h1111_7777;
            #1;

            check_outputs(data_4);
        end
        endtask

    task testcase006;

        begin
            $display("Test Case 006: Selecting data_5");
            condition = 3'd5;
            data_0 = 32'hAAAA_0000; data_1 = 32'hBBBB_1111; data_2 = 32'hCCCC_2222; data_3 = 32'hDDDD_3333;
            data_4 = 32'hEEEE_4444; data_5 = 32'hFFFF_5555; data_6 = 32'h0000_6666; data_7 = 32'h1111_7777;
            #1;

            check_outputs(data_5);
        end
        endtask

    task testcase007;

        begin
            $display("Test Case 007: Selecting data_6");
            condition = 3'd6;
            data_0 = 32'hAAAA_0000; data_1 = 32'hBBBB_1111; data_2 = 32'hCCCC_2222; data_3 = 32'hDDDD_3333;
            data_4 = 32'hEEEE_4444; data_5 = 32'hFFFF_5555; data_6 = 32'h0000_6666; data_7 = 32'h1111_7777;
            #1;

            check_outputs(data_6);
        end
        endtask

    task testcase008;

        begin
            $display("Test Case 008: Selecting data_7");
            condition = 3'd7;
            data_0 = 32'hAAAA_0000; data_1 = 32'hBBBB_1111; data_2 = 32'hCCCC_2222; data_3 = 32'hDDDD_3333;
            data_4 = 32'hEEEE_4444; data_5 = 32'hFFFF_5555; data_6 = 32'h0000_6666; data_7 = 32'h1111_7777;
            #1;

            check_outputs(data_7);
        end
        endtask

    task testcase009;

        begin
            $display("Test Case 009: Combinational change of input data");
            condition = 3'd3;
            data_3 = 32'h1234_5678;
            #1;

            check_outputs(32'h1234_5678);
        end
        endtask

    task testcase010;

        begin
            $display("Test Case 010: Edge values (All Fs and All 0s)");
            condition = 3'd5;
            data_5 = 32'hFFFF_FFFF;
            #1;

            check_outputs(32'hFFFF_FFFF);
            condition = 3'd2;
            data_2 = 32'h0000_0000;
            #1;

            check_outputs(32'h0000_0000);
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
        input [31:0] expected_data_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h",
                         expected_data_out);
                $display("  Got:      data_out=%h",
                         data_out);
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
