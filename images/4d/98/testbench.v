`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] a;
    wire [15:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .q(q)
    );
    task testcase001;

        begin
            $display("Test Case 001: a = 0");
            a = 3'd0;
            #1;

            check_outputs(16'haff3);
        end
        endtask

    task testcase002;

        begin
            $display("Test Case 002: a = 1");
            a = 3'd1;
            #1;

            check_outputs(16'hfc9b);
        end
        endtask

    task testcase003;

        begin
            $display("Test Case 003: a = 2");
            a = 3'd2;
            #1;

            check_outputs(16'ha95c);
        end
        endtask

    task testcase004;

        begin
            $display("Test Case 004: a = 3");
            a = 3'd3;
            #1;

            check_outputs(16'hcc2f);
        end
        endtask

    task testcase005;

        begin
            $display("Test Case 005: a = 4");
            a = 3'd4;
            #1;

            check_outputs(16'h4eae);
        end
        endtask

    task testcase006;

        begin
            $display("Test Case 006: a = 5");
            a = 3'd5;
            #1;

            check_outputs(16'h6731);
        end
        endtask

    task testcase007;

        begin
            $display("Test Case 007: a = 6");
            a = 3'd6;
            #1;

            check_outputs(16'h0f10);
        end
        endtask

    task testcase008;

        begin
            $display("Test Case 008: a = 7");
            a = 3'd7;
            #1;

            check_outputs(16'h174c);
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
        input [15:0] expected_q;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: q=%h",
                         q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%h",
                         expected_q);
                $display("  Got:      q=%h",
                         q);
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
