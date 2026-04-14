`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg rst_n;
    wire [15:0] BCD4;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data_in(data_in),
        .rst_n(rst_n),
        .BCD4(BCD4)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst_n = 0;
        data_in = 0;
        repeat(5) @(posedge clk);
        #2 rst_n = 1;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Input = 0", test_num);
        reset_dut();
        data_in = 8'd0;

        #INTERVAL;
        repeat(2) @(posedge clk);
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Input = 123", test_num);
        reset_dut();
        data_in = 8'd123;
        #INTERVAL;
        repeat(2) @(posedge clk);

        #1;


        check_outputs(16'h0123);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Input = 255", test_num);
        reset_dut();
        data_in = 8'd255;
        #INTERVAL;
        repeat(2) @(posedge clk);

        #1;


        check_outputs(16'h0255);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Input = 99", test_num);
        reset_dut();
        data_in = 8'd99;
        #INTERVAL;
        repeat(2) @(posedge clk);
        #1;

        check_outputs(16'h0099);
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
        input [15:0] expected_BCD4;
        begin
            if (expected_BCD4 === (expected_BCD4 ^ BCD4 ^ expected_BCD4)) begin
                $display("PASS");
                $display("  Outputs: BCD4=%h",
                         BCD4);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: BCD4=%h",
                         expected_BCD4);
                $display("  Got:      BCD4=%h",
                         BCD4);
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
        $dumpvars(0,clk, data_in, rst_n, BCD4);
    end

endmodule
