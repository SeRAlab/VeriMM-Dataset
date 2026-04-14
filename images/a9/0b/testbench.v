`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg w;
    reg x;
    reg y;
    reg z;
    wire e_pos;
    wire e_sop;

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
        .e_pos(e_pos),
        .e_sop(e_sop)
    );
    task testcase001;

        begin
            {x, y, z, w} = 4'd0;
            $display("Test Case 001: Input 0 (0000)");
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase002;

        begin
            {x, y, z, w} = 4'd1;
            $display("Test Case 002: Input 1 (0001)");
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            {x, y, z, w} = 4'd2;
            $display("Test Case 003: Input 2 (0010)");
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            {x, y, z, w} = 4'd3;
            $display("Test Case 004: Input 3 (0011)");
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            {x, y, z, w} = 4'd4;
            $display("Test Case 005: Input 4 (0100)");
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            {x, y, z, w} = 4'd5;
            $display("Test Case 006: Input 5 (0101)");
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase007;

        begin
            {x, y, z, w} = 4'd6;
            $display("Test Case 007: Input 6 (0110)");
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase008;

        begin
            {x, y, z, w} = 4'd7;
            $display("Test Case 008: Input 7 (0111)");
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase009;

        begin
            {x, y, z, w} = 4'd8;
            $display("Test Case 009: Input 8 (1000)");
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase010;

        begin
            {x, y, z, w} = 4'd9;
            $display("Test Case 010: Input 9 (1001)");
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase011;

        begin
            {x, y, z, w} = 4'd10;
            $display("Test Case 011: Input 10 (1010)");
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase012;

        begin
            {x, y, z, w} = 4'd11;
            $display("Test Case 012: Input 11 (1011)");
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase013;

        begin
            {x, y, z, w} = 4'd12;
            $display("Test Case 013: Input 12 (1100)");
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase014;

        begin
            {x, y, z, w} = 4'd13;
            $display("Test Case 014: Input 13 (1101)");
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase015;

        begin
            {x, y, z, w} = 4'd14;
            $display("Test Case 015: Input 14 (1110)");
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase016;

        begin
            {x, y, z, w} = 4'd15;
            $display("Test Case 016: Input 15 (1111)");
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
        input expected_e_pos;
        input expected_e_sop;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_e_pos === (expected_e_pos ^ e_pos ^ expected_e_pos) &&
                expected_e_sop === (expected_e_sop ^ e_sop ^ expected_e_sop)) begin
                $display("PASS");
                $display("  Outputs: e_pos=%b, e_sop=%b",
                         e_pos, e_sop);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: e_pos=%b, e_sop=%b",
                         expected_e_pos, expected_e_sop);
                $display("  Got:      e_pos=%b, e_sop=%b",
                         e_pos, e_sop);
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
