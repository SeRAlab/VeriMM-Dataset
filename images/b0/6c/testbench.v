`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] d;
    reg load;
    reg pop;
    reg push;
    reg reset;
    wire [15:0] qnext;
    wire [15:0] qtop;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .d(d),
        .load(load),
        .pop(pop),
        .push(push),
        .reset(reset),
        .qnext(qnext),
        .qtop(qtop)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        load = 0;
        push = 0;
        pop = 0;
        d = 0;
        @(posedge clk);
        #1 reset = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case 001: Checking reset state...");
        reset_dut();
        #1;

        check_outputs(16'h0000, 16'h0000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case 002: Single Push...");
        reset_dut();
        d = 16'hAAAA;
        push = 1;
        @(posedge clk);
        #1 push = 0;
        #1;

        check_outputs(16'h0000, 16'hAAAA);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case 003: Double Push (qtop and qnext)...");
        reset_dut();
        d = 16'h1111; push = 1; @(posedge clk);
        #1 d = 16'h2222; push = 1; @(posedge clk);
        #1 push = 0;
        #1;

        check_outputs(16'h1111, 16'h2222);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case 004: Push two elements and Pop one...");
        reset_dut();
        d = 16'h1111; push = 1; @(posedge clk);
        #1 d = 16'h2222; push = 1; @(posedge clk);
        #1 push = 0; pop = 1; @(posedge clk);
        #1 pop = 0;
        #1;

        check_outputs(16'h0000, 16'h1111);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case 005: Load (overwriting top without shifting)...");
        reset_dut();
        d = 16'hBBBB; push = 1; @(posedge clk);
        #1 d = 16'hCCCC; load = 1; push = 0; @(posedge clk);
        #1 load = 0;
        #1;

        check_outputs(16'h0000, 16'hCCCC);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case 006: Push then Load (qnext should be preserved)...");
        reset_dut();
        d = 16'h1234; push = 1; @(posedge clk);
        #1 d = 16'h5678; push = 1; @(posedge clk);
        #1 d = 16'h9ABC; load = 1; push = 0; @(posedge clk);
        #1 load = 0;
        #1;

        check_outputs(16'h1234, 16'h9ABC);
    end
        endtask

    task testcase007;

        integer i;
    begin
        test_num = 7;
        $display("Test Case 007: Filling Stack Depth (8 items)...");
        reset_dut();
        for(i=1; i<=8; i=i+1) begin
            d = i; push = 1; @(posedge clk);
            #1 push = 0;
        end

        #1;


        check_outputs(16'h0007, 16'h0008);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test Case 008: Push 3, Pop 3...");
        reset_dut();
        d = 16'h1; push = 1; @(posedge clk);
        #1 d = 16'h2; push = 1; @(posedge clk);
        #1 d = 16'h3; push = 1; @(posedge clk);
        #1 push = 0; pop = 1;
        repeat(3) @(posedge clk);
        #1 pop = 0;
        #1;

        check_outputs(16'h0000, 16'h0000);
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
        input [15:0] expected_qnext;
        input [15:0] expected_qtop;
        begin
            if (expected_qnext === (expected_qnext ^ qnext ^ expected_qnext) &&
                expected_qtop === (expected_qtop ^ qtop ^ expected_qtop)) begin
                $display("PASS");
                $display("  Outputs: qnext=%h, qtop=%h",
                         qnext, qtop);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: qnext=%h, qtop=%h",
                         expected_qnext, expected_qtop);
                $display("  Got:      qnext=%h, qtop=%h",
                         qnext, qtop);
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
        $dumpvars(0,clk, d, load, pop, push, reset, qnext, qtop);
    end

endmodule
