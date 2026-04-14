`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg areset;
    reg clk;
    reg [3:0] data;
    reg ena;
    reg load;
    wire [3:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .areset(areset),
        .clk(clk),
        .data(data),
        .ena(ena),
        .load(load),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        areset = 1;
        load = 0;
        ena = 0;
        data = 4'b0;
        #15;
        areset = 0;
        #5;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Async Reset Check", test_num);
        reset_dut();
        #1;

        check_outputs(4'b0000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Load with Enable", test_num);
        reset_dut();
        data = 4'b1000; load = 1; ena = 1;
        @(posedge clk);
        #2;
        #1;

        check_outputs(4'b1000);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Load without Enable", test_num);
        reset_dut();
        data = 4'b1000; load = 1; ena = 0;
        @(posedge clk);
        #2;
        #1;

        check_outputs(4'b1000);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Single Shift Operation", test_num);
        reset_dut();

        data = 4'b1000; load = 1; ena = 1;
        @(posedge clk); #2;

        load = 0; ena = 1;
        @(posedge clk); #2;
        #1;

        check_outputs(4'b0100);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Multiple Shifts", test_num);
        reset_dut();
        data = 4'b1000; load = 1; ena = 1;
        @(posedge clk); #2;
        load = 0; ena = 1;
        repeat(3) @(posedge clk);
        #2;
        #1;

        check_outputs(4'b0001);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Shift until Empty", test_num);
        reset_dut();
        data = 4'b1000; load = 1; ena = 1;
        @(posedge clk); #2;
        load = 0; ena = 1;
        repeat(4) @(posedge clk);
        #2;
        #1;

        check_outputs(4'b0000);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Hold Functionality", test_num);
        reset_dut();
        data = 4'b1000; load = 1; ena = 1;
        @(posedge clk); #2;
        load = 0; ena = 0;
        repeat(2) @(posedge clk);
        #2;
        #1;

        check_outputs(4'b1000);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Load without Enable on Non-Zero Reg", test_num);
        reset_dut();

        data = 4'b1000; load = 1; ena = 1;
        @(posedge clk); #2;
        load = 0; ena = 1;
        @(posedge clk); #2;

        data = 4'b1000; load = 1; ena = 0;
        @(posedge clk); #2;
        #1;

        check_outputs(4'b1100);
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
        input [3:0] expected_q;
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
        $dumpvars(0,areset, clk, data, ena, load, q);
    end

endmodule
