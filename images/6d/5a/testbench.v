`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg x;
    wire parity;
    wire [1:0] state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .reset(reset),
        .x(x),
        .parity(parity),
        .state(state)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        x = 0;
        #12;
        reset = 0;
        @(negedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %03d: Initial Reset State", test_num);
        reset_dut();

        #1;


        check_outputs(1'b0, S1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %03d: Transition S1 -> S2", test_num);
        reset_dut();
        x = 1;
        @(posedge clk);
        #2;

        #1;


        check_outputs(1'b0, S2);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %03d: Transition S2 -> S3 (x=1)", test_num);
        reset_dut();
        @(posedge clk);
        x = 1;
        @(posedge clk);
        #2;

        #1;


        check_outputs(1'b1, S3);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %03d: Transition S2 -> S3 (x=0)", test_num);
        reset_dut();
        @(posedge clk);
        x = 0;
        @(posedge clk);
        #2;

        #1;


        check_outputs(1'b0, S3);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %03d: Cycle S3 -> S1", test_num);
        reset_dut();
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        #2;

        #1;


        check_outputs(1'b0, S1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %03d: Asynchronous Reset Mid-Operation", test_num);
        reset_dut();
        @(posedge clk);
        x = 1;
        @(posedge clk);
        #2;
        reset = 1;
        #2;
        #1;

        check_outputs(1'b0, S1);
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
        input expected_parity;
        input [1:0] expected_state;
        begin
            if (expected_parity === (expected_parity ^ parity ^ expected_parity) &&
                expected_state === (expected_state ^ state ^ expected_state)) begin
                $display("PASS");
                $display("  Outputs: parity=%b, state=%h",
                         parity, state);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: parity=%b, state=%h",
                         expected_parity, expected_state);
                $display("  Got:      parity=%b, state=%h",
                         parity, state);
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
        $dumpvars(0,clk, reset, x, parity, state);
    end

endmodule
