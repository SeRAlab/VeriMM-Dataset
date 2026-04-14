`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg dp;
    reg [3:0] hex;
    wire [7:0] sseg;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .dp(dp),
        .hex(hex),
        .sseg(sseg)
    );
    task testcase001;

        begin
            $display("Test 001: hex=0, dp=0");
            hex = 4'h0; dp = 1'b0;
            #1;

            check_outputs(8'h3F);
        end
        endtask

    task testcase002;

        begin
            $display("Test 002: hex=1, dp=1");
            hex = 4'h1; dp = 1'b1;
            #1;

            check_outputs(8'h86);
        end
        endtask

    task testcase003;

        begin
            $display("Test 003: hex=2, dp=0");
            hex = 4'h2; dp = 1'b0;
            #1;

            check_outputs(8'h5B);
        end
        endtask

    task testcase004;

        begin
            $display("Test 004: hex=3, dp=1");
            hex = 4'h3; dp = 1'b1;
            #1;

            check_outputs(8'hCF);
        end
        endtask

    task testcase005;

        begin
            $display("Test 005: hex=4, dp=0");
            hex = 4'h4; dp = 1'b0;
            #1;

            check_outputs(8'h66);
        end
        endtask

    task testcase006;

        begin
            $display("Test 006: hex=5, dp=1");
            hex = 4'h5; dp = 1'b1;
            #1;

            check_outputs(8'hED);
        end
        endtask

    task testcase007;

        begin
            $display("Test 007: hex=6, dp=0");
            hex = 4'h6; dp = 1'b0;
            #1;

            check_outputs(8'h7D);
        end
        endtask

    task testcase008;

        begin
            $display("Test 008: hex=7, dp=1");
            hex = 4'h7; dp = 1'b1;
            #1;

            check_outputs(8'h87);
        end
        endtask

    task testcase009;

        begin
            $display("Test 009: hex=8, dp=0");
            hex = 4'h8; dp = 1'b0;
            #1;

            check_outputs(8'h7F);
        end
        endtask

    task testcase010;

        begin
            $display("Test 010: hex=9, dp=1");
            hex = 4'h9; dp = 1'b1;
            #1;

            check_outputs(8'hEF);
        end
        endtask

    task testcase011;

        begin
            $display("Test 011: hex=A, dp=0");
            hex = 4'hA; dp = 1'b0;
            #1;

            check_outputs(8'h77);
        end
        endtask

    task testcase012;

        begin
            $display("Test 012: hex=B, dp=1");
            hex = 4'hB; dp = 1'b1;
            #1;

            check_outputs(8'hFC);
        end
        endtask

    task testcase013;

        begin
            $display("Test 013: hex=C, dp=0");
            hex = 4'hC; dp = 1'b0;
            #1;

            check_outputs(8'h39);
        end
        endtask

    task testcase014;

        begin
            $display("Test 014: hex=D, dp=1");
            hex = 4'hD; dp = 1'b1;
            #1;

            check_outputs(8'hDE);
        end
        endtask

    task testcase015;

        begin
            $display("Test 015: hex=E, dp=0");
            hex = 4'hE; dp = 1'b0;
            #1;

            check_outputs(8'h79);
        end
        endtask

    task testcase016;

        begin
            $display("Test 016: hex=F, dp=1");
            hex = 4'hF; dp = 1'b1;
            #1;

            check_outputs(8'hF1);
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
        input [7:0] expected_sseg;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_sseg === (expected_sseg ^ sseg ^ expected_sseg)) begin
                $display("PASS");
                $display("  Outputs: sseg=%h",
                         sseg);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: sseg=%h",
                         expected_sseg);
                $display("  Got:      sseg=%h",
                         sseg);
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
