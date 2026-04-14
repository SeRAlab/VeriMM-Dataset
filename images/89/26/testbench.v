`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] op0;
    reg [31:0] op1;
    reg [31:0] op2;
    reg [31:0] op3;
    reg [1:0] select;
    wire [31:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .op0(op0),
        .op1(op1),
        .op2(op2),
        .op3(op3),
        .select(select),
        .result(result)
    );
    task testcase001;

        begin
            $display("Test Case 001: Select op0");
            op0 = 32'hAAAA_AAAA;
            op1 = 32'h1111_1111;
            op2 = 32'h2222_2222;
            op3 = 32'h3333_3333;
            select = 2'b00;
            #1;

            check_outputs(32'hAAAA_AAAA);
        end
        endtask

    task testcase002;

        begin
            $display("Test Case 002: Select op1");
            op0 = 32'h0000_0000;
            op1 = 32'hBBBB_BBBB;
            op2 = 32'h4444_4444;
            op3 = 32'h5555_5555;
            select = 2'b01;
            #1;

            check_outputs(32'hBBBB_BBBB);
        end
        endtask

    task testcase003;

        begin
            $display("Test Case 003: Select op2");
            op0 = 32'h6666_6666;
            op1 = 32'h7777_7777;
            op2 = 32'hCCCC_CCCC;
            op3 = 32'h8888_8888;
            select = 2'b10;
            #1;

            check_outputs(32'hCCCC_CCCC);
        end
        endtask

    task testcase004;

        begin
            $display("Test Case 004: Select op3");
            op0 = 32'h9999_9999;
            op1 = 32'hAAAA_AAAA;
            op2 = 32'hBBBB_BBBB;
            op3 = 32'hDDDD_DDDD;
            select = 2'b11;
            #1;

            check_outputs(32'hDDDD_DDDD);
        end
        endtask

    task testcase005;

        begin
            $display("Test Case 005: Boundary test - Select op0 (All Fs)");
            op0 = 32'hFFFF_FFFF;
            op1 = 32'h0000_0000;
            op2 = 32'h0000_0000;
            op3 = 32'h0000_0000;
            select = 2'b00;
            #1;

            check_outputs(32'hFFFF_FFFF);
        end
        endtask

    task testcase006;

        begin
            $display("Test Case 006: Boundary test - Select op3 (Zeros)");
            op0 = 32'hFFFF_FFFF;
            op1 = 32'hFFFF_FFFF;
            op2 = 32'hFFFF_FFFF;
            op3 = 32'h0000_0000;
            select = 2'b11;
            #1;

            check_outputs(32'h0000_0000);
        end
        endtask

    task testcase007;

        begin
            $display("Test Case 007: Sequential selection check");
            op0 = 32'h5555_5555;
            op1 = 32'hAAAA_AAAA;
            op2 = 32'hF0F0_F0F0;
            op3 = 32'h0F0F_0F0F;

            select = 2'b00; #1;
 check_outputs(32'h5555_5555);
            select = 2'b01; #1;
 check_outputs(32'hAAAA_AAAA);
            select = 2'b10; #1;
 check_outputs(32'hF0F0_F0F0);
            select = 2'b11; #1;
 check_outputs(32'h0F0F_0F0F);
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
        input [31:0] expected_result;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: result=%h",
                         result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: result=%h",
                         expected_result);
                $display("  Got:      result=%h",
                         result);
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
