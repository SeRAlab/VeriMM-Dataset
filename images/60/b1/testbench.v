`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst_n;
    wire out_50Hz;
    wire out_50Hz_pulse;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .rst_n(rst_n),
        .out_50Hz(out_50Hz),
        .out_50Hz_pulse(out_50Hz_pulse)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 1'b0;
            #20;
            rst_n = 1'b1;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Reset State Verification", test_num);
            reset_dut();

            #1;


            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Stability Check before first toggle (5ms)", test_num);
            reset_dut();
            repeat(500000) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: 50Hz Square Wave Toggle Check (10ms)", test_num);
            reset_dut();

            repeat(1000000) @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: 50Hz Pulse and Full Cycle Check (20ms)", test_num);
            reset_dut();

            repeat(2000000) @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Pulse Duration Check", test_num);
            reset_dut();
            repeat(2000000) @(posedge clk);
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, 1'b0);
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
        input expected_out_50Hz;
        input expected_out_50Hz_pulse;
        begin
            if (expected_out_50Hz === (expected_out_50Hz ^ out_50Hz ^ expected_out_50Hz) &&
                expected_out_50Hz_pulse === (expected_out_50Hz_pulse ^ out_50Hz_pulse ^ expected_out_50Hz_pulse)) begin
                $display("PASS");
                $display("  Outputs: out_50Hz=%b, out_50Hz_pulse=%b",
                         out_50Hz, out_50Hz_pulse);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_50Hz=%b, out_50Hz_pulse=%b",
                         expected_out_50Hz, expected_out_50Hz_pulse);
                $display("  Got:      out_50Hz=%b, out_50Hz_pulse=%b",
                         out_50Hz, out_50Hz_pulse);
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
        $dumpvars(0,clk, rst_n, out_50Hz, out_50Hz_pulse);
    end

endmodule
