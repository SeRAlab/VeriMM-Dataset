`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg async_reset;
    reg clk_out;
    reg data_in;
    wire sync_data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .async_reset(async_reset),
        .clk_out(clk_out),
        .data_in(data_in),
        .sync_data_out(sync_data_out)
    );

    // Clock generation (10ns period)
    initial begin
        async_reset = 0;
        forever #5 async_reset = ~async_reset;
    end

        task reset_dut;

        begin
            async_reset = 1;
            #15;
            async_reset = 0;
            #5;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Reset Functional Check", test_num);
            data_in = 1'b1;
            reset_dut();

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Synchronous Load High", test_num);
            reset_dut();
            data_in = 1'b1;
            @(posedge clk_out);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Synchronous Load Low", test_num);
            reset_dut();

            data_in = 1'b1;
            @(posedge clk_out);
            #2;

            data_in = 1'b0;
            @(posedge clk_out);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Asynchronous Reset Priority", test_num);
            reset_dut();

            data_in = 1'b1;
            @(posedge clk_out);
            #2;

            async_reset = 1;
            #1;
            #1;

            check_outputs(1'b0);

            async_reset = 0;
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Data Stability", test_num);
            reset_dut();
            data_in = 1'b0;
            @(posedge clk_out);
            #2;
            data_in = 1'b1;
            #2;
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
        input expected_sync_data_out;
        begin
            if (expected_sync_data_out === (expected_sync_data_out ^ sync_data_out ^ expected_sync_data_out)) begin
                $display("PASS");
                $display("  Outputs: sync_data_out=%b",
                         sync_data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: sync_data_out=%b",
                         expected_sync_data_out);
                $display("  Got:      sync_data_out=%b",
                         sync_data_out);
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
        $dumpvars(0,async_reset, clk_out, data_in, sync_data_out);
    end

endmodule
