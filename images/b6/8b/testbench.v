`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] x;
    wire [6:0] disp;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .x(x),
        .disp(disp)
    );
    task testcase001;

        begin
            $display("Test Case 001: Input 0");
            x = 4'd0;
            #1;

            check_outputs(7'h3f);
        end
        endtask

    task testcase002;

        begin
            $display("Test Case 002: Input 1");
            x = 4'd1;
            #1;

            check_outputs(7'h06);
        end
        endtask

    task testcase003;

        begin
            $display("Test Case 003: Input 2");
            x = 4'd2;
            #1;

            check_outputs(7'h5b);
        end
        endtask

    task testcase004;

        begin
            $display("Test Case 004: Input 3");
            x = 4'd3;
            #1;

            check_outputs(7'h4f);
        end
        endtask

    task testcase005;

        begin
            $display("Test Case 005: Input 4");
            x = 4'd4;
            #1;

            check_outputs(7'h66);
        end
        endtask

    task testcase006;

        begin
            $display("Test Case 006: Input 5");
            x = 4'd5;
            #1;

            check_outputs(7'h6d);
        end
        endtask

    task testcase007;

        begin
            $display("Test Case 007: Input 6");
            x = 4'd6;
            #1;

            check_outputs(7'h7d);
        end
        endtask

    task testcase008;

        begin
            $display("Test Case 008: Input 7");
            x = 4'd7;
            #1;

            check_outputs(7'h07);
        end
        endtask

    task testcase009;

        begin
            $display("Test Case 009: Input 8");
            x = 4'd8;
            #1;

            check_outputs(7'h7f);
        end
        endtask

    task testcase010;

        begin
            $display("Test Case 010: Input 9");
            x = 4'd9;
            #1;

            check_outputs(7'h6f);
        end
        endtask

    task testcase011;

        begin
            $display("Test Case 011: Input 10 (Pattern A)");
            x = 4'd10;
            #1;

            check_outputs(7'h77);
        end
        endtask

    task testcase012;

        begin
            $display("Test Case 012: Input 11 (Pattern b)");
            x = 4'd11;
            #1;

            check_outputs(7'h7c);
        end
        endtask

    task testcase013;

        begin
            $display("Test Case 013: Input 12 (Pattern C)");
            x = 4'd12;
            #1;

            check_outputs(7'h39);
        end
        endtask

    task testcase014;

        begin
            $display("Test Case 014: Input 13 (Pattern d)");
            x = 4'd13;
            #1;

            check_outputs(7'h5e);
        end
        endtask

    task testcase015;

        begin
            $display("Test Case 015: Input 14 (Pattern E)");
            x = 4'd14;
            #1;

            check_outputs(7'h79);
        end
        endtask

    task testcase016;

        begin
            $display("Test Case 016: Input 15 (Pattern F)");
            x = 4'd15;
            #1;

            check_outputs(7'h71);
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
        input [6:0] expected_disp;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_disp === (expected_disp ^ disp ^ expected_disp)) begin
                $display("PASS");
                $display("  Outputs: disp=%h",
                         disp);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: disp=%h",
                         expected_disp);
                $display("  Got:      disp=%h",
                         disp);
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
