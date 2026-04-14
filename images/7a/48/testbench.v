`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [2:0] AddrA;
    reg [7:0] DataInA;
    reg WEA;
    reg clock;
    wire [7:0] DOut1;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .AddrA(AddrA),
        .DataInA(DataInA),
        .WEA(WEA),
        .clock(clock),
        .DOut1(DOut1)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            AddrA = 0;
            DataInA = 0;
            WEA = 0;
            @(posedge clock);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Write and Read at Address 0");
            reset_dut();

            @(negedge clock);
            AddrA = 3'd0;
            DataInA = 8'hA5;
            WEA = 1;

            @(negedge clock);

            WEA = 0;

            @(posedge clock);
            #2;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Write and Read at Address 7");
            reset_dut();

            @(negedge clock);
            AddrA = 3'd7;
            DataInA = 8'h5A;
            WEA = 1;

            @(negedge clock);

            WEA = 0;

            @(posedge clock);
            #2;
            #1;

            check_outputs(8'h5A);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Overwriting data at Address 3");
            reset_dut();

            @(negedge clock);
            AddrA = 3'd3;
            DataInA = 8'h11;
            WEA = 1;

            @(negedge clock);
            DataInA = 8'h22;
            WEA = 1;

            @(negedge clock);
            WEA = 0;

            @(posedge clock);
            #2;
            #1;

            check_outputs(8'h22);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Multi-address write, read Address 2");
            reset_dut();

            @(negedge clock);
            AddrA = 3'd1; DataInA = 8'h10; WEA = 1;

            @(negedge clock);
            AddrA = 3'd2; DataInA = 8'h20; WEA = 1;

            @(negedge clock);
            AddrA = 3'd3; DataInA = 8'h30; WEA = 1;

            @(negedge clock);
            AddrA = 3'd2;
            WEA = 0;

            @(posedge clock);
            #2;
            #1;

            check_outputs(8'h20);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Verify WEA control");
            reset_dut();

            @(negedge clock);
            AddrA = 3'd4;
            DataInA = 8'hEE;
            WEA = 1;

            @(negedge clock);
            WEA = 0;
            DataInA = 8'h00;
            @(posedge clock);
            #2;
            #1;

            check_outputs(8'hEE);
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
        input [7:0] expected_DOut1;
        begin
            if (expected_DOut1 === (expected_DOut1 ^ DOut1 ^ expected_DOut1)) begin
                $display("PASS");
                $display("  Outputs: DOut1=%h",
                         DOut1);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: DOut1=%h",
                         expected_DOut1);
                $display("  Got:      DOut1=%h",
                         DOut1);
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
        $dumpvars(0,AddrA, DataInA, WEA, clock, DOut1);
    end

endmodule
