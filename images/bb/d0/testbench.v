`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg probe;
    reg source_clk;
    wire [2:0] source;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .probe(probe),
        .source_clk(source_clk),
        .source(source)
    );

    // Clock generation (10ns period)
    initial begin
        source_clk = 0;
        forever #5 source_clk = ~source_clk;
    end

        task reset_dut;

        begin
            probe = 1;
            @(posedge source_clk);
            #1;
            probe = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Basic Synchronous Reset", test_num);
            reset_dut();
            #1;

            check_outputs(3'b000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Shift Stability (Zeros)", test_num);
            reset_dut();
            probe = 0;
            repeat(3) @(posedge source_clk);
            #1;
            #1;

            check_outputs(3'b000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Single Shift Left Logic (1 to 2)", test_num);
            reset_dut();
            force dut.source = 3'b001;
            #1;
            release dut.source;
            probe = 0;
            @(posedge source_clk);
            #1;
            #1;

            check_outputs(3'b010);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Double Shift Left Logic (1 to 4)", test_num);
            reset_dut();
            force dut.source = 3'b001;
            #1;
            release dut.source;
            probe = 0;
            repeat(2) @(posedge source_clk);
            #1;
            #1;

            check_outputs(3'b100);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Shift Out Logic", test_num);
            reset_dut();
            force dut.source = 3'b100;
            #1;
            release dut.source;
            probe = 0;
            @(posedge source_clk);
            #1;
            #1;

            check_outputs(3'b000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Reset Priority over Shift", test_num);
            reset_dut();
            force dut.source = 3'b111;
            #1;
            release dut.source;
            probe = 1;
            @(posedge source_clk);
            #1;
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
        input [2:0] expected_source;
        begin
            if (expected_source === (expected_source ^ source ^ expected_source)) begin
                $display("PASS");
                $display("  Outputs: source=%h",
                         source);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: source=%h",
                         expected_source);
                $display("  Got:      source=%h",
                         source);
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
        $dumpvars(0,probe, source_clk, source);
    end

endmodule
