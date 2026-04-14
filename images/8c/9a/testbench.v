`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] d;
    reg load;
    reg reset_n;
    wire [15:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .d(d),
        .load(load),
        .reset_n(reset_n),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset_n = 1;
        d = 0;
        load = 0;
        @(posedge clk);
        #1 reset_n = 0;
        @(posedge clk);
        #1 reset_n = 1;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Synchronous Reset Check", test_num);
        reset_dut();

        @(posedge clk);
        #1;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Basic Load Load=1", test_num);
        reset_dut();
        d = 16'hA5A5;
        load = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(16'hA5A5);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Load Enable=0 (Hold Value)", test_num);
        reset_dut();

        d = 16'h1234;
        load = 1;
        @(posedge clk);

        #1 d = 16'h5678;
        load = 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(16'h1234);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Reset Priority Over Load", test_num);
        reset_dut();

        d = 16'hFFFF;
        load = 1;
        reset_n = 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Sequential Loads", test_num);
        reset_dut();
        load = 1;
        d = 16'h0001; @(posedge clk);
        #1 d = 16'h0002; @(posedge clk);
        #1 d = 16'h0004; @(posedge clk);
        #1 d = 16'h0008; @(posedge clk);
        #1;
        #1;

        check_outputs(16'h0008);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Full Bit Width (0xFFFF)", test_num);
        reset_dut();
        d = 16'hFFFF;
        load = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(16'hFFFF);
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
        input [15:0] expected_q;
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
        $dumpvars(0,clk, d, load, reset_n, q);
    end

endmodule
