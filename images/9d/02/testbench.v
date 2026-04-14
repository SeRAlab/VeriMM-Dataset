`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg Clock;
    reg Enable;
    reg [8:0] In;
    reg Load;
    reg Reset;
    reg Set;
    wire [8:0] Count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Clock(Clock),
        .Enable(Enable),
        .In(In),
        .Load(Load),
        .Reset(Reset),
        .Set(Set),
        .Count(Count)
    );

    // Clock generation (10ns period)
    initial begin
        Clock = 0;
        forever #5 Clock = ~Clock;
    end

        task reset_dut;

        begin
            Reset = 1;
            Enable = 0;
            Load = 0;
            Set = 0;
            In = 0;
            @(posedge Clock);
            #1;
            Reset = 0;
            @(posedge Clock);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Reset functionality");
            reset_dut();
            #1;

            check_outputs(9'd0);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Load operation");
            reset_dut();
            In = 9'h0A5;
            Load = 1;
            @(posedge Clock);
            #1;
            Load = 0;
            #1;

            check_outputs(9'h0A5);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Set operation (All bits high)");
            reset_dut();
            Set = 1;
            @(posedge Clock);
            #1;
            Set = 0;
            #1;

            check_outputs(9'h1FF);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Basic increment (+2)");
            reset_dut();
            Enable = 1;
            @(posedge Clock);
            #1;
            Enable = 0;
            #1;

            check_outputs(9'd2);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Multiple increments (5 cycles)");
            reset_dut();
            Enable = 1;
            repeat(5) @(posedge Clock);
            #1;
            Enable = 0;
            #1;

            check_outputs(9'd10);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Enable low holds state");
            reset_dut();
            Enable = 1;
            repeat(2) @(posedge Clock);
            Enable = 0;
            repeat(3) @(posedge Clock);
            #1;
            #1;

            check_outputs(9'd4);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Reset priority over Set/Load/Enable");
            reset_dut();
            Reset = 1;
            Set = 1;
            Load = 1;
            Enable = 1;
            In = 9'h123;
            @(posedge Clock);
            #1;
            #1;

            check_outputs(9'd0);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: Set priority over Load/Enable");
            reset_dut();
            Set = 1;
            Load = 1;
            Enable = 1;
            In = 9'h010;
            @(posedge Clock);
            #1;
            #1;

            check_outputs(9'h1FF);
        end
        endtask

    task testcase009;

        begin
            $display("Testcase 009: Load priority over Enable");
            reset_dut();
            Load = 1;
            Enable = 1;
            In = 9'h050;
            @(posedge Clock);
            #1;
            #1;

            check_outputs(9'h050);
        end
        endtask

    task testcase010;

        begin
            $display("Testcase 010: Wrap-around from near max value");
            reset_dut();
            In = 9'h1FE;
            Load = 1;
            @(posedge Clock);
            #1;
            Load = 0;
            Enable = 1;
            @(posedge Clock);
            #1;
            Enable = 0;
            #1;

            check_outputs(9'h000);
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
        testcase009();
        testcase010();
        
        
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
        input [8:0] expected_Count;
        begin
            if (expected_Count === (expected_Count ^ Count ^ expected_Count)) begin
                $display("PASS");
                $display("  Outputs: Count=%h",
                         Count);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Count=%h",
                         expected_Count);
                $display("  Got:      Count=%h",
                         Count);
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
        $dumpvars(0,Clock, Enable, In, Load, Reset, Set, Count);
    end

endmodule
