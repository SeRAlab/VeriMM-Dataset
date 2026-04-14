`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] ABCD;
    wire [15:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ABCD(ABCD),
        .out(out)
    );
    task testcase001;

        begin
            $display("Test Case 001: ABCD = 0");
            ABCD = 4'd0;
            #1;

            check_outputs(16'hFFFE);
        end
        endtask

    task testcase002;

        begin
            $display("Test Case 002: ABCD = 1");
            ABCD = 4'd1;
            #1;

            check_outputs(16'hFFFD);
        end
        endtask

    task testcase003;

        begin
            $display("Test Case 003: ABCD = 2");
            ABCD = 4'd2;
            #1;

            check_outputs(16'hFFFB);
        end
        endtask

    task testcase004;

        begin
            $display("Test Case 004: ABCD = 3");
            ABCD = 4'd3;
            #1;

            check_outputs(16'hFFF7);
        end
        endtask

    task testcase005;

        begin
            $display("Test Case 005: ABCD = 4");
            ABCD = 4'd4;
            #1;

            check_outputs(16'hFFEF);
        end
        endtask

    task testcase006;

        begin
            $display("Test Case 006: ABCD = 5");
            ABCD = 4'd5;
            #1;

            check_outputs(16'hFFDF);
        end
        endtask

    task testcase007;

        begin
            $display("Test Case 007: ABCD = 6");
            ABCD = 4'd6;
            #1;

            check_outputs(16'hFFBF);
        end
        endtask

    task testcase008;

        begin
            $display("Test Case 008: ABCD = 7");
            ABCD = 4'd7;
            #1;

            check_outputs(16'hFF7F);
        end
        endtask

    task testcase009;

        begin
            $display("Test Case 009: ABCD = 8");
            ABCD = 4'd8;
            #1;

            check_outputs(16'hFEFF);
        end
        endtask

    task testcase010;

        begin
            $display("Test Case 010: ABCD = 9");
            ABCD = 4'd9;
            #1;

            check_outputs(16'hFDFF);
        end
        endtask

    task testcase011;

        begin
            $display("Test Case 011: ABCD = 10");
            ABCD = 4'd10;
            #1;

            check_outputs(16'hFBFF);
        end
        endtask

    task testcase012;

        begin
            $display("Test Case 012: ABCD = 11");
            ABCD = 4'd11;
            #1;

            check_outputs(16'hF7FF);
        end
        endtask

    task testcase013;

        begin
            $display("Test Case 013: ABCD = 12");
            ABCD = 4'd12;
            #1;

            check_outputs(16'hEFFF);
        end
        endtask

    task testcase014;

        begin
            $display("Test Case 014: ABCD = 13");
            ABCD = 4'd13;
            #1;

            check_outputs(16'hDFFF);
        end
        endtask

    task testcase015;

        begin
            $display("Test Case 015: ABCD = 14");
            ABCD = 4'd14;
            #1;

            check_outputs(16'hBFFF);
        end
        endtask

    task testcase016;

        begin
            $display("Test Case 016: ABCD = 15");
            ABCD = 4'd15;
            #1;

            check_outputs(16'h7FFF);
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
        input [15:0] expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
