`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg reset;
    reg sync_in;
    wire sync_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .reset(reset),
        .sync_in(sync_in),
        .sync_out(sync_out)
    );

    // Clock generation (10ns period)
    initial begin
        reset = 0;
        forever #5 reset = ~reset;
    end

        task reset_dut;

        begin
            sync_in = 0;

            @(negedge reset);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Capture HIGH on Reset Deassertion (0->1)", test_num);
            reset_dut();


            sync_in = 1;
            @(posedge reset);
            #2;


            #1;



            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Capture LOW on Reset Deassertion (0->1)", test_num);

            sync_in = 1;
            @(posedge reset);
            #2;


            sync_in = 0;
            @(negedge reset);
            #1;
            @(posedge reset);
            #2;


            #1;



            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Asynchronous Reset Assertion", test_num);
            reset_dut();


            sync_in = 1;
            @(posedge reset);
            #2;


            @(negedge reset);
            #1;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Output Stability (FF behavior) while Reset is High", test_num);
            reset_dut();


            sync_in = 1;
            @(posedge reset);
            #2;



            sync_in = 0;
            #3;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Reset override during Sync Input change", test_num);
            reset_dut();


            sync_in = 1;
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
        input expected_sync_out;
        begin
            if (expected_sync_out === (expected_sync_out ^ sync_out ^ expected_sync_out)) begin
                $display("PASS");
                $display("  Outputs: sync_out=%b",
                         sync_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: sync_out=%b",
                         expected_sync_out);
                $display("  Got:      sync_out=%b",
                         sync_out);
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
        $dumpvars(0,reset, sync_in, sync_out);
    end

endmodule
