`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg branch;
    reg branchInit;
    reg cacheStall;
    reg clk;
    reg forwardStall;
    reg rst_n;
    wire flush;
    wire globalStall;
    wire stall;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .branch(branch),
        .branchInit(branchInit),
        .cacheStall(cacheStall),
        .clk(clk),
        .forwardStall(forwardStall),
        .rst_n(rst_n),
        .flush(flush),
        .globalStall(globalStall),
        .stall(stall)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            branch = 0;
            branchInit = 0;
            cacheStall = 0;
            forwardStall = 0;
            repeat(2) @(posedge clk);
            #1 rst_n = 1;
            repeat(1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            branch = 0; branchInit = 0; forwardStall = 0; cacheStall = 0;
            @(posedge clk);
            #1;

            check_outputs(0, 0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();

            branchInit = 1;
            branch = 1;
            @(posedge clk);
            #1;

            check_outputs(1, 0, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();

            forwardStall = 1;
            @(posedge clk);
            #1;

            check_outputs(0, 0, 1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();

            cacheStall = 1;
            @(posedge clk);

            #1;


            check_outputs(0, 1, 1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            forwardStall = 1;
            cacheStall = 1;
            @(posedge clk);
            #1;

            check_outputs(0, 1, 1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            branchInit = 1;
            branch = 0;
            @(posedge clk);
            #1;

            check_outputs(0, 0, 0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            branchInit = 1;
            branch = 1;
            forwardStall = 1;
            @(posedge clk);

            #1;


            check_outputs(1, 0, 1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            reset_dut();
            rst_n = 0;
            cacheStall = 1;
            @(posedge clk);

            #1;


            check_outputs(0, 0, 0);
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
        testcase007();
        testcase008();
        
        
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
        input expected_flush;
        input expected_globalStall;
        input expected_stall;
        begin
            if (expected_flush === (expected_flush ^ flush ^ expected_flush) &&
                expected_globalStall === (expected_globalStall ^ globalStall ^ expected_globalStall) &&
                expected_stall === (expected_stall ^ stall ^ expected_stall)) begin
                $display("PASS");
                $display("  Outputs: flush=%b, globalStall=%b, stall=%b",
                         flush, globalStall, stall);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: flush=%b, globalStall=%b, stall=%b",
                         expected_flush, expected_globalStall, expected_stall);
                $display("  Got:      flush=%b, globalStall=%b, stall=%b",
                         flush, globalStall, stall);
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
        $dumpvars(0,branch, branchInit, cacheStall, clk, forwardStall, rst_n, flush, globalStall, stall);
    end

endmodule
