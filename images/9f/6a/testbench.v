`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] M;
    reg [15:0] N;
    reg clk;
    wire [31:0] P;
    wire [3:0] V;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .M(M),
        .N(N),
        .clk(clk),
        .P(P),
        .V(V)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            M = 0;
            N = 0;

            @(negedge clk);
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: M > N (Both positive)");
            M = 16'sd10; N = 16'sd5;
            @(negedge clk);
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'sd50, 4'b1000);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: M < N (Both positive)");
            M = 16'sd5; N = 16'sd20;
            @(negedge clk);
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'sd20, 4'b0100);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: M < N (N is negative)");
            M = 16'sd-50; N = 16'sd-10;
            @(negedge clk);
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'sd10, 4'b0100);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: M > N (Mixed signs)");
            M = 16'sd5; N = 16'sd-10;
            @(negedge clk);
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'sd-50, 4'b1000);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: M == N");
            M = 16'sd-100; N = 16'sd-100;
            @(negedge clk);
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'sd100, 4'b0100);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: M > N (N is zero)");
            M = 16'sd100; N = 16'sd0;
            @(negedge clk);
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'sd0, 4'b1000);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Max Positive M > N");
            M = 16'sh7FFF;
            N = 16'sd2;
            @(negedge clk);
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'sd65534, 4'b1000);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: M < N (N is Min Signed)");
            M = 16'sd0;
            N = 16'sh8000;
            @(negedge clk);
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'sd32768, 4'b1000);
        end
        endtask

    task testcase009;

        begin
            $display("Testcase 009: M < N (N is Min Signed, P is abs)");
            M = -32768;
            N = -32768;
            @(negedge clk);
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'sd32768, 4'b0100);
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
        input [31:0] expected_P;
        input [3:0] expected_V;
        begin
            if (expected_P === (expected_P ^ P ^ expected_P) &&
                expected_V === (expected_V ^ V ^ expected_V)) begin
                $display("PASS");
                $display("  Outputs: P=%h, V=%h",
                         P, V);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: P=%h, V=%h",
                         expected_P, expected_V);
                $display("  Got:      P=%h, V=%h",
                         P, V);
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
        $dumpvars(0,M, N, clk, P, V);
    end

endmodule
