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
            @(posedge clk);
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Zero Case (0 * 0)", test_num);
            reset_dut();
            a = 32'h0;
            b = 32'h0;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(64'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Multiply by Zero (0xFFFFFFFF * 0)", test_num);
            reset_dut();
            a = 32'hFFFFFFFF;
            b = 32'h0;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(64'h0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Identity Case (0x12345678 * 1)", test_num);
            reset_dut();
            a = 32'h12345678;
            b = 32'h1;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(64'h0000000012345678);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Small Integers (1234 * 5678)", test_num);
            reset_dut();
            a = 32'd1234;
            b = 32'd5678;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(64'd7006652);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Max Values (0xFFFFFFFF * 0xFFFFFFFF)", test_num);
            reset_dut();
            a = 32'hFFFFFFFF;
            b = 32'hFFFFFFFF;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(64'hFFFFFFFF00000001);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Large Product (0x12345678 * 0x87654321)", test_num);
            reset_dut();
            a = 32'h12345678;
            b = 32'h87654321;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(64'h9A0A031E6056B4F8);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Power of 2 (2^16 * 2^15)", test_num);
            reset_dut();
            a = 32'h00010000;
            b = 32'h00008000;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(64'h0000000080000000);
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
