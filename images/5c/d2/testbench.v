`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg en1;
    reg en2;
    reg i;
    reg [2:0] l;
    wire q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .en1(en1),
        .en2(en2),
        .i(i),
        .l(l),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            en1 = 1;
            en2 = 0;
            i = 0;
            l = 0;
            repeat(10) @(negedge clk);
            en1 = 0;
            repeat(2) @(negedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            @(negedge clk);
            en1 = 1; i = 1;
            @(negedge clk);
            en1 = 0;
            l = 3'd0;
            #1;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            @(negedge clk) {en1, en2, i} = 3'b101;
            repeat(6) @(negedge clk) {en1, en2, i} = 3'b100;
            @(negedge clk) en1 = 0;
            l = 3'd6;
            #1;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            @(negedge clk) {en1, en2, i} = 3'b101;
            @(negedge clk) {en1, en2, i} = 3'b000;
            repeat(5) @(negedge clk);
            l = 3'd0;
            #1;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;


            @(negedge clk) {en1, en2, i} = 3'b101;
            @(negedge clk) {en1, en2, i} = 3'b100;
            @(negedge clk) {en1, en2, i} = 3'b100;
            @(negedge clk) {en1, en2, i} = 3'b111;
            @(negedge clk) en1 = 0;
            l = 3'd3;
            #1;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;

            @(negedge clk) {en1, en2, i} = 3'b101;
            @(negedge clk) {en1, en2, i} = 3'b100;
            @(negedge clk) {en1, en2, i} = 3'b101;
            @(negedge clk) {en1, en2, i} = 3'b100;
            @(negedge clk) {en1, en2, i} = 3'b101;
            @(negedge clk) {en1, en2, i} = 3'b100;
            @(negedge clk) {en1, en2, i} = 3'b101;
            @(negedge clk) en1 = 0;

            l = 3'd2;
            #1;
            #1;

            check_outputs(1);
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
        input expected_q;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: q=%b",
                         q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%b",
                         expected_q);
                $display("  Got:      q=%b",
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
        $dumpvars(0,clk, en1, en2, i, l, q);
    end

endmodule
