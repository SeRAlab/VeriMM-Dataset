`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg en;
    reg [7:0] q1_next;
    reg [7:0] q2_next;
    reg [7:0] q3_next;
    reg reset;
    wire [7:0] q1_reg;
    wire [7:0] q2_reg;
    wire [7:0] q3_reg;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .en(en),
        .q1_next(q1_next),
        .q2_next(q2_next),
        .q3_next(q3_next),
        .reset(reset),
        .q1_reg(q1_reg),
        .q2_reg(q2_reg),
        .q3_reg(q3_reg)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(negedge clk);
            reset = 1;
            en = 1;
            q1_next = 8'h0;
            q2_next = 8'hFF;
            q3_next = 8'hFF;
            @(negedge clk);
            reset = 0;
        end
        endtask
    task clear_inputs;

        begin
            en = 0;
            q1_next = 8'h0;
            q2_next = 8'h0;
            q3_next = 8'h0;
            reset = 0;
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Synchronous Reset Verification", test_num);
            clear_inputs();
            @(negedge clk);
            reset = 1;
            q1_next = 8'hA1;
            q2_next = 8'hB2;
            q3_next = 8'hC3;
            en = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'hA1, 8'h00, 8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Normal Data Load (en=1)", test_num);
            reset_dut();
            @(negedge clk);
            reset = 0;
            en = 1;
            q1_next = 8'h11;
            q2_next = 8'h22;
            q3_next = 8'h33;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'h11, 8'h22, 8'h33);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Enable Logic (en=0)", test_num);
            reset_dut();

            @(negedge clk);
            en = 1;
            q3_next = 8'h88;
            @(posedge clk);

            @(negedge clk);
            en = 0;
            q1_next = 8'h44;
            q2_next = 8'h55;
            q3_next = 8'h99;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'h44, 8'h55, 8'h88);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Reset Priority Over Enable", test_num);
            reset_dut();
            @(negedge clk);
            reset = 1;
            en = 1;
            q1_next = 8'hAA;
            q2_next = 8'hBB;
            q3_next = 8'hCC;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'hAA, 8'h00, 8'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: Multi-Cycle Update", test_num);
            reset_dut();
            @(negedge clk);
            en = 1;
            q1_next = 8'h01; q2_next = 8'h02; q3_next = 8'h03;
            @(posedge clk);
            @(negedge clk);
            q1_next = 8'h10; q2_next = 8'h20; q3_next = 8'h30;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'h10, 8'h20, 8'h30);
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
        input [7:0] expected_q1_reg;
        input [7:0] expected_q2_reg;
        input [7:0] expected_q3_reg;
        begin
            if (expected_q1_reg === (expected_q1_reg ^ q1_reg ^ expected_q1_reg) &&
                expected_q2_reg === (expected_q2_reg ^ q2_reg ^ expected_q2_reg) &&
                expected_q3_reg === (expected_q3_reg ^ q3_reg ^ expected_q3_reg)) begin
                $display("PASS");
                $display("  Outputs: q1_reg=%h, q2_reg=%h, q3_reg=%h",
                         q1_reg, q2_reg, q3_reg);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q1_reg=%h, q2_reg=%h, q3_reg=%h",
                         expected_q1_reg, expected_q2_reg, expected_q3_reg);
                $display("  Got:      q1_reg=%h, q2_reg=%h, q3_reg=%h",
                         q1_reg, q2_reg, q3_reg);
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
        $dumpvars(0,clk, en, q1_next, q2_next, q3_next, reset, q1_reg, q2_reg, q3_reg);
    end

endmodule
