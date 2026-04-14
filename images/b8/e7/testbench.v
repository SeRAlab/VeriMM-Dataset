`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clear;
    reg clk;
    reg [31:0] data;
    reg enable;
    wire [31:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clear(clear),
        .clk(clk),
        .data(data),
        .enable(enable),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        @(posedge clk);
        clear <= 1;
        enable <= 0;
        data <= 0;
        @(posedge clk);
        clear <= 0;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Synchronous Clear Verification", test_num);
        reset_dut();

        #1;


        check_outputs(32'h00000000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Data Loading with Enable", test_num);
        reset_dut();
        @(posedge clk);
        enable <= 1;
        data <= 32'hDEADBEEF;
        @(posedge clk);
        enable <= 0;
        #1;

        check_outputs(32'hDEADBEEF);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Data Retention (Enable=0)", test_num);
        reset_dut();
        @(posedge clk);
        enable <= 1;
        data <= 32'hAAAA5555;
        @(posedge clk);
        enable <= 0;
        data <= 32'hFFFFFFFF;
        @(posedge clk);

        #1;


        check_outputs(32'hAAAA5555);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Clear Priority over Enable", test_num);
        reset_dut();
        @(posedge clk);
        enable <= 1;
        data <= 32'h12345678;
        @(posedge clk);

        clear <= 1;
        enable <= 1;
        data <= 32'h87654321;
        @(posedge clk);
        clear <= 0;
        enable <= 0;

        #1;


        check_outputs(32'h00000000);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: All-Ones Data Load", test_num);
        reset_dut();
        @(posedge clk);
        enable <= 1;
        data <= 32'hFFFFFFFF;
        @(posedge clk);
        enable <= 0;
        #1;

        check_outputs(32'hFFFFFFFF);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Sequential Loading", test_num);
        reset_dut();
        @(posedge clk);
        enable <= 1;
        data <= 32'h11111111;
        @(posedge clk);
        data <= 32'h22222222;
        @(posedge clk);
        data <= 32'h33333333;
        @(posedge clk);
        enable <= 0;
        #1;

        check_outputs(32'h33333333);
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
        input [31:0] expected_q;
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
        $dumpvars(0,clear, clk, data, enable, q);
    end

endmodule
