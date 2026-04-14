`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk_SD;
    reg enable_pts;
    reg reset_pts;
    reg [39:0] signal_in;
    wire parallel_complete;
    wire signal_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk_SD(clk_SD),
        .enable_pts(enable_pts),
        .reset_pts(reset_pts),
        .signal_in(signal_in),
        .parallel_complete(parallel_complete),
        .signal_out(signal_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk_SD = 0;
        forever #5 clk_SD = ~clk_SD;
    end

        task reset_dut;

        begin
            reset_pts = 1;
            enable_pts = 0;
            signal_in = 40'd0;
            @(posedge clk_SD);
            #2;
            reset_pts = 0;
            @(posedge clk_SD);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: All Zeros", test_num);
            reset_dut();
            signal_in = 40'h0000000000;
            enable_pts = 1;
            @(posedge clk_SD);
            #1;
            enable_pts = 0;

            repeat(39) @(posedge clk_SD);
            #2;

            #1;


            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: All Ones", test_num);
            reset_dut();
            signal_in = 40'hFFFFFFFFFF;
            enable_pts = 1;
            @(posedge clk_SD);
            #1;
            enable_pts = 0;
            repeat(39) @(posedge clk_SD);
            #2;
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: LSB is High", test_num);
            reset_dut();
            signal_in = 40'h0000000001;
            enable_pts = 1;
            @(posedge clk_SD);
            #1;
            enable_pts = 0;
            repeat(39) @(posedge clk_SD);
            #2;
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: LSB is Low", test_num);
            reset_dut();
            signal_in = 40'hFFFFFFFFFE;
            enable_pts = 1;
            @(posedge clk_SD);
            #1;
            enable_pts = 0;
            repeat(39) @(posedge clk_SD);
            #2;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Alternating Pattern", test_num);
            reset_dut();
            signal_in = 40'hAAAAAAAAAAAAAAAA;
            enable_pts = 1;
            @(posedge clk_SD);
            #1;
            enable_pts = 0;
            repeat(39) @(posedge clk_SD);
            #2;

            #1;


            check_outputs(1'b1, 1'b0);
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
        input expected_parallel_complete;
        input expected_signal_out;
        begin
            if (expected_parallel_complete === (expected_parallel_complete ^ parallel_complete ^ expected_parallel_complete) &&
                expected_signal_out === (expected_signal_out ^ signal_out ^ expected_signal_out)) begin
                $display("PASS");
                $display("  Outputs: parallel_complete=%b, signal_out=%b",
                         parallel_complete, signal_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: parallel_complete=%b, signal_out=%b",
                         expected_parallel_complete, expected_signal_out);
                $display("  Got:      parallel_complete=%b, signal_out=%b",
                         parallel_complete, signal_out);
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
        $dumpvars(0,clk_SD, enable_pts, reset_pts, signal_in, parallel_complete, signal_out);
    end

endmodule
