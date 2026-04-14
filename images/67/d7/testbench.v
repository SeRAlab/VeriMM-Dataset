`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] in;
    wire [6:0] HEX;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in(in),
        .HEX(HEX)
    );
    task testcase000;

    begin
        in = 4'd0;
        $display("Testcase 000: Input 0");
        #1;

        check_outputs(7'h3f);
    end
        endtask

    task testcase001;

    begin
        in = 4'd1;
        $display("Testcase 001: Input 1");
        #1;

        check_outputs(7'h06);
    end
        endtask

    task testcase002;

    begin
        in = 4'd2;
        $display("Testcase 002: Input 2");
        #1;

        check_outputs(7'h5b);
    end
        endtask

    task testcase003;

    begin
        in = 4'd3;
        $display("Testcase 003: Input 3");
        #1;

        check_outputs(7'h4f);
    end
        endtask

    task testcase004;

    begin
        in = 4'd4;
        $display("Testcase 004: Input 4");
        #1;

        check_outputs(7'h66);
    end
        endtask

    task testcase005;

    begin
        in = 4'd5;
        $display("Testcase 005: Input 5");
        #1;

        check_outputs(7'h6d);
    end
        endtask

    task testcase006;

    begin
        in = 4'd6;
        $display("Testcase 006: Input 6");
        #1;

        check_outputs(7'h7d);
    end
        endtask

    task testcase007;

    begin
        in = 4'd7;
        $display("Testcase 007: Input 7");
        #1;

        check_outputs(7'h07);
    end
        endtask

    task testcase008;

    begin
        in = 4'd8;
        $display("Testcase 008: Input 8");
        #1;

        check_outputs(7'h7f);
    end
        endtask

    task testcase009;

    begin
        in = 4'd9;
        $display("Testcase 009: Input 9");
        #1;

        check_outputs(7'h6f);
    end
        endtask

    task testcase010;

    begin
        in = 4'd10;
        $display("Testcase 010: Input 10 (Blank)");
        #1;

        check_outputs(7'h00);
    end
        endtask

    task testcase011;

    begin
        in = 4'd11;
        $display("Testcase 011: Input 11 (Blank)");
        #1;

        check_outputs(7'h00);
    end
        endtask

    task testcase012;

    begin
        in = 4'd12;
        $display("Testcase 012: Input 12 (Blank)");
        #1;

        check_outputs(7'h00);
    end
        endtask

    task testcase013;

    begin
        in = 4'd13;
        $display("Testcase 013: Input 13 (Blank)");
        #1;

        check_outputs(7'h00);
    end
        endtask

    task testcase014;

    begin
        in = 4'd14;
        $display("Testcase 014: Input 14 (Blank)");
        #1;

        check_outputs(7'h00);
    end
        endtask

    task testcase015;

    begin
        in = 4'd15;
        $display("Testcase 015: Input 15 (Blank)");
        #1;

        check_outputs(7'h00);
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


        testcase000();
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
        input [6:0] expected_HEX;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_HEX === (expected_HEX ^ HEX ^ expected_HEX)) begin
                $display("PASS");
                $display("  Outputs: HEX=%h",
                         HEX);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: HEX=%h",
                         expected_HEX);
                $display("  Got:      HEX=%h",
                         HEX);
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
