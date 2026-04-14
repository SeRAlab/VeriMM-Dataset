`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg a;
    reg b;
    reg c;
    reg d;
    wire [6:0] hex;

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
        .hex(hex)
    );
    task testcase001;

        begin
            {a, b, c, d} = 4'h0;
            $display("Test Case 001: Input 0 (0000)");
            #1;

            check_outputs(7'h3f);
        end
        endtask

    task testcase002;

        begin
            {a, b, c, d} = 4'h1;
            $display("Test Case 002: Input 1 (0001)");
            #1;

            check_outputs(7'h06);
        end
        endtask

    task testcase003;

        begin
            {a, b, c, d} = 4'h2;
            $display("Test Case 003: Input 2 (0010)");
            #1;

            check_outputs(7'h5b);
        end
        endtask

    task testcase004;

        begin
            {a, b, c, d} = 4'h3;
            $display("Test Case 004: Input 3 (0011)");
            #1;

            check_outputs(7'h4f);
        end
        endtask

    task testcase005;

        begin
            {a, b, c, d} = 4'h4;
            $display("Test Case 005: Input 4 (0100)");
            #1;

            check_outputs(7'h66);
        end
        endtask

    task testcase006;

        begin
            {a, b, c, d} = 4'h5;
            $display("Test Case 006: Input 5 (0101)");
            #1;

            check_outputs(7'h6d);
        end
        endtask

    task testcase007;

        begin
            {a, b, c, d} = 4'h6;
            $display("Test Case 007: Input 6 (0110)");
            #1;

            check_outputs(7'h7d);
        end
        endtask

    task testcase008;

        begin
            {a, b, c, d} = 4'h7;
            $display("Test Case 008: Input 7 (0111)");
            #1;

            check_outputs(7'h07);
        end
        endtask

    task testcase009;

        begin
            {a, b, c, d} = 4'h8;
            $display("Test Case 009: Input 8 (1000)");
            #1;

            check_outputs(7'h7f);
        end
        endtask

    task testcase010;

        begin
            {a, b, c, d} = 4'h9;
            $display("Test Case 010: Input 9 (1001)");
            #1;

            check_outputs(7'h6f);
        end
        endtask

    task testcase011;

        begin
            {a, b, c, d} = 4'hA;
            $display("Test Case 011: Input A (1010)");
            #1;

            check_outputs(7'h77);
        end
        endtask

    task testcase012;

        begin
            {a, b, c, d} = 4'hB;
            $display("Test Case 012: Input B (1011)");
            #1;

            check_outputs(7'h7c);
        end
        endtask

    task testcase013;

        begin
            {a, b, c, d} = 4'hC;
            $display("Test Case 013: Input C (1100)");
            #1;

            check_outputs(7'h39);
        end
        endtask

    task testcase014;

        begin
            {a, b, c, d} = 4'hD;
            $display("Test Case 014: Input D (1101)");
            #1;

            check_outputs(7'h5e);
        end
        endtask

    task testcase015;

        begin
            {a, b, c, d} = 4'hE;
            $display("Test Case 015: Input E (1110)");
            #1;

            check_outputs(7'h79);
        end
        endtask

    task testcase016;

        begin
            {a, b, c, d} = 4'hF;
            $display("Test Case 016: Input F (1111)");
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
        input [6:0] expected_hex;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_hex === (expected_hex ^ hex ^ expected_hex)) begin
                $display("PASS");
                $display("  Outputs: hex=%h",
                         hex);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: hex=%h",
                         expected_hex);
                $display("  Got:      hex=%h",
                         hex);
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
