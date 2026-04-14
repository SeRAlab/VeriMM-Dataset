`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg A;
    reg B;
    reg C;
    reg EN;
    wire Y0;
    wire Y1;
    wire Y2;
    wire Y3;
    wire Y4;
    wire Y5;
    wire Y6;
    wire Y7;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .C(C),
        .EN(EN),
        .Y0(Y0),
        .Y1(Y1),
        .Y2(Y2),
        .Y3(Y3),
        .Y4(Y4),
        .Y5(Y5),
        .Y6(Y6),
        .Y7(Y7)
    );

    // Clock generation (10ns period)
    initial begin
        EN = 0;
        forever #5 EN = ~EN;
    end

        task reset_dut;

        begin
            A = 0;
            B = 0;
            C = 0;

            #10;
        end
        endtask
    task testcase001;

        begin
            $display("Running Testcase 001: Input 000 (Y0 expected)");
            reset_dut();
            A = 0; B = 0; C = 0;
            @(posedge EN);
            #2;
            #1;

            check_outputs(1, 0, 0, 0, 0, 0, 0, 0);
        end
        endtask

    task testcase002;

        begin
            $display("Running Testcase 002: Input 001 (Y1 expected)");
            reset_dut();
            A = 0; B = 0; C = 1;
            @(posedge EN);
            #2;
            #1;

            check_outputs(0, 1, 0, 0, 0, 0, 0, 0);
        end
        endtask

    task testcase003;

        begin
            $display("Running Testcase 003: Input 010 (Y2 expected)");
            reset_dut();
            A = 0; B = 1; C = 0;
            @(posedge EN);
            #2;
            #1;

            check_outputs(0, 0, 1, 0, 0, 0, 0, 0);
        end
        endtask

    task testcase004;

        begin
            $display("Running Testcase 004: Input 011 (Y3 expected)");
            reset_dut();
            A = 0; B = 1; C = 1;
            @(posedge EN);
            #2;
            #1;

            check_outputs(0, 0, 0, 1, 0, 0, 0, 0);
        end
        endtask

    task testcase005;

        begin
            $display("Running Testcase 005: Input 100 (Y4 expected)");
            reset_dut();
            A = 1; B = 0; C = 0;
            @(posedge EN);
            #2;
            #1;

            check_outputs(0, 0, 0, 0, 1, 0, 0, 0);
        end
        endtask

    task testcase006;

        begin
            $display("Running Testcase 006: Input 101 (Y5 expected)");
            reset_dut();
            A = 1; B = 0; C = 1;
            @(posedge EN);
            #2;
            #1;

            check_outputs(0, 0, 0, 0, 0, 1, 0, 0);
        end
        endtask

    task testcase007;

        begin
            $display("Running Testcase 007: Input 110 (Y6 expected)");
            reset_dut();
            A = 1; B = 1; C = 0;
            @(posedge EN);
            #2;
            #1;

            check_outputs(0, 0, 0, 0, 0, 0, 1, 0);
        end
        endtask

    task testcase008;

        begin
            $display("Running Testcase 008: Input 111 (Y7 expected)");
            reset_dut();
            A = 1; B = 1; C = 1;
            @(posedge EN);
            #2;
            #1;

            check_outputs(0, 0, 0, 0, 0, 0, 0, 1);
        end
        endtask

    task testcase009;

        begin
            $display("Running Testcase 009: Enable de-asserted check");
            reset_dut();
            A = 1; B = 1; C = 1;
            @(negedge EN);
            #2;
            #1;

            check_outputs(0, 0, 0, 0, 0, 0, 0, 0);
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
        input expected_Y0;
        input expected_Y1;
        input expected_Y2;
        input expected_Y3;
        input expected_Y4;
        input expected_Y5;
        input expected_Y6;
        input expected_Y7;
        begin
            if (expected_Y0 === (expected_Y0 ^ Y0 ^ expected_Y0) &&
                expected_Y1 === (expected_Y1 ^ Y1 ^ expected_Y1) &&
                expected_Y2 === (expected_Y2 ^ Y2 ^ expected_Y2) &&
                expected_Y3 === (expected_Y3 ^ Y3 ^ expected_Y3) &&
                expected_Y4 === (expected_Y4 ^ Y4 ^ expected_Y4) &&
                expected_Y5 === (expected_Y5 ^ Y5 ^ expected_Y5) &&
                expected_Y6 === (expected_Y6 ^ Y6 ^ expected_Y6) &&
                expected_Y7 === (expected_Y7 ^ Y7 ^ expected_Y7)) begin
                $display("PASS");
                $display("  Outputs: Y0=%b, Y1=%b, Y2=%b, Y3=%b, Y4=%b, Y5=%b, Y6=%b, Y7=%b",
                         Y0, Y1, Y2, Y3, Y4, Y5, Y6, Y7);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Y0=%b, Y1=%b, Y2=%b, Y3=%b, Y4=%b, Y5=%b, Y6=%b, Y7=%b",
                         expected_Y0, expected_Y1, expected_Y2, expected_Y3, expected_Y4, expected_Y5, expected_Y6, expected_Y7);
                $display("  Got:      Y0=%b, Y1=%b, Y2=%b, Y3=%b, Y4=%b, Y5=%b, Y6=%b, Y7=%b",
                         Y0, Y1, Y2, Y3, Y4, Y5, Y6, Y7);
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,A, B, C, EN, Y0, Y1, Y2, Y3, Y4, Y5, Y6, Y7);
    end

endmodule
