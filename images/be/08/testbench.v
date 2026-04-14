`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    wire [7:0] a;
    wire [2:0] sel;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .reset(reset),
        .a(a),
        .sel(sel)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            $display("Action: Resetting system...");
            reset = 1;
            @(posedge clk);
            #2;
            reset = 0;
            @(posedge clk);
            #2;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Initial state after reset", test_num);
            reset_dut();

            #1;


            check_outputs(8'h00, 3'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Transition to State 1", test_num);
            reset_dut();
            @(posedge clk); #2;

            #1;


            check_outputs(8'h01, 3'h1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Transition to State 4", test_num);
            reset_dut();
            repeat(4) @(posedge clk); #2;

            #1;


            check_outputs(8'h04, 3'h4);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Transition to State 7", test_num);
            reset_dut();
            repeat(7) @(posedge clk); #2;

            #1;


            check_outputs(8'h07, 3'h7);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Wraparound check (7 to 0)", test_num);
            reset_dut();
            repeat(8) @(posedge clk); #2;

            #1;


            check_outputs(8'h00, 3'h0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Reset from mid-sequence", test_num);
            reset_dut();
            repeat(3) @(posedge clk); #2;
            reset = 1;
            @(posedge clk); #2;
            reset = 0;
            @(posedge clk); #2;

            #1;


            check_outputs(8'h00, 3'h0);
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
        input [7:0] expected_a;
        input [2:0] expected_sel;
        begin
            if (expected_a === (expected_a ^ a ^ expected_a) &&
                expected_sel === (expected_sel ^ sel ^ expected_sel)) begin
                $display("PASS");
                $display("  Outputs: a=%h, sel=%h",
                         a, sel);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: a=%h, sel=%h",
                         expected_a, expected_sel);
                $display("  Got:      a=%h, sel=%h",
                         a, sel);
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
        $dumpvars(0,clk, reset, a, sel);
    end

endmodule
