`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg count_en;
    reg [31:0] max_count;
    reg reset;
    wire [31:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .count_en(count_en),
        .max_count(max_count),
        .reset(reset),
        .count(count)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        count_en = 0;
        max_count = 32'hFFFFFFFF;
        @(posedge clk);
        #1 reset = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %03d: Basic Counting to 10", test_num);
        reset_dut();
        max_count = 32'd100;
        count_en = 1;
        repeat(10) @(posedge clk);
        #1 #1;
 check_outputs(32'd10);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %03d: Wrap Around at Max Count (5)", test_num);
        reset_dut();
        max_count = 32'd5;
        count_en = 1;

        repeat(6) @(posedge clk);
        #1 #1;
 check_outputs(32'd0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %03d: Count Enable Toggle", test_num);
        reset_dut();
        max_count = 32'd100;
        count_en = 1;
        repeat(5) @(posedge clk);
        count_en = 0;
        repeat(10) @(posedge clk);
        #1 #1;
 check_outputs(32'd5);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %03d: Reset during operation", test_num);
        reset_dut();
        max_count = 32'd100;
        count_en = 1;
        repeat(20) @(posedge clk);
        reset = 1;
        @(posedge clk);
        reset = 0;
        #1 #1;
 check_outputs(32'd0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %03d: Minimum Max Count (1)", test_num);
        reset_dut();
        max_count = 32'd1;
        count_en = 1;
        repeat(1) @(posedge clk);
        #1 #1;
 check_outputs(32'd1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %03d: Wrap after Min Max Count", test_num);
        reset_dut();
        max_count = 32'd1;
        count_en = 1;
        repeat(2) @(posedge clk);
        #1 #1;
 check_outputs(32'd0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %03d: Max Count is 0", test_num);
        reset_dut();
        max_count = 32'd0;
        count_en = 1;
        repeat(5) @(posedge clk);
        #1 #1;
 check_outputs(32'd0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %03d: Dynamic Max Count Change", test_num);
        reset_dut();
        max_count = 32'd20;
        count_en = 1;
        repeat(5) @(posedge clk);
        max_count = 32'd6;
        repeat(2) @(posedge clk);
        #1 #1;
 check_outputs(32'd0);
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
        input [31:0] expected_count;
        begin
            if (expected_count === (expected_count ^ count ^ expected_count)) begin
                $display("PASS");
                $display("  Outputs: count=%h",
                         count);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count=%h",
                         expected_count);
                $display("  Got:      count=%h",
                         count);
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
        $dumpvars(0,clk, count_en, max_count, reset, count);
    end

endmodule
