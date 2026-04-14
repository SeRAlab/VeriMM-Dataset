`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] B;
    reg Clk;
    reg Enable;
    reg Reset;
    wire [7:0] P;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .B(B),
        .Clk(Clk),
        .Enable(Enable),
        .Reset(Reset),
        .P(P)
    );

    // Clock generation (10ns period)
    initial begin
        Clk = 0;
        forever #5 Clk = ~Clk;
    end

        task reset_dut;

    begin
        Reset = 1;
        Enable = 0;
        B = 0;
        @(posedge Clk);
        #1 Reset = 0;
        @(posedge Clk);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Basic counting with positive B", test_num);
        reset_dut();
        B = 4'd3;
        Enable = 1;
        repeat(5) @(posedge Clk);
        Enable = 0;
        #1;
        #1;

        check_outputs(8'sd15);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Basic counting with negative B", test_num);
        reset_dut();
        B = -4'sd2;
        Enable = 1;
        repeat(4) @(posedge Clk);
        Enable = 0;
        #1;
        #1;

        check_outputs(-8'sd8);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Enable/Disable control", test_num);
        reset_dut();
        B = 4'sd4;
        Enable = 1;
        repeat(3) @(posedge Clk);
        Enable = 0;
        repeat(3) @(posedge Clk);
        Enable = 1;
        repeat(2) @(posedge Clk);
        Enable = 0;
        #1;
        #1;

        check_outputs(8'sd20);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Max counter and Max positive B", test_num);
        reset_dut();
        B = 4'sd7;
        Enable = 1;
        repeat(15) @(posedge Clk);
        Enable = 0;
        #1;
        #1;

        check_outputs(8'sd105);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Counter wrap-around functionality", test_num);
        reset_dut();
        B = 4'sd5;
        Enable = 1;
        repeat(18) @(posedge Clk);
        Enable = 0;
        #1;
        #1;

        check_outputs(8'sd10);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Multiplication by min signed value (-8)", test_num);
        reset_dut();
        B = -4'sd8;
        Enable = 1;
        repeat(10) @(posedge Clk);
        Enable = 0;
        #1;
        #1;

        check_outputs(-8'sd80);
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
        input [7:0] expected_P;
        begin
            if (expected_P === (expected_P ^ P ^ expected_P)) begin
                $display("PASS");
                $display("  Outputs: P=%h",
                         P);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: P=%h",
                         expected_P);
                $display("  Got:      P=%h",
                         P);
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
        $dumpvars(0,B, Clk, Enable, Reset, P);
    end

endmodule
