`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg i;
    wire [2:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .i(i),
        .y(y)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            i = 1;
            @(posedge clk);
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: i=1 state hold");
            reset_dut();
            i = 1;
            repeat (3) @(posedge clk);
            #1;
            #1;

            check_outputs(3'd1);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Single increment (1->2)");
            reset_dut();
            i = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(3'd2);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Double increment (1->3)");
            reset_dut();
            i = 0;
            repeat (2) @(posedge clk);
            #1;
            #1;

            check_outputs(3'd3);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Wrap around (1->0)");
            reset_dut();
            i = 0;
            repeat (3) @(posedge clk);
            #1;
            #1;

            check_outputs(3'd0);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Full loop (1->1)");
            reset_dut();
            i = 0;
            repeat (4) @(posedge clk);
            #1;
            #1;

            check_outputs(3'd1);
        end
        endtask

    task testcase006;

        begin
            $display("Running testcase006: Interrupted count (1->2->3->1)");
            reset_dut();
            i = 0;
            repeat (2) @(posedge clk);
            i = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(3'd1);
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
        input [2:0] expected_y;
        begin
            if (expected_y === (expected_y ^ y ^ expected_y)) begin
                $display("PASS");
                $display("  Outputs: y=%h",
                         y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: y=%h",
                         expected_y);
                $display("  Got:      y=%h",
                         y);
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
        $dumpvars(0,clk, i, y);
    end

endmodule
