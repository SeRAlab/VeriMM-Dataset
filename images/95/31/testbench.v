`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [1:0] a;
    reg ce;
    reg clk;
    reg [15:0] data;
    wire [15:0] q;

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
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        ce = 1;
        data = 16'h0000;
        a = 2'b00;
        repeat(4) @(posedge clk);
        ce = 0;
        @(negedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Reading oldest data (Address 2)", test_num);
        reset_dut();
        @(negedge clk);
        ce = 1; data = 16'hAAAA; @(negedge clk);
        ce = 1; data = 16'hBBBB; @(negedge clk);
        ce = 1; data = 16'hCCCC; @(negedge clk);
        ce = 0; a = 2'd2;
        #1;
        #1;

        check_outputs(16'hAAAA);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Reading middle data (Address 1)", test_num);
        reset_dut();
        @(negedge clk);
        ce = 1; data = 16'h1111; @(negedge clk);
        ce = 1; data = 16'h2222; @(negedge clk);
        ce = 1; data = 16'h3333; @(negedge clk);
        ce = 0; a = 2'd1;
        #1;
        #1;

        check_outputs(16'h2222);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Reading newest data (Address 0)", test_num);
        reset_dut();
        @(negedge clk);
        ce = 1; data = 16'hDEAD; @(negedge clk);
        ce = 1; data = 16'hBEEF; @(negedge clk);
        ce = 1; data = 16'hCAFE; @(negedge clk);
        ce = 0; a = 2'd0;
        #1;
        #1;

        check_outputs(16'hCAFE);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Verify chip enable (ce) behavior", test_num);
        reset_dut();
        @(negedge clk);
        ce = 1; data = 16'h1234; @(negedge clk);
        ce = 0; data = 16'h5678; @(negedge clk);
        ce = 1; data = 16'h9ABC; @(negedge clk);
        ce = 0; a = 2'd1;
        #1;
        #1;

        check_outputs(16'h1234);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Overflow check (depth of 3)", test_num);
        reset_dut();
        @(negedge clk);
        ce = 1; data = 16'hD1; @(negedge clk);
        ce = 1; data = 16'hD2; @(negedge clk);
        ce = 1; data = 16'hD3; @(negedge clk);
        ce = 1; data = 16'hD4; @(negedge clk);
        ce = 0; a = 2'd2;
        #1;
        #1;

        check_outputs(16'hD2);
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
        $dumpvars(0,a, ce, clk, data, q);
    end

endmodule
