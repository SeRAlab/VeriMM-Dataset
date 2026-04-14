`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] in;
    wire [7:0] anyedge;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .in(in),
        .anyedge(anyedge)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        in = 8'h00;
        repeat(3) @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        reset_dut();
        @(negedge clk);
        in = 8'hFF;
        @(posedge clk);
        #2;
        $display("Testcase 001: All Rising Edges");
        #1;

        check_outputs(8'hFF);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;

        in = 8'hFF;
        repeat(2) @(posedge clk);
        @(posedge clk);
        in = 8'h00;
        @(negedge clk);
        #2;
        $display("Testcase 002: All Falling Edges");
        #1;

        check_outputs(8'hFF);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        reset_dut();
        repeat(2) @(posedge clk);
        #2;
        $display("Testcase 003: Steady State Low (No transitions)");
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        in = 8'hFF;
        repeat(3) @(posedge clk);
        #2;
        $display("Testcase 004: Steady State High (No transitions)");
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        reset_dut();
        in = 8'h0F;
        repeat(2) @(posedge clk);



        @(posedge clk);
        in = 8'hF0;

        @(negedge clk);
        #2;
        $display("Testcase 005: Mixed Transitions (Checking Falling Edges)");
        #1;

        check_outputs(8'h0F);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        reset_dut();
        in = 8'hAA;
        repeat(2) @(posedge clk);

        @(negedge clk);
        in = 8'h55;

        @(posedge clk);
        #2;
        $display("Testcase 006: Alternating Bits (Checking Rising Edges)");
        #1;

        check_outputs(8'h55);
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
        input [7:0] expected_anyedge;
        begin
            if (expected_anyedge === (expected_anyedge ^ anyedge ^ expected_anyedge)) begin
                $display("PASS");
                $display("  Outputs: anyedge=%h",
                         anyedge);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: anyedge=%h",
                         expected_anyedge);
                $display("  Got:      anyedge=%h",
                         anyedge);
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
        $dumpvars(0,clk, in, anyedge);
    end

endmodule
