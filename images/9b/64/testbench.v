`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk_dst;
    reg rst_dst;
    reg signal_src;
    wire signal_dst;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk_dst(clk_dst),
        .rst_dst(rst_dst),
        .signal_src(signal_src),
        .signal_dst(signal_dst)
    );

    // Clock generation (10ns period)
    initial begin
        clk_dst = 0;
        forever #5 clk_dst = ~clk_dst;
    end

        task reset_dut;

        begin
            @(posedge clk_dst);
            rst_dst = 1;
            signal_src = 0;
            repeat(2) @(posedge clk_dst);
            #1 rst_dst = 0;
            $display("Reset sequence completed.");
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %03d: Synchronizing LOW to HIGH transition", test_num);
            reset_dut();

            @(posedge clk_dst);
            signal_src = 1;


            @(posedge clk_dst);
            #1;


            @(posedge clk_dst);
            #1;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %03d: Synchronizing HIGH to LOW transition", test_num);
            reset_dut();


            @(posedge clk_dst);
            signal_src = 1;
            repeat(3) @(posedge clk_dst);


            @(posedge clk_dst);
            signal_src = 0;


            repeat(2) @(posedge clk_dst);
            #1;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %03d: Reset dominance", test_num);
            reset_dut();

            @(posedge clk_dst);
            signal_src = 1;
            @(posedge clk_dst);

            @(posedge clk_dst);
            rst_dst = 1;

            @(posedge clk_dst);
            #1;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %03d: Short pulse propagation", test_num);
            reset_dut();

            @(posedge clk_dst);
            signal_src = 1;
            @(posedge clk_dst);
            signal_src = 0;


            @(posedge clk_dst);

            @(posedge clk_dst);
            #1;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %03d: Stability check", test_num);
            reset_dut();

            @(posedge clk_dst);
            signal_src = 1;
            repeat(5) @(posedge clk_dst);
            #1;

            #1;


            check_outputs(1'b1);
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
        input expected_signal_dst;
        begin
            if (expected_signal_dst === (expected_signal_dst ^ signal_dst ^ expected_signal_dst)) begin
                $display("PASS");
                $display("  Outputs: signal_dst=%b",
                         signal_dst);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: signal_dst=%b",
                         expected_signal_dst);
                $display("  Got:      signal_dst=%b",
                         signal_dst);
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
        $dumpvars(0,clk_dst, rst_dst, signal_src, signal_dst);
    end

endmodule
