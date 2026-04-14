`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] d;
    reg ld;
    reg rst;
    reg und;
    wire [3:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .d(d),
        .ld(ld),
        .rst(rst),
        .und(und),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        ld = 0;
        und = 0;
        d = 4'b0000;
        @(posedge clk);
        #1 rst = 0;
    end
        endtask
    task testcase001;

    begin
        $display("Running testcase001: Reset Check");
        reset_dut();
        @(negedge clk);
        #1;

        check_outputs(4'h0);
    end
        endtask

    task testcase002;

    begin
        $display("Running testcase002: Load 4'hA");
        reset_dut();
        @(negedge clk);
        ld = 1;
        d = 4'hA;
        @(posedge clk);
        #1 ld = 0;
        #1;

        check_outputs(4'hA);
    end
        endtask

    task testcase003;

    begin
        $display("Running testcase003: Increment 3 times");
        reset_dut();
        @(negedge clk);
        und = 1;
        repeat(3) @(posedge clk);
        #1;
        #1;

        check_outputs(4'h3);
    end
        endtask

    task testcase004;

    begin
        $display("Running testcase004: Decrement from 4'h5");
        reset_dut();
        @(negedge clk);
        ld = 1; d = 4'h5;
        @(posedge clk);
        #1 ld = 0; und = 0;
        repeat(2) @(posedge clk);
        #1;
        #1;

        check_outputs(4'h3);
    end
        endtask

    task testcase005;

    begin
        $display("Running testcase005: Up Counter Wrap Around");
        reset_dut();
        @(negedge clk);
        ld = 1; d = 4'hF;
        @(posedge clk);
        #1 ld = 0; und = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(4'h0);
    end
        endtask

    task testcase006;

    begin
        $display("Running testcase006: Down Counter Wrap Around");
        reset_dut();
        @(negedge clk);
        und = 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(4'hF);
    end
        endtask

    task testcase007;

    begin
        $display("Running testcase007: Priority - Reset vs Load");
        reset_dut();
        @(negedge clk);
        rst = 1;
        ld = 1;
        d = 4'hC;
        @(posedge clk);
        #1 rst = 0; ld = 0;
        #1;

        check_outputs(4'h0);
    end
        endtask

    task testcase008;

    begin
        $display("Running testcase008: Priority - Load vs Count");
        reset_dut();
        @(negedge clk);
        ld = 1;
        d = 4'h7;
        und = 1;
        @(posedge clk);
        #1 ld = 0;
        #1;

        check_outputs(4'h7);
    end
        endtask

    task testcase009;

    begin
        $display("Running testcase009: Complex Sequence");
        reset_dut();
        @(negedge clk);
        ld = 1; d = 4'hE;
        @(posedge clk);
        #1 ld = 0; und = 1;
        @(posedge clk);
        #1 und = 0;
        repeat(2) @(posedge clk);
        #1;
        #1;

        check_outputs(4'hD);
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
        $dumpvars(0,clk, d, ld, rst, und, q);
    end

endmodule
