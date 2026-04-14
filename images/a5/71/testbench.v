`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg U_D;
    reg clk;
    wire [3:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .U_D(U_D),
        .clk(clk),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            U_D = 0;
            force dut.Q = 4'b0000;
            @(posedge clk);
            #1;
            release dut.Q;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            U_D = 1;
            repeat (5) @(posedge clk);
            #1;
            test_num = 1;
            $display("Testcase %0d: Counting up 5 times", test_num);
            #1;

            check_outputs(4'd5);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            U_D = 0;
            repeat (1) @(posedge clk);
            #1;
            test_num = 2;
            $display("Testcase %0d: Counting down 1 time from 0", test_num);
            #1;

            check_outputs(4'd15);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            U_D = 1;
            repeat (10) @(posedge clk);
            U_D = 0;
            repeat (4) @(posedge clk);
            #1;
            test_num = 3;
            $display("Testcase %0d: Up 10 then Down 4", test_num);
            #1;

            check_outputs(4'd6);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            U_D = 1;
            repeat (16) @(posedge clk);
            #1;
            test_num = 4;
            $display("Testcase %0d: Increment wrap-around (16 steps)", test_num);
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            U_D = 0;
            repeat (2) @(posedge clk);
            #1;
            test_num = 5;
            $display("Testcase %0d: Decrement 2 times from 0", test_num);
            #1;

            check_outputs(4'd14);
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
        $dumpvars(0,U_D, clk, Q);
    end

endmodule
