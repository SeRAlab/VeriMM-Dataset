`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg ge2_free;
    reg ge3_free;
    reg [1:0] input_tm_cnt;
    wire [3:0] fifo_wrptr_inc;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ge2_free(ge2_free),
        .ge3_free(ge3_free),
        .input_tm_cnt(input_tm_cnt),
        .fifo_wrptr_inc(fifo_wrptr_inc)
    );
    task testcase001;

        begin
            $display("\nTestcase 001: ge3_free=1, input_tm_cnt=11");
            ge2_free = 0;
            ge3_free = 1;
            input_tm_cnt = 2'b11;
            #1;

            check_outputs(4'd3);
        end
        endtask

    task testcase002;

        begin
            $display("\nTestcase 002: ge3_free=0, input_tm_cnt=11");
            ge2_free = 1;
            ge3_free = 0;
            input_tm_cnt = 2'b11;
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase003;

        begin
            $display("\nTestcase 003: ge2_free=1, input_tm_cnt=10");
            ge2_free = 1;
            ge3_free = 0;
            input_tm_cnt = 2'b10;
            #1;

            check_outputs(4'd2);
        end
        endtask

    task testcase004;

        begin
            $display("\nTestcase 004: ge2_free=0, input_tm_cnt=10");
            ge2_free = 0;
            ge3_free = 1;
            input_tm_cnt = 2'b10;
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase005;

        begin
            $display("\nTestcase 005: input_tm_cnt=01 (ge signals low)");
            ge2_free = 0;
            ge3_free = 0;
            input_tm_cnt = 2'b01;
            #1;

            check_outputs(4'd1);
        end
        endtask

    task testcase006;

        begin
            $display("\nTestcase 006: input_tm_cnt=01 (ge signals high)");
            ge2_free = 1;
            ge3_free = 1;
            input_tm_cnt = 2'b01;
            #1;

            check_outputs(4'd1);
        end
        endtask

    task testcase007;

        begin
            $display("\nTestcase 007: input_tm_cnt=00");
            ge2_free = 1;
            ge3_free = 1;
            input_tm_cnt = 2'b00;
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase008;

        begin
            $display("\nTestcase 008: Both free signals high, input_tm_cnt=11");
            ge2_free = 1;
            ge3_free = 1;
            input_tm_cnt = 2'b11;
            #1;

            check_outputs(4'd3);
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
        input [3:0] expected_fifo_wrptr_inc;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_fifo_wrptr_inc === (expected_fifo_wrptr_inc ^ fifo_wrptr_inc ^ expected_fifo_wrptr_inc)) begin
                $display("PASS");
                $display("  Outputs: fifo_wrptr_inc=%h",
                         fifo_wrptr_inc);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: fifo_wrptr_inc=%h",
                         expected_fifo_wrptr_inc);
                $display("  Got:      fifo_wrptr_inc=%h",
                         fifo_wrptr_inc);
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

endmodule
