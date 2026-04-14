`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg Clear;
    reg Clock;
    reg Enable;
    reg Load;
    wire [3:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Clear(Clear),
        .Clock(Clock),
        .Enable(Enable),
        .Load(Load),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        Clock = 0;
        forever #5 Clock = ~Clock;
    end

        task reset_dut;

        begin
            Clear = 1;
            Enable = 0;
            Load = 0;
            @(posedge Clock);
            #1;
            Clear = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset/Clear to 15", test_num);
            reset_dut();
            #1;

            check_outputs(4'd15);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Single decrement", test_num);
            reset_dut();
            Enable = 1;
            @(posedge Clock);
            #1;
            Enable = 0;
            #1;

            check_outputs(4'd14);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Multiple decrements (4 steps)", test_num);
            reset_dut();
            Enable = 1;
            repeat(4) @(posedge Clock);
            #1;
            Enable = 0;
            #1;

            check_outputs(4'd11);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Enable low (Hold state)", test_num);
            reset_dut();
            Enable = 0;
            repeat(3) @(posedge Clock);
            #1;
            #1;

            check_outputs(4'd15);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Counter wrap-around (0 to 15)", test_num);
            reset_dut();
            Enable = 1;
            repeat(16) @(posedge Clock);
            #1;
            Enable = 0;
            #1;

            check_outputs(4'd15);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Load signal priority", test_num);
            reset_dut();
            Enable = 1;
            repeat(5) @(posedge Clock);
            #1;
            Load = 1;
            @(posedge Clock);
            #1;
            Load = 0;
            Enable = 0;
            #1;

            check_outputs(4'd15);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Clear priority over Enable", test_num);
            reset_dut();
            Enable = 1;
            repeat(2) @(posedge Clock);
            #1;
            Clear = 1;
            Enable = 1;
            @(posedge Clock);
            #1;
            Clear = 0;
            Enable = 0;
            #1;

            check_outputs(4'd15);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Countdown to zero", test_num);
            reset_dut();
            Enable = 1;
            repeat(15) @(posedge Clock);
            #1;
            Enable = 0;
            #1;

            check_outputs(4'd0);
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
        $dumpvars(0,Clear, Clock, Enable, Load, Q);
    end

endmodule
