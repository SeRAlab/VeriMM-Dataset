`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg i_clk;
    reg i_rst_n;
    wire o_pluse;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .i_clk(i_clk),
        .i_rst_n(i_rst_n),
        .o_pluse(o_pluse)
    );

    // Clock generation (10ns period)
    initial begin
        i_clk = 0;
        forever #5 i_clk = ~i_clk;
    end

        task reset_dut;

        begin
            i_rst_n = 0;
            #15;
            i_rst_n = 1;
            #5;
        end
        endtask
    task testcase001;

        begin
            $display("Running Testcase 001: Post-reset check...");
            reset_dut();

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("Running Testcase 002: After 1 clock cycle...");
            reset_dut();
            @(posedge i_clk);
            #1;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            $display("Running Testcase 003: After 31 clock cycles...");
            reset_dut();
            repeat(31) @(posedge i_clk);
            #1;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("Running Testcase 004: After 32 clock cycles (Full rotation)...");
            reset_dut();
            repeat(32) @(posedge i_clk);
            #1;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("Running Testcase 005: Async reset mid-operation...");
            reset_dut();
            repeat(10) @(posedge i_clk);
            #3;
            i_rst_n = 0;
            #1;

            #1;


            check_outputs(1'b1);
            #5 i_rst_n = 1;
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
        input expected_o_pluse;
        begin
            if (expected_o_pluse === (expected_o_pluse ^ o_pluse ^ expected_o_pluse)) begin
                $display("PASS");
                $display("  Outputs: o_pluse=%b",
                         o_pluse);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o_pluse=%b",
                         expected_o_pluse);
                $display("  Got:      o_pluse=%b",
                         o_pluse);
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
        $dumpvars(0,i_clk, i_rst_n, o_pluse);
    end

endmodule
