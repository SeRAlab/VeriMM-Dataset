`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg din;
    reg en;
    wire [3:0] addr;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .din(din),
        .en(en),
        .addr(addr)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            en = 1;
            din = 0;
            repeat(4) @(negedge clk);
            en = 0;
            #2;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Shift in 4 ones", test_num);
            reset_dut();

            @(negedge clk);
            en = 1; din = 1;
            repeat(4) @(negedge clk);
            en = 0;

            #1;


            check_outputs(4'b1111);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Shift in 1-0-1-0", test_num);
            reset_dut();

            @(negedge clk); en = 1; din = 1;
            @(negedge clk); en = 1; din = 0;
            @(negedge clk); en = 1; din = 1;
            @(negedge clk); en = 1; din = 0;
            en = 0;

            #1;


            check_outputs(4'b1010);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Verify enable (en=0 should stall)", test_num);
            reset_dut();

            @(negedge clk); en = 1; din = 1;
            @(negedge clk); en = 0; din = 1;
            @(negedge clk); en = 0; din = 0;
            @(negedge clk); en = 1; din = 1;
            en = 0;

            #1;


            check_outputs(4'b0011);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Continuous shift (5 bits)", test_num);
            reset_dut();

            @(negedge clk); en = 1; din = 1;
            @(negedge clk); en = 1; din = 0;
            @(negedge clk); en = 1; din = 0;
            @(negedge clk); en = 1; din = 0;
            @(negedge clk); en = 1; din = 1;
            en = 0;

            #1;


            check_outputs(4'b0001);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Shift in nibble 4'b1011", test_num);
            reset_dut();

            @(negedge clk); en = 1; din = 1;
            @(negedge clk); en = 1; din = 0;
            @(negedge clk); en = 1; din = 1;
            @(negedge clk); en = 1; din = 1;
            en = 0;

            #1;


            check_outputs(4'b1011);
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
        input [3:0] expected_addr;
        begin
            if (expected_addr === (expected_addr ^ addr ^ expected_addr)) begin
                $display("PASS");
                $display("  Outputs: addr=%h",
                         addr);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: addr=%h",
                         expected_addr);
                $display("  Got:      addr=%h",
                         addr);
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
        $dumpvars(0,clk, din, en, addr);
    end

endmodule
