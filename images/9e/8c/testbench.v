`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] in;
    wire [2:0] pos;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in(in),
        .pos(pos)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case 001: No bits active");
            in = 8'b0000_0000;
            #1;

            check_outputs(3'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case 002: Bit 0 is the highest active bit");
            in = 8'b0000_0001;
            #1;

            check_outputs(3'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case 003: Bit 7 is the highest active bit");
            in = 8'b1000_0000;
            #1;

            check_outputs(3'd7);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case 004: Bit 4 is the highest active bit (single bit)");
            in = 8'b0001_0000;
            #1;

            check_outputs(3'd4);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case 005: Multiple bits active (Bits 0 and 1, expect 1)");
            in = 8'b0000_0011;
            #1;

            check_outputs(3'd1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case 006: Multiple bits active (Bits 0, 2, 4, expect 4)");
            in = 8'b0001_0101;
            #1;

            check_outputs(3'd4);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case 007: Multiple bits active (Bits 5, 6, expect 6)");
            in = 8'b0110_0000;
            #1;

            check_outputs(3'd6);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test Case 008: All bits active (expect 7)");
            in = 8'b1111_1111;
            #1;

            check_outputs(3'd7);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test Case 009: Dense lower bits, one high bit (expect 5)");
            in = 8'b0010_1111;
            #1;

            check_outputs(3'd5);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Test Case 010: Alternating bits (expect 7)");
            in = 8'b1010_1010;
            #1;

            check_outputs(3'd7);
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
        input [2:0] expected_pos;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_pos === (expected_pos ^ pos ^ expected_pos)) begin
                $display("PASS");
                $display("  Outputs: pos=%h",
                         pos);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: pos=%h",
                         expected_pos);
                $display("  Got:      pos=%h",
                         pos);
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
