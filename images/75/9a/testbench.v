`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] a;
    reg [3:0] b;
    reg [3:0] c;
    reg clk;
    reg [3:0] d;
    reg reset;
    reg [1:0] sel;
    wire [3:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .c(c),
        .clk(clk),
        .d(d),
        .reset(reset),
        .sel(sel),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        a = 4'h0; b = 4'h0; c = 4'h0; d = 4'h0; sel = 2'b00;
        @(posedge clk);
        #1;
        reset = 0;
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase 001: Synchronous Reset Check");
        reset = 1;
        a = 4'hF; b = 4'hF; c = 4'hF; d = 4'hF;
        sel = 2'b11;
        @(posedge clk);
        #1;
        #1;

        check_outputs(4'h0);
        reset = 0;
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase 002: Select Input A (sel=00)");
        reset_dut();
        a = 4'h5; b = 4'hA; c = 4'h3; d = 4'h1;
        sel = 2'b00;
        @(posedge clk);
        #1;
        #1;

        check_outputs(4'h5);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase 003: Select Input B (sel=01)");
        reset_dut();
        a = 4'h5; b = 4'hA; c = 4'h3; d = 4'h1;
        sel = 2'b01;
        @(posedge clk);
        #1;
        #1;

        check_outputs(4'hA);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase 004: Select Input C (sel=10)");
        reset_dut();
        a = 4'h5; b = 4'hA; c = 4'h3; d = 4'h1;
        sel = 2'b10;
        @(posedge clk);
        #1;
        #1;

        check_outputs(4'h3);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase 005: Select Input D (sel=11)");
        reset_dut();
        a = 4'h5; b = 4'hA; c = 4'h3; d = 4'hF;
        sel = 2'b11;
        @(posedge clk);
        #1;
        #1;

        check_outputs(4'hF);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase 006: Reset priority over selection");
        reset_dut();

        a = 4'h7; sel = 2'b00;
        @(posedge clk);
        #1;


        reset = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(4'h0);
        reset = 0;
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
        input [3:0] expected_q;
        begin
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,a, b, c, clk, d, reset, sel, q);
    end

endmodule
