`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg pb;
    wire pb_debounced;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .pb(pb),
        .pb_debounced(pb_debounced)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            pb = 0;
            repeat(5) @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Stable Press (4 cycles)", test_num);
            reset_dut();
            @(negedge clk) pb = 1;
            repeat(4) @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Transient Noise (2 cycles)", test_num);
            reset_dut();
            @(negedge clk) pb = 1;
            repeat(2) @(posedge clk);
            @(negedge clk) pb = 0;
            repeat(2) @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Release after press", test_num);
            reset_dut();
            @(negedge clk) pb = 1;
            repeat(5) @(posedge clk);
            @(negedge clk) pb = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Bouncing then Stable", test_num);
            reset_dut();
            @(negedge clk) pb = 1;
            @(negedge clk) pb = 0;
            @(negedge clk) pb = 1;
            @(negedge clk) pb = 0;

            @(negedge clk) pb = 1;
            repeat(4) @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Prolonged Hold", test_num);
            reset_dut();
            @(negedge clk) pb = 1;
            repeat(10) @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Pulse just under threshold (3 cycles)", test_num);
            reset_dut();
            @(negedge clk) pb = 1;
            repeat(3) @(posedge clk);
            @(negedge clk) pb = 0;
            repeat(2) @(posedge clk);
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
        input expected_pb_debounced;
        begin
            if (expected_pb_debounced === (expected_pb_debounced ^ pb_debounced ^ expected_pb_debounced)) begin
                $display("PASS");
                $display("  Outputs: pb_debounced=%b",
                         pb_debounced);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: pb_debounced=%b",
                         expected_pb_debounced);
                $display("  Got:      pb_debounced=%b",
                         pb_debounced);
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
        $dumpvars(0,clk, pb, pb_debounced);
    end

endmodule
