`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg IncA;
    reg Reset;
    reg clock;
    wire [2:0] AddrA;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .IncA(IncA),
        .Reset(Reset),
        .clock(clock),
        .AddrA(AddrA)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            Reset = 1;
            IncA = 0;
            #15;
            Reset = 0;
            #5;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTest Case %0d: Basic Reset", test_num);
            reset_dut();
            #1;

            check_outputs(3'b111);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTest Case %0d: Single Increment", test_num);
            reset_dut();
            @(negedge clock);
            IncA = 1;
            @(negedge clock);
            IncA = 0;
            #1;

            check_outputs(3'b000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTest Case %0d: Three Increments", test_num);
            reset_dut();
            @(negedge clock);
            IncA = 1;
            repeat(3) @(negedge clock);
            IncA = 0;
            #1;

            check_outputs(3'b010);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTest Case %0d: IncA Low (No count)", test_num);
            reset_dut();
            @(negedge clock);
            IncA = 0;
            repeat(3) @(negedge clock);
            #1;

            check_outputs(3'b111);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTest Case %0d: Full 8-cycle Rotation", test_num);
            reset_dut();
            @(negedge clock);
            IncA = 1;
            repeat(8) @(negedge clock);
            IncA = 0;
            #1;

            check_outputs(3'b111);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTest Case %0d: Asynchronous Reset Mid-Count", test_num);
            reset_dut();
            @(negedge clock);
            IncA = 1;
            repeat(2) @(negedge clock);
            #3;
            Reset = 1;
            #2;
            Reset = 0;
            #1;

            check_outputs(3'b111);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("\nTest Case %0d: Increment immediately after Reset", test_num);
            reset_dut();
            IncA = 1;
            @(negedge clock);
            IncA = 0;
            #1;

            check_outputs(3'b000);
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
        input [2:0] expected_AddrA;
        begin
            if (expected_AddrA === (expected_AddrA ^ AddrA ^ expected_AddrA)) begin
                $display("PASS");
                $display("  Outputs: AddrA=%h",
                         AddrA);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: AddrA=%h",
                         expected_AddrA);
                $display("  Got:      AddrA=%h",
                         AddrA);
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
        $dumpvars(0,IncA, Reset, clock, AddrA);
    end

endmodule
