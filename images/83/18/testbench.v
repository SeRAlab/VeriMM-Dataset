`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg ce;
    reg clk;
    reg ctrl;
    reg rst_n;
    wire borrow;
    wire [3:0] count;
    wire tc;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ce(ce),
        .clk(clk),
        .ctrl(ctrl),
        .rst_n(rst_n),
        .borrow(borrow),
        .count(count),
        .tc(tc)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            ce = 0;
            ctrl = 0;
            #15;
            rst_n = 1;
            #5;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Asynchronous Reset Check", test_num);
            reset_dut();
            @(negedge clk);
            #1;

            check_outputs(1'b0, 4'h0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Incrementing Up", test_num);
            reset_dut();
            ce = 1;
            ctrl = 0;
            repeat(5) @(posedge clk);
            @(negedge clk);
            #1;

            check_outputs(1'b0, 4'h5, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Chip Enable (ce) Disable Check", test_num);
            reset_dut();
            ce = 1;
            ctrl = 0;
            repeat(3) @(posedge clk);
            ce = 0;
            repeat(3) @(posedge clk);
            @(negedge clk);
            #1;

            check_outputs(1'b0, 4'h3, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Terminal Count (tc) Flag Check", test_num);
            reset_dut();
            ce = 1;
            ctrl = 0;
            repeat(15) @(posedge clk);
            @(negedge clk);
            #1;

            check_outputs(1'b0, 4'hF, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Borrow Flag Check (Down from 0)", test_num);
            reset_dut();

            ce = 1;
            ctrl = 1;
            repeat(16) @(posedge clk);
            @(negedge clk);
            #1;

            check_outputs(1'b1, 4'h0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Direction Switching", test_num);
            reset_dut();
            ce = 1;
            ctrl = 0;
            repeat(10) @(posedge clk);
            ctrl = 1;
            repeat(4) @(posedge clk);
            @(negedge clk);
            #1;

            check_outputs(1'b0, 4'h6, 1'b0);
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
        input expected_borrow;
        input [3:0] expected_count;
        input expected_tc;
        begin
            if (expected_borrow === (expected_borrow ^ borrow ^ expected_borrow) &&
                expected_count === (expected_count ^ count ^ expected_count) &&
                expected_tc === (expected_tc ^ tc ^ expected_tc)) begin
                $display("PASS");
                $display("  Outputs: borrow=%b, count=%h, tc=%b",
                         borrow, count, tc);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: borrow=%b, count=%h, tc=%b",
                         expected_borrow, expected_count, expected_tc);
                $display("  Got:      borrow=%b, count=%h, tc=%b",
                         borrow, count, tc);
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
        $dumpvars(0,ce, clk, ctrl, rst_n, borrow, count, tc);
    end

endmodule
