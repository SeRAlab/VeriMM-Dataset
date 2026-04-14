`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    wire clk_2cpu;
    wire clk_cpu;
    wire clk_vga;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .rst(rst),
        .clk_2cpu(clk_2cpu),
        .clk_cpu(clk_cpu),
        .clk_vga(clk_vga)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            $display("  Resetting DUT...");
            rst = 1;
            repeat(10) @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Initialization Check", test_num);
            reset_dut();

            #1;


            check_outputs(1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Post-Reset Stability Check (1000 cycles)", test_num);
            reset_dut();
            repeat(1000) @(posedge clk);

            #1;


            check_outputs(1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Persistent Reset Check", test_num);
            reset_dut();
            rst = 1;
            repeat(500) @(posedge clk);

            #1;


            check_outputs(1'b0, 1'b0, 1'b0);
            rst = 0;
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Synchronous Start Check", test_num);
            reset_dut();

            repeat(5) @(posedge clk);
            #1;

            check_outputs(1'b0, 1'b0, 1'b0);
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
        input expected_clk_2cpu;
        input expected_clk_cpu;
        input expected_clk_vga;
        begin
            if (expected_clk_2cpu === (expected_clk_2cpu ^ clk_2cpu ^ expected_clk_2cpu) &&
                expected_clk_cpu === (expected_clk_cpu ^ clk_cpu ^ expected_clk_cpu) &&
                expected_clk_vga === (expected_clk_vga ^ clk_vga ^ expected_clk_vga)) begin
                $display("PASS");
                $display("  Outputs: clk_2cpu=%b, clk_cpu=%b, clk_vga=%b",
                         clk_2cpu, clk_cpu, clk_vga);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: clk_2cpu=%b, clk_cpu=%b, clk_vga=%b",
                         expected_clk_2cpu, expected_clk_cpu, expected_clk_vga);
                $display("  Got:      clk_2cpu=%b, clk_cpu=%b, clk_vga=%b",
                         clk_2cpu, clk_cpu, clk_vga);
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
        $dumpvars(0,clk, rst, clk_2cpu, clk_cpu, clk_vga);
    end

endmodule
