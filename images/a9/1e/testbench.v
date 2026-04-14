`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [63:0] left_in;
    reg [63:0] right_in;
    reg select;
    wire [63:0] left_out;
    wire [63:0] right_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .left_in(left_in),
        .right_in(right_in),
        .select(select),
        .left_out(left_out),
        .right_out(right_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            left_in = 64'b0;
            right_in = 64'b0;
            select = 1'b0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Passthrough Mode (select=0)", test_num);
            reset_dut();
            left_in  = 64'hFEDCBA9876543210;
            right_in = 64'h0123456789ABCDEF;
            select   = 1'b0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(64'hFEDCBA9876543210, 64'h0123456789ABCDEF);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Swap Mode (select=1)", test_num);
            reset_dut();
            left_in  = 64'hFEDCBA9876543210;
            right_in = 64'h0123456789ABCDEF;
            select   = 1'b1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(64'h0123456789ABCDEF, 64'hFEDCBA9876543210);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Boundary Values Passthrough (All 1s and All 0s)", test_num);
            reset_dut();
            left_in  = 64'hFFFFFFFFFFFFFFFF;
            right_in = 64'h0000000000000000;
            select   = 1'b0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(64'hFFFFFFFFFFFFFFFF, 64'h0000000000000000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Boundary Values Swap (All 1s and All 0s)", test_num);
            reset_dut();
            left_in  = 64'hFFFFFFFFFFFFFFFF;
            right_in = 64'h0000000000000000;
            select   = 1'b1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(64'h0000000000000000, 64'hFFFFFFFFFFFFFFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Alternating Bits Swap", test_num);
            reset_dut();
            left_in  = 64'hAAAAAAAAAAAAAAAA;
            right_in = 64'h5555555555555555;
            select   = 1'b1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(64'h5555555555555555, 64'hAAAAAAAAAAAAAAAA);
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
        input [63:0] expected_left_out;
        input [63:0] expected_right_out;
        begin
            if (expected_left_out === (expected_left_out ^ left_out ^ expected_left_out) &&
                expected_right_out === (expected_right_out ^ right_out ^ expected_right_out)) begin
                $display("PASS");
                $display("  Outputs: left_out=%h, right_out=%h",
                         left_out, right_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: left_out=%h, right_out=%h",
                         expected_left_out, expected_right_out);
                $display("  Got:      left_out=%h, right_out=%h",
                         left_out, right_out);
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
        $dumpvars(0,clk, left_in, right_in, select, left_out, right_out);
    end

endmodule
