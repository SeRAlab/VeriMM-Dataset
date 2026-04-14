`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg ack_pop_i;
    reg clk;
    reg pop_i;
    reg rst;
    wire pop_latched_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ack_pop_i(ack_pop_i),
        .clk(clk),
        .pop_i(pop_i),
        .rst(rst),
        .pop_latched_o(pop_latched_o)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            pop_i = 0;
            ack_pop_i = 0;
            repeat(2) @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Post-reset state");
            test_num = 1;
            reset_dut();
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: pop_i=1 without ack_pop_i");
            test_num = 2;
            reset_dut();
            pop_i = 1;
            ack_pop_i = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: pop_i=1 with ack_pop_i=1");
            test_num = 3;
            reset_dut();
            pop_i = 1;
            ack_pop_i = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Maintain value when ack_pop_i=0");
            test_num = 4;
            reset_dut();

            pop_i = 1; ack_pop_i = 1;
            @(posedge clk);

            #1 pop_i = 0; ack_pop_i = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Clear latch (capture pop_i=0)");
            test_num = 5;
            reset_dut();

            pop_i = 1; ack_pop_i = 1;
            @(posedge clk);

            #1 pop_i = 0; ack_pop_i = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Reset priority");
            test_num = 6;
            reset_dut();

            pop_i = 1; ack_pop_i = 1;
            @(posedge clk);

            #1 rst = 1; pop_i = 1; ack_pop_i = 1;
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
        input expected_pop_latched_o;
        begin
            if (expected_pop_latched_o === (expected_pop_latched_o ^ pop_latched_o ^ expected_pop_latched_o)) begin
                $display("PASS");
                $display("  Outputs: pop_latched_o=%b",
                         pop_latched_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: pop_latched_o=%b",
                         expected_pop_latched_o);
                $display("  Got:      pop_latched_o=%b",
                         pop_latched_o);
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
        $dumpvars(0,ack_pop_i, clk, pop_i, rst, pop_latched_o);
    end

endmodule
