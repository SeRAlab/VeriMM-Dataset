`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst_n;
    wire [15:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .rst_n(rst_n),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst_n = 0;
        @(posedge clk);
        #2 rst_n = 1;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Reset Check", test_num);
        reset_dut();

        #1;


        check_outputs(16'h0000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: 1 Clock Cycle", test_num);
        reset_dut();
        @(posedge clk);
        #2;
        #1;

        check_outputs(16'h0001);
    end
        endtask

    task testcase003;

    integer i;
    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: 8 Clock Cycles", test_num);
        reset_dut();
        for (i = 0; i < 8; i = i + 1) begin
            @(posedge clk);
        end
        #2;
        #1;

        check_outputs(16'h00FF);
    end
        endtask

    task testcase004;

    integer i;
    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: 16 Clock Cycles (All Ones)", test_num);
        reset_dut();
        for (i = 0; i < 16; i = i + 1) begin
            @(posedge clk);
        end
        #2;
        #1;

        check_outputs(16'hFFFF);
    end
        endtask

    task testcase005;

    integer i;
    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: 17 Clock Cycles (First Zero)", test_num);
        reset_dut();
        for (i = 0; i < 17; i = i + 1) begin
            @(posedge clk);
        end
        #2;
        #1;

        check_outputs(16'hFFFE);
    end
        endtask

    task testcase006;

    integer i;
    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: 24 Clock Cycles", test_num);
        reset_dut();
        for (i = 0; i < 24; i = i + 1) begin
            @(posedge clk);
        end
        #2;
        #1;

        check_outputs(16'hFF00);
    end
        endtask

    task testcase007;

    integer i;
    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: 31 Clock Cycles", test_num);
        reset_dut();
        for (i = 0; i < 31; i = i + 1) begin
            @(posedge clk);
        end
        #2;
        #1;

        check_outputs(16'h8000);
    end
        endtask

    task testcase008;

    integer i;
    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: 32 Clock Cycles (Full Cycle Complete)", test_num);
        reset_dut();
        for (i = 0; i < 32; i = i + 1) begin
            @(posedge clk);
        end
        #2;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase009;

    integer i;
    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: 33 Clock Cycles", test_num);
        reset_dut();
        for (i = 0; i < 33; i = i + 1) begin
            @(posedge clk);
        end
        #2;
        #1;

        check_outputs(16'h0001);
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
        input [15:0] expected_Q;
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q)) begin
                $display("PASS");
                $display("  Outputs: Q=%h",
                         Q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%h",
                         expected_Q);
                $display("  Got:      Q=%h",
                         Q);
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
        $dumpvars(0,clk, rst_n, Q);
    end

endmodule
