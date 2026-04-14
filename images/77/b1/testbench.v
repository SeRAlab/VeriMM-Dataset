`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg Clear_in;
    reg Clk;
    reg Enable_in;
    wire [3:0] GrayCount_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Clear_in(Clear_in),
        .Clk(Clk),
        .Enable_in(Enable_in),
        .GrayCount_out(GrayCount_out)
    );

    // Clock generation (10ns period)
    initial begin
        Clk = 0;
        forever #5 Clk = ~Clk;
    end

        task reset_dut;

    begin
        @(negedge Clk);
        Clear_in = 1;
        Enable_in = 0;
        @(negedge Clk);
        Clear_in = 0;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        reset_dut();
        #1;

        check_outputs(4'b0000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        reset_dut();
        Enable_in = 1;
        @(negedge Clk);
        Enable_in = 0;
        #1;

        check_outputs(4'b0001);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        reset_dut();
        Enable_in = 1;
        repeat(2) @(negedge Clk);
        Enable_in = 0;
        #1;

        check_outputs(4'b0011);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        reset_dut();
        Enable_in = 1;
        repeat(5) @(negedge Clk);
        Enable_in = 0;
        #1;

        check_outputs(4'b0111);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        reset_dut();
        Enable_in = 1;
        repeat(10) @(negedge Clk);
        Enable_in = 0;
        #1;

        check_outputs(4'b1111);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        reset_dut();
        Enable_in = 1;
        repeat(15) @(negedge Clk);
        Enable_in = 0;
        #1;

        check_outputs(4'b1000);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        reset_dut();
        Enable_in = 1;
        repeat(16) @(negedge Clk);
        Enable_in = 0;
        #1;

        check_outputs(4'b0000);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        reset_dut();
        Enable_in = 1;
        repeat(3) @(negedge Clk);
        Enable_in = 0;
        repeat(3) @(negedge Clk);
        #1;

        check_outputs(4'b0010);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        reset_dut();
        Enable_in = 1;
        repeat(5) @(negedge Clk);
        Clear_in = 1;
        @(negedge Clk);
        Clear_in = 0;
        #1;

        check_outputs(4'b0000);
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
        input [3:0] expected_GrayCount_out;
        begin
            if (expected_GrayCount_out === (expected_GrayCount_out ^ GrayCount_out ^ expected_GrayCount_out)) begin
                $display("PASS");
                $display("  Outputs: GrayCount_out=%h",
                         GrayCount_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: GrayCount_out=%h",
                         expected_GrayCount_out);
                $display("  Got:      GrayCount_out=%h",
                         GrayCount_out);
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
        $dumpvars(0,Clear_in, Clk, Enable_in, GrayCount_out);
    end

endmodule
