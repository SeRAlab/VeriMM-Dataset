`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] a;
    reg [31:0] b;
    reg clk;
    wire [63:0] p;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .clk(clk),
        .p(p)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            a = 0;
            b = 0;
            repeat(5) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            a = 32'sd12;
            b = 32'sd10;
            $display("Test Case 001: %0d * %0d", $signed(a), $signed(b));
            repeat(4) @(posedge clk);
            #1;
            #1;

            check_outputs(64'sd120);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            a = 32'sd100;
            b = -32'sd50;
            $display("Test Case 002: %0d * %0d", $signed(a), $signed(b));
            repeat(4) @(posedge clk);
            #1;
            #1;

            check_outputs(-64'sd5000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            a = -32'sd15;
            b = -32'sd4;
            $display("Test Case 003: %0d * %0d", $signed(a), $signed(b));
            repeat(4) @(posedge clk);
            #1;
            #1;

            check_outputs(64'sd60);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            a = 32'sd0;
            b = 32'sd9999;
            $display("Test Case 004: %0d * %0d", $signed(a), $signed(b));
            repeat(4) @(posedge clk);
            #1;
            #1;

            check_outputs(64'sd0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            a = 32'h7FFFFFFF;
            b = 32'sd2;
            $display("Test Case 005: Max Pos * 2");
            repeat(4) @(posedge clk);
            #1;
            #1;

            check_outputs(64'sd4294967294);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            reset_dut();
            a = 32'h80000000;
            b = 32'sd1;
            $display("Test Case 006: Min Neg * 1");
            repeat(4) @(posedge clk);
            #1;
            #1;

            check_outputs(-64'sd2147483648);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            reset_dut();
            a = 32'h7FFFFFFF;
            b = 32'h7FFFFFFF;
            $display("Test Case 007: Max Pos * Max Pos");
            repeat(4) @(posedge clk);
            #1;
            #1;

            check_outputs(64'h3FFFFFFF00000001);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            reset_dut();
            a = 32'h80000000;
            b = 32'h80000000;
            $display("Test Case 008: Min Neg * Min Neg");
            repeat(4) @(posedge clk);
            #1;
            #1;

            check_outputs(64'h4000000000000000);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            reset_dut();
            a = 32'h80000000;
            b = 32'h7FFFFFFF;
            $display("Test Case 009: Min Neg * Max Pos");
            repeat(4) @(posedge clk);
            #1;
            #1;

            check_outputs(64'hC000000080000000);
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
        input [63:0] expected_p;
        begin
            if (expected_p === (expected_p ^ p ^ expected_p)) begin
                $display("PASS");
                $display("  Outputs: p=%h",
                         p);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: p=%h",
                         expected_p);
                $display("  Got:      p=%h",
                         p);
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
        $dumpvars(0,a, b, clk, p);
    end

endmodule
