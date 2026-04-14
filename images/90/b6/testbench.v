`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [23:0] S_in;
    wire [23:0] S_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .S_in(S_in),
        .S_out(S_out)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case 001: Input = 0");
        S_in = 24'd0;
        #1;

        check_outputs(24'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case 002: Input = 4 (Round down to 0)");
        S_in = 24'd4;
        #1;

        check_outputs(24'd0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case 003: Input = 5 (Round up to 1)");
        S_in = 24'd5;
        #1;

        check_outputs(24'd1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case 004: Input = 14 (Round down to 1)");
        S_in = 24'd14;
        #1;

        check_outputs(24'd1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case 005: Input = 15 (Round up to 2)");
        S_in = 24'd15;
        #1;

        check_outputs(24'd2);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case 006: Input = 100 (Result 10)");
        S_in = 24'd100;
        #1;

        check_outputs(24'd10);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case 007: Input = 99 (Round up to 10)");
        S_in = 24'd99;
        #1;

        check_outputs(24'd10);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case 008: Input = 12345 (Round up to 1235)");
        S_in = 24'd12345;
        #1;

        check_outputs(24'd1235);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test Case 009: Input = 16777215 (Max 24-bit, rounds to 1677722)");
        S_in = 24'hFFFFFF;
        #1;

        check_outputs(24'd1677722);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test Case 010: Input = 16777210 (Rounds to 1677721)");
        S_in = 24'd16777210;
        #1;

        check_outputs(24'd1677721);
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
        input [23:0] expected_S_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_S_out === (expected_S_out ^ S_out ^ expected_S_out)) begin
                $display("PASS");
                $display("  Outputs: S_out=%h",
                         S_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: S_out=%h",
                         expected_S_out);
                $display("  Got:      S_out=%h",
                         S_out);
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
