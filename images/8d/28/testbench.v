`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [12:0] d;
    reg reset;
    wire [12:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .d(d),
        .reset(reset),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        d = 13'd0;
        #15;
        reset = 0;
        #5;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %03d: Initial Reset Check", test_num);
        reset_dut();
        #1;

        check_outputs(13'h0000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %03d: Single Addition (0 + 10)", test_num);
        reset_dut();
        @(negedge clk);
        d = 13'd10;
        @(posedge clk);
        #2;
        #1;

        check_outputs(13'd10);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %03d: Multiple Accumulation (10 + 20 + 30)", test_num);
        reset_dut();
        @(negedge clk) d = 13'd10;
        @(negedge clk) d = 13'd20;
        @(negedge clk) d = 13'd30;
        @(posedge clk);
        #2;
        #1;

        check_outputs(13'd60);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %03d: Adding Zero", test_num);
        reset_dut();
        @(negedge clk) d = 13'd100;
        @(negedge clk) d = 13'd0;
        @(posedge clk);
        #2;
        #1;

        check_outputs(13'd100);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %03d: Overflow (Max + 1)", test_num);
        reset_dut();
        @(negedge clk) d = 13'h1FFF;
        @(negedge clk) d = 13'h0001;
        @(posedge clk);
        #2;
        #1;

        check_outputs(13'h0000);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %03d: Asynchronous Reset Mid-Cycle", test_num);
        reset_dut();
        @(negedge clk) d = 13'd500;
        @(posedge clk);
        #2;
        reset = 1;
        #1;
        #1;

        check_outputs(13'h0000);
        reset = 0;
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %03d: Large Values", test_num);
        reset_dut();
        @(negedge clk) d = 13'd4000;
        @(negedge clk) d = 13'd4000;
        @(posedge clk);
        #2;
        #1;

        check_outputs(13'd8000);
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
        input [12:0] expected_q;
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
        $dumpvars(0,clk, d, reset, q);
    end

endmodule
