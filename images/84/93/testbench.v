`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg w;
    reg x;
    reg y;
    reg z;
    wire k_pos;
    wire k_sop;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .w(w),
        .x(x),
        .y(y),
        .z(z),
        .k_pos(k_pos),
        .k_sop(k_sop)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case 001: Input 0 (0000)");
        {x, y, z, w} = 4'd0;
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case 002: Input 1 (0001)");
        {x, y, z, w} = 4'd1;
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case 003: Input 2 (0010)");
        {x, y, z, w} = 4'd2;
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case 004: Input 3 (0011)");
        {x, y, z, w} = 4'd3;
        #1;

        check_outputs(1'b1, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case 005: Input 4 (0100)");
        {x, y, z, w} = 4'd4;
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case 006: Input 5 (0101)");
        {x, y, z, w} = 4'd5;
        #1;

        check_outputs(1'b1, 1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case 007: Input 6 (0110)");
        {x, y, z, w} = 4'd6;
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test Case 008: Input 7 (0111)");
        {x, y, z, w} = 4'd7;
        #1;

        check_outputs(1'b1, 1'b1);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test Case 009: Input 8 (1000)");
        {x, y, z, w} = 4'd8;
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Test Case 010: Input 9 (1001)");
        {x, y, z, w} = 4'd9;
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase011;

    begin
        test_num = 11;
        $display("Test Case 011: Input 10 (1010)");
        {x, y, z, w} = 4'd10;
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase012;

    begin
        test_num = 12;
        $display("Test Case 012: Input 11 (1011)");
        {x, y, z, w} = 4'd11;
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase013;

    begin
        test_num = 13;
        $display("Test Case 013: Input 12 (1100)");
        {x, y, z, w} = 4'd12;
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase014;

    begin
        test_num = 14;
        $display("Test Case 014: Input 13 (1101)");
        {x, y, z, w} = 4'd13;
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase015;

    begin
        test_num = 15;
        $display("Test Case 015: Input 14 (1110)");
        {x, y, z, w} = 4'd14;
        #1;

        check_outputs(1'b1, 1'b1);
    end
        endtask

    task testcase016;

    begin
        test_num = 16;
        $display("Test Case 016: Input 15 (1111)");
        {x, y, z, w} = 4'd15;
        #1;

        check_outputs(1'b0, 1'b0);
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
        input expected_k_pos;
        input expected_k_sop;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_k_pos === (expected_k_pos ^ k_pos ^ expected_k_pos) &&
                expected_k_sop === (expected_k_sop ^ k_sop ^ expected_k_sop)) begin
                $display("PASS");
                $display("  Outputs: k_pos=%b, k_sop=%b",
                         k_pos, k_sop);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: k_pos=%b, k_sop=%b",
                         expected_k_pos, expected_k_sop);
                $display("  Got:      k_pos=%b, k_sop=%b",
                         k_pos, k_sop);
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
