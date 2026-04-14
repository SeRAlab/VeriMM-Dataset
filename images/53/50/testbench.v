`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [29:0] a;
    reg [29:0] b;
    reg clk;
    reg [1:0] mode;
    reg reset;
    wire [3:0] flags;
    wire [29:0] sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .clk(clk),
        .mode(mode),
        .reset(reset),
        .flags(flags),
        .sum(sum)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        a = 0;
        b = 0;
        mode = 0;
        #15;
        reset = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        $display("Testcase 001: Reset logic check");

        #1;


        check_outputs(4'h0, 30'h0);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        $display("Testcase 002: Unsigned addition (1000 + 2000)");
        mode = 2'd0;
        a = 30'd1000;
        b = 30'd2000;
        @(posedge clk);
        #1;
        #1;

        check_outputs(4'h0, 30'd3000);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        $display("Testcase 003: Unsigned addition overflow (Max + 1)");
        mode = 2'd0;
        a = UNSIGNED_MAX;
        b = 30'd1;
        @(posedge clk);
        #1;

        #1;


        check_outputs(4'h1, 30'h0);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        $display("Testcase 004: Signed addition (Small Positive)");
        mode = 2'd1;
        a = 30'sd5000;
        b = 30'sd10000;
        @(posedge clk);
        #1;
        #1;

        check_outputs(4'h0, 30'sd15000);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        $display("Testcase 005: Signed addition (Small Negative)");
        mode = 2'd1;
        a = -30'sd10;
        b = -30'sd20;
        @(posedge clk);
        #1;
        #1;

        check_outputs(4'h0, -30'sd30);
    end
        endtask

    task testcase006;

    begin
        reset_dut();
        $display("Testcase 006: Signed overflow (Max Positive + 1)");
        mode = 2'd1;
        a = SIGNED_MAX;
        b = 30'sd1;
        @(posedge clk);
        #1;


        #1;



        check_outputs(4'h2, SIGNED_MIN);
    end
        endtask

    task testcase007;

    begin
        reset_dut();
        $display("Testcase 007: Signed underflow (Min Negative - 1)");
        mode = 2'd1;
        a = SIGNED_MIN;
        b = SIGNED_NEG_1;
        @(posedge clk);
        #1;


        #1;



        check_outputs(4'h4, SIGNED_MAX);
    end
        endtask

    task testcase008;

    begin
        reset_dut();
        $display("Testcase 008: Adding zeros");
        mode = 2'd1;
        a = 30'd0;
        b = 30'd0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(4'h0, 30'h0);
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
        input [3:0] expected_flags;
        input [29:0] expected_sum;
        begin
            if (expected_flags === (expected_flags ^ flags ^ expected_flags) &&
                expected_sum === (expected_sum ^ sum ^ expected_sum)) begin
                $display("PASS");
                $display("  Outputs: flags=%h, sum=%h",
                         flags, sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: flags=%h, sum=%h",
                         expected_flags, expected_sum);
                $display("  Got:      flags=%h, sum=%h",
                         flags, sum);
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
        $dumpvars(0,a, b, clk, mode, reset, flags, sum);
    end

endmodule
