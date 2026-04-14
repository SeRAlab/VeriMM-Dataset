`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg aload;
    reg clk;
    reg [6:0] load_val;
    wire [6:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .aload(aload),
        .clk(clk),
        .load_val(load_val),
        .count(count)
    );

    // Clock generation (10ns period)
    initial begin
        aload = 0;
        forever #5 aload = ~aload;
    end

        task reset_dut;

        begin
            aload = 1;
            load_val = 7'h00;
            #10;
            aload = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Async Load", test_num);
            aload = 1;
            load_val = 7'd75;
            #2;
            aload = 0;
            #1;
            #1;

            check_outputs(7'd75);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Single Decrement", test_num);
            aload = 1;
            load_val = 7'd50;
            #2;
            aload = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(7'd49);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Multiple Decrements (5 cycles)", test_num);
            aload = 1;
            load_val = 7'd10;
            #2;
            aload = 0;
            repeat(5) @(posedge clk);
            #1;
            #1;

            check_outputs(7'd5);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Underflow Wraparound", test_num);
            aload = 1;
            load_val = 7'd1;
            #2;
            aload = 0;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(7'd127);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Async Load Priority", test_num);
            aload = 0;
            @(posedge clk);
            #3;
            aload = 1;
            load_val = 7'h2A;
            #1;
            #1;

            check_outputs(7'h2A);
            aload = 0;
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Decrement to Zero", test_num);
            aload = 1;
            load_val = 7'd5;
            #2;
            aload = 0;
            repeat(5) @(posedge clk);
            #1;
            #1;

            check_outputs(7'd0);
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
        input [6:0] expected_count;
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
        $dumpvars(0,aload, clk, load_val, count);
    end

endmodule
