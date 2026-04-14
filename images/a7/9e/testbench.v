`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg flush;
    reg llE;
    reg rst;
    wire LLbit;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .flush(flush),
        .llE(llE),
        .rst(rst),
        .LLbit(LLbit)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            flush = 0;
            llE = 0;
            @(posedge clk);
            #1;
            rst = 0;
        end
        endtask
    task clear_inputs;

        begin
            rst = 0;
            flush = 0;
            llE = 0;
        end
        endtask

    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Set bit and check retention", test_num);
            reset_dut();
            llE = 1;
            @(posedge clk);
            #1;
            llE = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Flush priority over LL enable", test_num);
            reset_dut();
            llE = 1;
            flush = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Reset functionality on high bit", test_num);
            reset_dut();
            llE = 1;
            @(posedge clk);
            #1;
            llE = 0;
            rst = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Initial retention (0)", test_num);
            reset_dut();

            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Reset priority over LL enable", test_num);
            reset_dut();
            llE = 1;
            rst = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
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
        input expected_LLbit;
        begin
            if (expected_LLbit === (expected_LLbit ^ LLbit ^ expected_LLbit)) begin
                $display("PASS");
                $display("  Outputs: LLbit=%b",
                         LLbit);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: LLbit=%b",
                         expected_LLbit);
                $display("  Got:      LLbit=%b",
                         LLbit);
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
        $dumpvars(0,clk, flush, llE, rst, LLbit);
    end

endmodule
