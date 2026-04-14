`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg next;
    reg rst;
    reg [31:0] seed;
    wire [9:0] num;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .next(next),
        .rst(rst),
        .seed(seed),
        .num(num)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            next = 0;
            rst = 1;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Initial Reset and Seed Load", test_num);
            seed = 32'hA5A5A5A5;
            reset_dut();

            #1;


            check_outputs(num);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Single Step Generation", test_num);
            seed = 32'h12345678;
            reset_dut();
            prev_val = num;

            @(posedge clk);
            next = 1;
            @(posedge clk);
            next = 0;
            @(posedge clk);


            if (num != prev_val)
                #1;

                check_outputs(num);
            else begin
                $display("FAIL: Output did not change after 'next' signal");
                fail_count = fail_count + 1;
            end
        end
        endtask

    task testcase003;

        reg [9:0] first_run_val;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Sequence Reproducibility", test_num);


            seed = 32'hDEADBEEF;
            reset_dut();
            next = 1;
            @(posedge clk);
            next = 0;
            @(posedge clk);
            first_run_val = num;


            reset_dut();
            next = 1;
            @(posedge clk);
            next = 0;
            @(posedge clk);

            #1;


            check_outputs(first_run_val);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Output Stability (next=0)", test_num);
            seed = 32'h98765432;
            reset_dut();
            prev_val = num;

            repeat(5) @(posedge clk);

            #1;


            check_outputs(prev_val);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Multi-step Sequence", test_num);
            seed = 32'h01020304;
            reset_dut();

            next = 1;
            repeat(10) @(posedge clk);
            next = 0;
            @(posedge clk);


            #1;



            check_outputs(num);
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
        input [9:0] expected_num;
        begin
            if (expected_num === (expected_num ^ num ^ expected_num)) begin
                $display("PASS");
                $display("  Outputs: num=%h",
                         num);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: num=%h",
                         expected_num);
                $display("  Got:      num=%h",
                         num);
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
        $dumpvars(0,clk, next, rst, seed, num);
    end

endmodule
