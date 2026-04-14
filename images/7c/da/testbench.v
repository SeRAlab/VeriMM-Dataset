`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    reg reset_n;
    wire [7:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .enable(enable),
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
        @(negedge clk);
        reset_n = 0;
        enable = 0;
        @(negedge clk);
        reset_n = 1;
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Verify Reset", test_num);
        reset_dut();

        #1;


        check_outputs(8'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Basic increment (1 cycle)", test_num);
        reset_dut();
        @(negedge clk);
        enable = 1;
        @(negedge clk);
        enable = 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(8'h01);
    end
        endtask

    task testcase003;

    integer i;
    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Multiple increments (10 cycles)", test_num);
        reset_dut();
        @(negedge clk);
        enable = 1;
        for (i = 0; i < 10; i = i + 1) begin
            @(negedge clk);
        end
        enable = 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(8'd10);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Enable toggle (Pause counting)", test_num);
        reset_dut();
        @(negedge clk);
        enable = 1;
        repeat(5) @(negedge clk);
        enable = 0;
        repeat(5) @(negedge clk);
        @(posedge clk);
        #1;
        #1;

        check_outputs(8'd5);
    end
        endtask

    task testcase005;

    integer i;
    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Counter rollover (256 cycles)", test_num);
        reset_dut();
        @(negedge clk);
        enable = 1;
        for (i = 0; i < 256; i = i + 1) begin
            @(negedge clk);
        end
        enable = 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Synchronous reset mid-operation", test_num);
        reset_dut();
        @(negedge clk);
        enable = 1;
        repeat(10) @(negedge clk);
        reset_n = 0;
        @(negedge clk);
        reset_n = 1;
        enable = 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase007;

    integer i;
    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Verify max value (255)", test_num);
        reset_dut();
        @(negedge clk);
        enable = 1;
        for (i = 0; i < 255; i = i + 1) begin
            @(negedge clk);
        end
        enable = 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(8'hFF);
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
        input [7:0] expected_q;
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
        $dumpvars(0,clk, enable, reset_n, q);
    end

endmodule
