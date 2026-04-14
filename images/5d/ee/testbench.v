`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [19:0] data_in;
    reg reset_n;
    wire [19:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data_in(data_in),
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
        reset_n = 0;
        data_in = 20'h0;
        @(posedge clk);
        #1;
        reset_n = 1;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Synchronous Reset", test_num);
        data_in = 20'hFFFFF;
        reset_n = 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(20'h00000);
        reset_n = 1;
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Load Pattern 0xAAAAA", test_num);
        reset_dut();
        data_in = 20'hAAAAA;
        @(posedge clk);
        #1;
        #1;

        check_outputs(20'hAAAAA);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Load Pattern 0x55555", test_num);
        reset_dut();
        data_in = 20'h55555;
        @(posedge clk);
        #1;
        #1;

        check_outputs(20'h55555);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Load All Ones", test_num);
        reset_dut();
        data_in = 20'hFFFFF;
        @(posedge clk);
        #1;
        #1;

        check_outputs(20'hFFFFF);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Load All Zeros", test_num);
        reset_dut();

        data_in = 20'h12345;
        @(posedge clk);
        #1;

        data_in = 20'h00000;
        @(posedge clk);
        #1;
        #1;

        check_outputs(20'h00000);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Reset Priority", test_num);
        reset_dut();

        data_in = 20'hABCDE;
        reset_n = 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(20'h00000);
        reset_n = 1;
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
        input [19:0] expected_q;
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
        $dumpvars(0,clk, data_in, reset_n, q);
    end

endmodule
