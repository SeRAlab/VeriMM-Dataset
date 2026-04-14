`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg RESET;
    reg UP_DOWN;
    wire [3:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .RESET(RESET),
        .UP_DOWN(UP_DOWN),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            RESET = 1;
            UP_DOWN = 0;
            @(negedge CLK);
            RESET = 0;
            @(negedge CLK);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Reset Check", test_num);
            reset_dut();
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Count Up 5 times", test_num);
            reset_dut();
            UP_DOWN = 1;
            repeat(5) @(negedge CLK);
            #1;

            check_outputs(4'h5);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Count Down 1 time (Underflow from 0 to 15)", test_num);
            reset_dut();
            UP_DOWN = 0;
            repeat(1) @(negedge CLK);
            #1;

            check_outputs(4'hF);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Count Up 17 times (Overflow check 17 mod 16)", test_num);
            reset_dut();
            UP_DOWN = 1;
            repeat(17) @(negedge CLK);
            #1;

            check_outputs(4'h1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Count Up 10 then Down 4", test_num);
            reset_dut();
            UP_DOWN = 1;
            repeat(10) @(negedge CLK);
            UP_DOWN = 0;
            repeat(4) @(negedge CLK);
            #1;

            check_outputs(4'h6);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Count Up to 15", test_num);
            reset_dut();
            UP_DOWN = 1;
            repeat(15) @(negedge CLK);
            #1;

            check_outputs(4'hF);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %03d: Count Down 32 times (2 full cycles)", test_num);
            reset_dut();
            UP_DOWN = 0;
            repeat(32) @(negedge CLK);
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %03d: Reset during operation", test_num);
            reset_dut();
            UP_DOWN = 1;
            repeat(8) @(negedge CLK);
            RESET = 1;
            @(negedge CLK);
            RESET = 0;
            #1;

            check_outputs(4'h0);
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
        testcase008();
        
        
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
        $dumpvars(0,CLK, RESET, UP_DOWN, Q);
    end

endmodule
