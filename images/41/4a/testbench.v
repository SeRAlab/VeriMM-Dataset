`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [1:0] a;
    reg ce;
    reg clk;
    reg [11:0] data;
    reg [1:0] shift;
    wire [11:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .ce(ce),
        .clk(clk),
        .data(data),
        .shift(shift),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        ce = 0;
        data = 12'h0;
        a = 0;
        shift = 0;

        repeat(4) @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Fill 3 samples, read oldest", test_num);
        reset_dut();

        @(negedge clk); ce = 1; data = 12'hAAA;
        @(negedge clk); ce = 1; data = 12'hBBB;
        @(negedge clk); ce = 1; data = 12'hCCC;

        @(negedge clk);
        ce = 0;
        a = 2;
        #2;
        #1;

        check_outputs(12'hAAA);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Fill 3 samples, read middle", test_num);
        reset_dut();

        @(negedge clk); ce = 1; data = 12'h111;
        @(negedge clk); ce = 1; data = 12'h222;
        @(negedge clk); ce = 1; data = 12'h333;

        @(negedge clk);
        ce = 0;
        a = 1;
        #2;
        #1;

        check_outputs(12'h222);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Fill 3 samples, read newest", test_num);
        reset_dut();

        @(negedge clk); ce = 1; data = 12'hABC;
        @(negedge clk); ce = 1; data = 12'hDEF;
        @(negedge clk); ce = 1; data = 12'h123;

        @(negedge clk);
        ce = 0;
        a = 0;
        #2;
        #1;

        check_outputs(12'h123);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Verify ce=0 shifts in zero", test_num);
        reset_dut();

        @(negedge clk); ce = 1; data = 12'hFFF;
        @(negedge clk); ce = 0;

        @(negedge clk);
        a = 1;
        #2;
        #1;

        check_outputs(12'hFFF);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Verify data discard after 3 cycles", test_num);
        reset_dut();

        @(negedge clk); ce = 1; data = 12'h999;
        @(negedge clk); ce = 1; data = 12'h888;
        @(negedge clk); ce = 1; data = 12'h777;
        @(negedge clk); ce = 1; data = 12'h666;

        @(negedge clk);
        ce = 0;
        a = 2;
        #2;
        #1;

        check_outputs(12'h888);
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
        input [11:0] expected_q;
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
        $dumpvars(0,a, ce, clk, data, shift, q);
    end

endmodule
