`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg Clock;
    reg NextAddress;
    reg Reset;
    wire [5:0] RAMaddress;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Clock(Clock),
        .NextAddress(NextAddress),
        .Reset(Reset),
        .RAMaddress(RAMaddress)
    );

    // Clock generation (10ns period)
    initial begin
        Clock = 0;
        forever #5 Clock = ~Clock;
    end

        task reset_dut;

        begin
            Reset = 1;
            NextAddress = 0;
            @(posedge Clock);
            #1;
            Reset = 0;
            @(posedge Clock);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset Behavior", test_num);
            reset_dut();

            #1;


            check_outputs(6'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Single Increment", test_num);
            reset_dut();
            NextAddress = 1;
            @(posedge Clock);
            #1;
            NextAddress = 0;
            #1;

            check_outputs(6'd1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Multiple Increments (10 steps)", test_num);
            reset_dut();
            NextAddress = 1;
            repeat(10) @(posedge Clock);
            #1;
            NextAddress = 0;
            #1;

            check_outputs(6'd10);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: NextAddress Gating (Enable/Disable)", test_num);
            reset_dut();
            NextAddress = 1;
            repeat(5) @(posedge Clock);
            NextAddress = 0;
            repeat(5) @(posedge Clock);
            #1;
            #1;

            check_outputs(6'd5);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: 6-bit Address Rollover", test_num);
            reset_dut();
            NextAddress = 1;
            repeat(64) @(posedge Clock);
            #1;
            NextAddress = 0;
            #1;

            check_outputs(6'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Increment Post-Rollover", test_num);
            reset_dut();
            NextAddress = 1;
            repeat(66) @(posedge Clock);
            #1;
            NextAddress = 0;
            #1;

            check_outputs(6'd2);
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
        input [5:0] expected_RAMaddress;
        begin
            if (expected_RAMaddress === (expected_RAMaddress ^ RAMaddress ^ expected_RAMaddress)) begin
                $display("PASS");
                $display("  Outputs: RAMaddress=%h",
                         RAMaddress);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: RAMaddress=%h",
                         expected_RAMaddress);
                $display("  Got:      RAMaddress=%h",
                         RAMaddress);
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
        $dumpvars(0,Clock, NextAddress, Reset, RAMaddress);
    end

endmodule
