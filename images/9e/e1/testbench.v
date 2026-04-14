`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [6:0] a;
    reg [6:0] b;
    reg [6:0] c;
    reg [6:0] d;
    reg [5:0] sa;
    reg [5:0] sb;
    reg [5:0] sc;
    reg [5:0] sd;
    wire [6:0] max;
    wire [5:0] state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .c(c),
        .d(d),
        .sa(sa),
        .sb(sb),
        .sc(sc),
        .sd(sd),
        .max(max),
        .state(state)
    );
    task testcase001;

        begin
            $display("Testcase 001: Input 'a' is the maximum");
            a = 7'd100; b = 7'd80; c = 7'd60; d = 7'd40;
            sa = 6'd10; sb = 6'd20; sc = 6'd30; sd = 6'd40;
            #1;

            check_outputs(7'd100, 6'd10);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Input 'b' is the maximum");
            a = 7'd15; b = 7'd120; c = 7'd45; d = 7'd90;
            sa = 6'd5; sb = 6'd15; sc = 6'd25; sd = 6'd35;
            #1;

            check_outputs(7'd120, 6'd15);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Input 'c' is the maximum");
            a = 7'd33; b = 7'd44; c = 7'd127; d = 7'd11;
            sa = 6'd2; sb = 6'd4; sc = 6'd8; sd = 6'd16;
            #1;

            check_outputs(7'd127, 6'd8);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Input 'd' is the maximum");
            a = 7'd0; b = 7'd5; c = 7'd10; d = 7'd15;
            sa = 6'd60; sb = 6'd61; sc = 6'd62; sd = 6'd63;
            #1;

            check_outputs(7'd15, 6'd63);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: All inputs are equal (Tie-break check)");

            a = 7'd50; b = 7'd50; c = 7'd50; d = 7'd50;
            sa = 6'd1; sb = 6'd2; sc = 6'd3; sd = 6'd4;
            #1;

            check_outputs(7'd50, 6'd1);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Large values near limit");
            a = 7'd125; b = 7'd126; c = 7'd124; d = 7'd123;
            sa = 6'd11; sb = 6'd22; sc = 6'd33; sd = 6'd44;
            #1;

            check_outputs(7'd126, 6'd22);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Zero values");
            a = 7'd0; b = 7'd0; c = 7'd0; d = 7'd0;
            sa = 6'd0; sb = 6'd0; sc = 6'd0; sd = 6'd0;
            #1;

            check_outputs(7'd0, 6'd0);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: Two inputs tied for max (b and c)");
            a = 7'd10; b = 7'd99; c = 7'd99; d = 7'd10;
            sa = 6'd5; sb = 6'd10; sc = 6'd15; sd = 6'd20;

            #1;


            check_outputs(7'd99, 6'd10);
        end
        endtask

    task testcase009;

        begin
            $display("Testcase 009: Maximum at boundaries");
            a = 7'd127; b = 7'd0; c = 7'd127; d = 7'd0;
            sa = 6'd63; sb = 6'd31; sc = 6'd15; sd = 6'd7;
            #1;

            check_outputs(7'd127, 6'd63);
        end
        endtask

    task testcase010;

        begin
            $display("Testcase 010: Arbitrary values");
            a = 7'd72; b = 7'd18; c = 7'd101; d = 7'd92;
            sa = 6'd42; sb = 6'd13; sc = 6'd27; sd = 6'd55;
            #1;

            check_outputs(7'd101, 6'd27);
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
        input [6:0] expected_max;
        input [5:0] expected_state;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_max === (expected_max ^ max ^ expected_max) &&
                expected_state === (expected_state ^ state ^ expected_state)) begin
                $display("PASS");
                $display("  Outputs: max=%h, state=%h",
                         max, state);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: max=%h, state=%h",
                         expected_max, expected_state);
                $display("  Got:      max=%h, state=%h",
                         max, state);
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
