`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [11:0] address;
    reg clock;
    wire [11:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .address(address),
        .clock(clock),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            address = 12'h000;
            @(posedge clock);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            address = 12'hA5A;
            @(posedge clock);
            #2;
            $display("Testcase 001: Latching 12'hA5A");
            #1;

            check_outputs(12'hA5A);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            address = 12'hFFF;
            @(posedge clock);
            #2;
            $display("Testcase 002: Latching 12'hFFF (All ones)");
            #1;

            check_outputs(12'hFFF);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            address = 12'h123;
            @(posedge clock);
            #2;
            address = 12'h456;
            #1;
            $display("Testcase 003: Address change during Clock High (DFF check)");
            #1;

            check_outputs(12'h123);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            address = 12'hABC;
            @(posedge clock);
            #2;
            @(negedge clock);
            address = 12'h000;
            #2;
            $display("Testcase 004: Address change during Clock Low");
            #1;

            check_outputs(12'hABC);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            address = 12'h555;
            @(posedge clock);
            #2;
            address = 12'hAAA;
            @(posedge clock);
            #2;
            $display("Testcase 005: Consecutive updates (0x555 -> 0xAAA)");
            #1;

            check_outputs(12'hAAA);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            address = 12'hFFF;
            @(posedge clock);
            #2;
            address = 12'h000;
            @(posedge clock);
            #2;
            $display("Testcase 006: Transition to zero");
            #1;

            check_outputs(12'h000);
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
        input [11:0] expected_q;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: q=%h",
                         q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%h",
                         expected_q);
                $display("  Got:      q=%h",
                         q);
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
        $dumpvars(0,address, clock, q);
    end

endmodule
