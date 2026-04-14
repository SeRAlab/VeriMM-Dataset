`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] inValue;
    wire [6:0] display;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .inValue(inValue),
        .display(display)
    );
    task testcase001;

        begin
            $display("Testcase 001: Value 0 (0x3F)");
            inValue = 4'h0;
            #1;

            check_outputs(7'h3f);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Value 1 (0x06)");
            inValue = 4'h1;
            #1;

            check_outputs(7'h06);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Value 2 (0x5B)");
            inValue = 4'h2;
            #1;

            check_outputs(7'h5b);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Value 3 (0x4F)");
            inValue = 4'h3;
            #1;

            check_outputs(7'h4f);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Value 4 (0x66)");
            inValue = 4'h4;
            #1;

            check_outputs(7'h66);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Value 5 (0x6D)");
            inValue = 4'h5;
            #1;

            check_outputs(7'h6d);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Value 6 (0x7D)");
            inValue = 4'h6;
            #1;

            check_outputs(7'h7d);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: Value 7 (0x07)");
            inValue = 4'h7;
            #1;

            check_outputs(7'h07);
        end
        endtask

    task testcase009;

        begin
            $display("Testcase 009: Value 8 (0x7F)");
            inValue = 4'h8;
            #1;

            check_outputs(7'h7f);
        end
        endtask

    task testcase010;

        begin
            $display("Testcase 010: Value 9 (0x6F)");
            inValue = 4'h9;
            #1;

            check_outputs(7'h6f);
        end
        endtask

    task testcase011;

        begin
            $display("Testcase 011: Value A (0x77)");
            inValue = 4'hA;
            #1;

            check_outputs(7'h77);
        end
        endtask

    task testcase012;

        begin
            $display("Testcase 012: Value B (0x7C)");
            inValue = 4'hB;
            #1;

            check_outputs(7'h7c);
        end
        endtask

    task testcase013;

        begin
            $display("Testcase 013: Value C (0x39)");
            inValue = 4'hC;
            #1;

            check_outputs(7'h39);
        end
        endtask

    task testcase014;

        begin
            $display("Testcase 014: Value D (0x5E)");
            inValue = 4'hD;
            #1;

            check_outputs(7'h5e);
        end
        endtask

    task testcase015;

        begin
            $display("Testcase 015: Value E (0x79)");
            inValue = 4'hE;
            #1;

            check_outputs(7'h79);
        end
        endtask

    task testcase016;

        begin
            $display("Testcase 016: Value F (0x71)");
            inValue = 4'hF;
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
