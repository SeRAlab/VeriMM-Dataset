`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk_in;
    reg en_clk_div8;
    reg rst_async_n;
    wire clk_div2;
    wire clk_div4;
    wire clk_div8;
    wire clk_div8_proc;
    wire clk_out;
    wire rst_sync_n;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk_in(clk_in),
        .en_clk_div8(en_clk_div8),
        .rst_async_n(rst_async_n),
        .clk_div2(clk_div2),
        .clk_div4(clk_div4),
        .clk_div8(clk_div8),
        .clk_div8_proc(clk_div8_proc),
        .clk_out(clk_out),
        .rst_sync_n(rst_sync_n)
    );

    // Clock generation (10ns period)
    initial begin
        clk_in = 0;
        forever #5 clk_in = ~clk_in;
    end

        task reset_dut;

        begin
            rst_async_n = 0;
            en_clk_div8 = 0;
            repeat(3) @(posedge clk_in);
            #1 rst_async_n = 1;

            repeat(3) @(posedge clk_in);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Verifying Reset State", test_num);
            rst_async_n = 0;
            en_clk_div8 = 0;
            repeat(2) @(posedge clk_in);
            #2;


            #1;



            check_outputs(0, 0, 0, 0, clk_in, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Counter at 7 (111) with Enable ON", test_num);
            reset_dut();
            en_clk_div8 = 1;

            repeat(7) @(posedge clk_in);
            #2;

            #1;


            check_outputs(1, 1, 1, 1, clk_in, 1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Counter at 7 (111) with Enable OFF", test_num);
            reset_dut();
            en_clk_div8 = 0;
            repeat(7) @(posedge clk_in);
            #2;

            #1;


            check_outputs(1, 1, 1, 0, clk_in, 1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Counter at 3 (011)", test_num);
            reset_dut();
            en_clk_div8 = 1;
            repeat(3) @(posedge clk_in);
            #2;

            #1;


            check_outputs(1, 1, 0, 0, clk_in, 1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: Counter at 4 (100)", test_num);
            reset_dut();
            en_clk_div8 = 1;
            repeat(4) @(posedge clk_in);
            #2;

            #1;


            check_outputs(0, 0, 1, 1, clk_in, 1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTestcase %0d: Counter Wrap-around to 0 (000)", test_num);
            reset_dut();
            en_clk_div8 = 1;
            repeat(8) @(posedge clk_in);
            #2;

            #1;


            check_outputs(0, 0, 0, 0, clk_in, 1);
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
        input expected_clk_div2;
        input expected_clk_div4;
        input expected_clk_div8;
        input expected_clk_div8_proc;
        input expected_clk_out;
        input expected_rst_sync_n;
        begin
            if (expected_clk_div2 === (expected_clk_div2 ^ clk_div2 ^ expected_clk_div2) &&
                expected_clk_div4 === (expected_clk_div4 ^ clk_div4 ^ expected_clk_div4) &&
                expected_clk_div8 === (expected_clk_div8 ^ clk_div8 ^ expected_clk_div8) &&
                expected_clk_div8_proc === (expected_clk_div8_proc ^ clk_div8_proc ^ expected_clk_div8_proc) &&
                expected_clk_out === (expected_clk_out ^ clk_out ^ expected_clk_out) &&
                expected_rst_sync_n === (expected_rst_sync_n ^ rst_sync_n ^ expected_rst_sync_n)) begin
                $display("PASS");
                $display("  Outputs: clk_div2=%b, clk_div4=%b, clk_div8=%b, clk_div8_proc=%b, clk_out=%b, rst_sync_n=%b",
                         clk_div2, clk_div4, clk_div8, clk_div8_proc, clk_out, rst_sync_n);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: clk_div2=%b, clk_div4=%b, clk_div8=%b, clk_div8_proc=%b, clk_out=%b, rst_sync_n=%b",
                         expected_clk_div2, expected_clk_div4, expected_clk_div8, expected_clk_div8_proc, expected_clk_out, expected_rst_sync_n);
                $display("  Got:      clk_div2=%b, clk_div4=%b, clk_div8=%b, clk_div8_proc=%b, clk_out=%b, rst_sync_n=%b",
                         clk_div2, clk_div4, clk_div8, clk_div8_proc, clk_out, rst_sync_n);
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
        $dumpvars(0,clk_in, en_clk_div8, rst_async_n, clk_div2, clk_div4, clk_div8, clk_div8_proc, clk_out, rst_sync_n);
    end

endmodule
