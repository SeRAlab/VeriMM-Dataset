`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk1;
    reg clk2;
    reg reset1;
    reg reset2;
    reg set2;
    wire sync_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk1(clk1),
        .clk2(clk2),
        .reset1(reset1),
        .reset2(reset2),
        .set2(set2),
        .sync_out(sync_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk1 = 0;
        forever #5 clk1 = ~clk1;
    end

        task reset_dut;

        begin
            reset1 = 1;
            reset2 = 1;
            set2   = 0;
            repeat (5) @(posedge clk1);
            repeat (5) @(posedge clk2);
            reset1 = 0;
            reset2 = 0;
            repeat (2) @(posedge clk1);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Verifying reset state", test_num);
            reset_dut();

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Pulse set2 and verify sync_out becomes high", test_num);
            reset_dut();

            @(posedge clk1);
            set2 = 1;
            @(posedge clk1);
            set2 = 0;


            repeat (10) @(posedge clk2);

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Verify reset1 clears internal latch before synchronization", test_num);
            reset_dut();

            @(posedge clk1);
            set2 = 1;
            @(posedge clk1);
            set2 = 0;


            reset1 = 1;
            @(posedge clk1);
            reset1 = 0;

            repeat (10) @(posedge clk2);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Verify reset2 clears sync_out directly", test_num);
            reset_dut();

            @(posedge clk1);
            set2 = 1;
            @(posedge clk1);
            set2 = 0;


            repeat (5) @(posedge clk2);


            reset2 = 1;
            @(posedge clk2);
            #1;

            check_outputs(1'b0);
            reset2 = 0;
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Consecutive pulses on set2", test_num);
            reset_dut();


            @(posedge clk1);
            set2 = 1;
            @(posedge clk1);
            set2 = 0;
            repeat (10) @(posedge clk2);


            @(posedge clk1);
            set2 = 1;
            @(posedge clk1);
            set2 = 0;
            repeat (10) @(posedge clk2);

            #1;


            check_outputs(1'b1);
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
        $dumpvars(0,clk1, clk2, reset1, reset2, set2, sync_out);
    end

endmodule
