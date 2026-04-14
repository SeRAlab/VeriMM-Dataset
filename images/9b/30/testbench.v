`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg UD;
    wire [3:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .UD(UD),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            UD = 0;

            @(posedge CLK);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Counting up 5 times", test_num);
            reset_dut();
            UD = 0;
            repeat(5) @(posedge CLK);
            #1;
            #1;

            check_outputs(4'd5);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Up-counting wrap around (16 cycles)", test_num);
            reset_dut();
            UD = 0;
            repeat(16) @(posedge CLK);
            #1;
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Down-counting wrap from 0 to 15", test_num);
            reset_dut();
            UD = 1;
            repeat(1) @(posedge CLK);
            #1;
            #1;

            check_outputs(4'd15);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Down-counting 5 steps from 0", test_num);
            reset_dut();
            UD = 1;
            repeat(5) @(posedge CLK);
            #1;
            #1;

            check_outputs(4'd11);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Switching directions (Up 10, Down 4)", test_num);
            reset_dut();
            UD = 0;
            repeat(10) @(posedge CLK);
            UD = 1;
            repeat(4) @(posedge CLK);
            #1;
            #1;

            check_outputs(4'd6);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Count up to max value", test_num);
            reset_dut();
            UD = 0;
            repeat(15) @(posedge CLK);
            #1;
            #1;

            check_outputs(4'd15);
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
        input [3:0] expected_Q;
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q)) begin
                $display("PASS");
                $display("  Outputs: Q=%h",
                         Q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%h",
                         expected_Q);
                $display("  Got:      Q=%h",
                         Q);
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
        $dumpvars(0,CLK, UD, Q);
    end

endmodule
