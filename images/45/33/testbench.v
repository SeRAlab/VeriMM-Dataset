`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg c;
    reg clk;
    wire [2:0] s;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .c(c),
        .clk(clk),
        .s(s)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            c = 1;
            @(negedge clk);



        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Basic decrement from 7 to 4");
            test_num = test_num + 1;
            reset_dut();
            c = 0;

            repeat (3) @(negedge clk);
            #1;

            check_outputs(3'd4);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Full cycle wrap-around to 0");
            test_num = test_num + 1;
            reset_dut();
            c = 0;

            repeat (7) @(negedge clk);
            #1;

            check_outputs(3'd0);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Full cycle wrap-around back to 7");
            test_num = test_num + 1;
            reset_dut();
            c = 0;

            repeat (8) @(negedge clk);
            #1;

            check_outputs(3'd7);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Continuous Load (Holding c=1)");
            test_num = test_num + 1;
            reset_dut();
            c = 1;
            repeat (5) @(negedge clk);
            #1;

            check_outputs(3'd7);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Mid-sequence Reset/Load");
            test_num = test_num + 1;
            reset_dut();
            c = 0;
            repeat (4) @(negedge clk);
            c = 1;
            @(negedge clk);
            c = 0;
            @(negedge clk);
            #1;

            check_outputs(3'd6);
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
        input [2:0] expected_s;
        begin
            if (expected_s === (expected_s ^ s ^ expected_s)) begin
                $display("PASS");
                $display("  Outputs: s=%h",
                         s);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: s=%h",
                         expected_s);
                $display("  Got:      s=%h",
                         s);
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
        $dumpvars(0,c, clk, s);
    end

endmodule
