`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg din;
    reg en;
    reg rst;
    reg se;
    reg si;
    wire q;
    wire so;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .din(din),
        .en(en),
        .rst(rst),
        .se(se),
        .si(si),
        .q(q),
        .so(so)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        @(negedge clk);
        rst = 1;
        en = 0;
        se = 0;
        din = 0;
        si = 0;
        @(negedge clk);
        rst = 0;
        $display("DUT Reset Complete");
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        reset_dut();
        $display("Testcase 001: Reset Check");
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        reset_dut();
        $display("Testcase 002: Normal Load (din=1, en=1)");
        @(negedge clk);
        en = 1;
        din = 1;
        @(negedge clk);
        #1;

        check_outputs(1'b1, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        reset_dut();
        $display("Testcase 003: Enable Disabled (din=1, en=0)");
        @(negedge clk);
        en = 0;
        din = 1;
        @(negedge clk);
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        reset_dut();
        $display("Testcase 004: Scan Load (si=1, se=1)");
        @(negedge clk);
        se = 1;
        si = 1;
        en = 0;
        @(negedge clk);
        #1;

        check_outputs(1'b1, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        reset_dut();
        $display("Testcase 005: Scan Priority (se=1, si=0, en=1, din=1)");
        @(negedge clk);
        se = 1;
        si = 0;
        en = 1;
        din = 1;
        @(negedge clk);

        #1;


        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        reset_dut();
        $display("Testcase 006: Reset Priority (rst=1, se=1, si=1, en=1, din=1)");
        @(negedge clk);

        en = 1; din = 1;
        @(negedge clk);

        rst = 1;
        se = 1; si = 1;
        en = 1; din = 1;
        @(negedge clk);
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        reset_dut();
        $display("Testcase 007: Sequential Toggle");
        @(negedge clk);
        en = 1; din = 1;
        @(negedge clk);
        en = 1; din = 0;
        @(negedge clk);
        en = 1; din = 1;
        @(negedge clk);
        #1;

        check_outputs(1'b1, 1'b1);
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
        input expected_q;
        input expected_so;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q) &&
                expected_so === (expected_so ^ so ^ expected_so)) begin
                $display("PASS");
                $display("  Outputs: q=%b, so=%b",
                         q, so);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%b, so=%b",
                         expected_q, expected_so);
                $display("  Got:      q=%b, so=%b",
                         q, so);
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
        $dumpvars(0,clk, din, en, rst, se, si, q, so);
    end

endmodule
