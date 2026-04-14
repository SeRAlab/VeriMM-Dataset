`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg async_input;
    reg clk;
    reg reset;
    wire sync_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .async_input(async_input),
        .clk(clk),
        .reset(reset),
        .sync_output(sync_output)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(negedge clk);
            reset = 1;
            async_input = 0;
            @(negedge clk);
            reset = 0;
            @(negedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset behavior", test_num);
            reset_dut();

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Synchronize HIGH input", test_num);
            reset_dut();

            async_input = 1;

            @(posedge clk);
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Synchronize LOW input after HIGH", test_num);
            reset_dut();


            async_input = 1;
            repeat(2) @(posedge clk);


            async_input = 0;
            repeat(2) @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Stability check (input toggle between edges)", test_num);
            reset_dut();

            async_input = 1;
            @(posedge clk);
            #2;
            async_input = 0;
            #2;
            async_input = 1;

            @(posedge clk);
            #1;



            #1;




            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset mid-operation", test_num);
            reset_dut();

            async_input = 1;
            @(posedge clk);

            reset = 1;
            @(posedge clk);
            #1;


            #1;



            check_outputs(1'b0);
            reset = 0;
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
        input expected_sync_output;
        begin
            if (expected_sync_output === (expected_sync_output ^ sync_output ^ expected_sync_output)) begin
                $display("PASS");
                $display("  Outputs: sync_output=%b",
                         sync_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: sync_output=%b",
                         expected_sync_output);
                $display("  Got:      sync_output=%b",
                         sync_output);
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
        $dumpvars(0,async_input, clk, reset, sync_output);
    end

endmodule
