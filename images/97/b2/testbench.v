`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [63:0] next_result;
    reg reset_n;
    wire [63:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .next_result(next_result),
        .reset_n(reset_n),
        .result(result)
    );
    task testcase001;

        begin
            $display("Testcase 001: Asynchronous Reset Assertion");
            test_num = test_num + 1;

            reset_n = 0;
            next_result = 64'hA5A5A5A5_5A5A5A5A;
            #10;

            #1;


            check_outputs(64'h0);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Normal Operation - Data Propagation");
            test_num = test_num + 1;

            reset_n = 0;
            #5;
            reset_n = 1;
            next_result = 64'h12345678_9ABCDEF0;
            #10;

            #1;


            check_outputs(64'h12345678_9ABCDEF0);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Unknown Input (64'bx) Handling");
            test_num = test_num + 1;

            reset_n = 0;
            #5;
            reset_n = 1;
            next_result = 64'bx;
            #10;

            #1;


            check_outputs(64'h0);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Boundary Value - All Ones");
            test_num = test_num + 1;

            reset_n = 0;
            #5;
            reset_n = 1;
            next_result = 64'hFFFFFFFF_FFFFFFFF;
            #10;

            #1;


            check_outputs(64'hFFFFFFFF_FFFFFFFF);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Asynchronous Reset during Operation");
            test_num = test_num + 1;

            reset_n = 0;
            #5;
            reset_n = 1;
            next_result = 64'hCAFEBABEDEADBEEF;
            #5;
            reset_n = 0;
            #10;

            #1;


            check_outputs(64'h0);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Sequential Data Changes");
            test_num = test_num + 1;

            reset_n = 0;
            #5;
            reset_n = 1;
            next_result = 64'h00000000_00000001;
            #5;
            next_result = 64'h80000000_00000000;
            #10;

            #1;


            check_outputs(64'h80000000_00000000);
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
        input [63:0] expected_result;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: result=%h",
                         result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: result=%h",
                         expected_result);
                $display("  Got:      result=%h",
                         result);
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
