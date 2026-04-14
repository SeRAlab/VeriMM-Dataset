`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg async_clear;
    reg clk;
    reg en;
    wire [5:0] counter;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .async_clear(async_clear),
        .clk(clk),
        .en(en),
        .counter(counter)
    );

    // Clock generation (10ns period)
    initial begin
        async_clear = 0;
        forever #5 async_clear = ~async_clear;
    end

        task reset_dut;

        begin
            en = 0;
            async_clear = 1;
            #15;
            async_clear = 0;
            #5;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            #1;


            check_outputs(6'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            en = 1;

            repeat (10) @(posedge clk);
            #1;
            #1;

            check_outputs(6'd10);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            en = 1;
            repeat (5) @(posedge clk);
            en = 0;
            repeat (5) @(posedge clk);
            #1;
            #1;

            check_outputs(6'd5);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            en = 1;

            repeat (64) @(posedge clk);
            #1;
            #1;

            check_outputs(6'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            en = 1;
            repeat (20) @(posedge clk);


            #3;
            async_clear = 1;
            #1;
            #1;

            check_outputs(6'd0);
            async_clear = 0;
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
        input [5:0] expected_counter;
        begin
            if (expected_counter === (expected_counter ^ counter ^ expected_counter)) begin
                $display("PASS");
                $display("  Outputs: counter=%h",
                         counter);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: counter=%h",
                         expected_counter);
                $display("  Got:      counter=%h",
                         counter);
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
        $dumpvars(0,async_clear, clk, en, counter);
    end

endmodule
