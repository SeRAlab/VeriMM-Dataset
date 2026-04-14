`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    wire [8:0] cnt;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .cnt(cnt)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %03d: Testing basic counting increments", test_num);


            repeat(9) @(posedge clk);
            #2;
            #1;

            check_outputs(9'd10);
            total_cycles = 10;
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %03d: Testing 9-bit wrap-around (512 cycles)", test_num);


            repeat(512) @(posedge clk);
            #2;
            #1;

            check_outputs(9'd10);
            total_cycles = total_cycles + 512;
        end
        endtask

    task testcase003;

        reg [8:0] target;
        begin
            test_num = 3;
            target = 9'd255;
            $display("\nTestcase %03d: Testing specific value: %d", test_num, target);


            repeat(245) @(posedge clk);
            #2;
            #1;

            check_outputs(target);
            total_cycles = total_cycles + 245;
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %03d: Testing long duration counting", test_num);

            repeat(128) @(posedge clk);
            #2;
            #1;

            check_outputs(9'd383);
            total_cycles = total_cycles + 128;
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
        input [8:0] expected_cnt;
        begin
            if (expected_cnt === (expected_cnt ^ cnt ^ expected_cnt)) begin
                $display("PASS");
                $display("  Outputs: cnt=%h",
                         cnt);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cnt=%h",
                         expected_cnt);
                $display("  Got:      cnt=%h",
                         cnt);
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
        $dumpvars(0,clk, cnt);
    end

endmodule
