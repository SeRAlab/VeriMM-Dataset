`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg pulse1;
    reg pulse2;
    wire [7:0] tdc_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .pulse1(pulse1),
        .pulse2(pulse2),
        .tdc_out(tdc_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            pulse1 = 0;
            pulse2 = 0;
            repeat(5) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Running Test Case %0d: Short Delay (5 cycles)", test_num);
            reset_dut();

            @(posedge clk);
            pulse1 = 1;
            @(posedge clk);
            pulse1 = 0;

            repeat(4) @(posedge clk);

            pulse2 = 1;
            @(posedge clk);
            pulse2 = 0;


            repeat(2) @(posedge clk);
            #1;

            check_outputs(8'd5);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Running Test Case %0d: Medium Delay (15 cycles)", test_num);
            reset_dut();

            @(posedge clk);
            pulse1 = 1;
            @(posedge clk);
            pulse1 = 0;

            repeat(14) @(posedge clk);

            pulse2 = 1;
            @(posedge clk);
            pulse2 = 0;

            repeat(2) @(posedge clk);
            #1;

            check_outputs(8'd15);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Running Test Case %0d: Minimum Delay (1 cycle)", test_num);
            reset_dut();

            @(posedge clk);
            pulse1 = 1;
            @(posedge clk);
            pulse1 = 0;


            pulse2 = 1;
            @(posedge clk);
            pulse2 = 0;

            repeat(2) @(posedge clk);
            #1;

            check_outputs(8'd1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Running Test Case %0d: Long Delay (120 cycles)", test_num);
            reset_dut();

            @(posedge clk);
            pulse1 = 1;
            @(posedge clk);
            pulse1 = 0;

            repeat(119) @(posedge clk);

            pulse2 = 1;
            @(posedge clk);
            pulse2 = 0;

            repeat(2) @(posedge clk);
            #1;

            check_outputs(8'd120);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Running Test Case %0d: Max 8-bit Delay (255 cycles)", test_num);
            reset_dut();

            @(posedge clk);
            pulse1 = 1;
            @(posedge clk);
            pulse1 = 0;

            repeat(254) @(posedge clk);

            pulse2 = 1;
            @(posedge clk);
            pulse2 = 0;

            repeat(2) @(posedge clk);
            #1;

            check_outputs(8'd255);
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
        input [7:0] expected_tdc_out;
        begin
            if (expected_tdc_out === (expected_tdc_out ^ tdc_out ^ expected_tdc_out)) begin
                $display("PASS");
                $display("  Outputs: tdc_out=%h",
                         tdc_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: tdc_out=%h",
                         expected_tdc_out);
                $display("  Got:      tdc_out=%h",
                         tdc_out);
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
        $dumpvars(0,clk, pulse1, pulse2, tdc_out);
    end

endmodule
