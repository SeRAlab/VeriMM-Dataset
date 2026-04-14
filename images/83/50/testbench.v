`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] data;
    wire [6:0] display;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .data(data),
        .display(display)
    );
    task testcase001;

        begin
            test_num = 1;
            data = 4'h0;
            $display("Test Case 001: Data = 4'h0 (Digit 0)");
            #1;

            check_outputs(7'h3f);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            data = 4'h1;
            $display("Test Case 002: Data = 4'h1 (Digit 1)");
            #1;

            check_outputs(7'h06);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            data = 4'h2;
            $display("Test Case 003: Data = 4'h2 (Digit 2)");
            #1;

            check_outputs(7'h5b);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            data = 4'h3;
            $display("Test Case 004: Data = 4'h3 (Digit 3)");
            #1;

            check_outputs(7'h4f);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            data = 4'h4;
            $display("Test Case 005: Data = 4'h4 (Digit 4)");
            #1;

            check_outputs(7'h66);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            data = 4'h5;
            $display("Test Case 006: Data = 4'h5 (Digit 5)");
            #1;

            check_outputs(7'h6d);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            data = 4'h6;
            $display("Test Case 007: Data = 4'h6 (Digit 6)");
            #1;

            check_outputs(7'h7d);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            data = 4'h7;
            $display("Test Case 008: Data = 4'h7 (Digit 7)");
            #1;

            check_outputs(7'h07);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            data = 4'h8;
            $display("Test Case 009: Data = 4'h8 (Digit 8)");
            #1;

            check_outputs(7'h7f);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            data = 4'h9;
            $display("Test Case 010: Data = 4'h9 (Digit 9)");
            #1;

            check_outputs(7'h6f);
        end
        endtask

    task testcase011;

        begin
            test_num = 11;
            data = 4'hA;
            $display("Test Case 011: Data = 4'hA (Digit A)");
            #1;

            check_outputs(7'h77);
        end
        endtask

    task testcase012;

        begin
            test_num = 12;
            data = 4'hB;
            $display("Test Case 012: Data = 4'hB (Digit B)");
            #1;

            check_outputs(7'h7c);
        end
        endtask

    task testcase013;

        begin
            test_num = 13;
            data = 4'hC;
            $display("Test Case 013: Data = 4'hC (Digit C)");
            #1;

            check_outputs(7'h39);
        end
        endtask

    task testcase014;

        begin
            test_num = 14;
            data = 4'hD;
            $display("Test Case 014: Data = 4'hD (Digit D)");
            #1;

            check_outputs(7'h5e);
        end
        endtask

    task testcase015;

        begin
            test_num = 15;
            data = 4'hE;
            $display("Test Case 015: Data = 4'hE (Digit E)");
            #1;

            check_outputs(7'h79);
        end
        endtask

    task testcase016;

        begin
            test_num = 16;
            data = 4'hF;
            $display("Test Case 016: Data = 4'hF (Digit F)");
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
        input [6:0] expected_display;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_display === (expected_display ^ display ^ expected_display)) begin
                $display("PASS");
                $display("  Outputs: display=%h",
                         display);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: display=%h",
                         expected_display);
                $display("  Got:      display=%h",
                         display);
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
