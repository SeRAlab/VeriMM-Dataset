`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] attempt_count;
    reg clk;
    reg enable;
    reg reset;
    wire locked;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .attempt_count(attempt_count),
        .clk(clk),
        .enable(enable),
        .reset(reset),
        .locked(locked)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(posedge clk);
            #1 reset = 1;
            enable = 0;
            attempt_count = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Initial Reset check", test_num);
            reset_dut();
            #1;

            check_outputs(0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Counter at threshold (10 cycles)", test_num);
            reset_dut();
            enable = 1;
            repeat(10) @(posedge clk);
            #1;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Counter exceeds threshold (11 cycles)", test_num);
            reset_dut();
            enable = 1;
            repeat(11) @(posedge clk);
            #1;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Enable signal low test", test_num);
            reset_dut();
            enable = 0;
            repeat(15) @(posedge clk);
            #1;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Reset after locked state", test_num);
            reset_dut();
            enable = 1;
            repeat(12) @(posedge clk);
            enable = 0;
            #10;
            reset_dut();
            #1;

            check_outputs(0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Input attempt_count > 10 directly", test_num);
            reset_dut();
            attempt_count = 4'd12;
            enable = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Accumulated enable cycles", test_num);
            reset_dut();
            repeat(5) begin
                enable = 1; @(posedge clk);
                enable = 0; @(posedge clk);
            end

            enable = 1;
            repeat(6) @(posedge clk);
            #1;
            #1;

            check_outputs(1);
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
        input expected_locked;
        begin
            if (expected_locked === (expected_locked ^ locked ^ expected_locked)) begin
                $display("PASS");
                $display("  Outputs: locked=%b",
                         locked);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: locked=%b",
                         expected_locked);
                $display("  Got:      locked=%b",
                         locked);
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
        $dumpvars(0,attempt_count, clk, enable, reset, locked);
    end

endmodule
