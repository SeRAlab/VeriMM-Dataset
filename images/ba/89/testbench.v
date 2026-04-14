`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg Clk_i;
    reg [15:0] D_i;
    reg Enable_i;
    reg Reset_n_i;
    wire [15:0] Q_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Clk_i(Clk_i),
        .D_i(D_i),
        .Enable_i(Enable_i),
        .Reset_n_i(Reset_n_i),
        .Q_o(Q_o)
    );

    // Clock generation (10ns period)
    initial begin
        Clk_i = 0;
        forever #5 Clk_i = ~Clk_i;
    end

        task reset_dut;

    begin
        Reset_n_i = 0;
        D_i = 0;
        Enable_i = 0;
        #15;
        Reset_n_i = 1;
        #5;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Initial Asynchronous Reset", test_num);
        reset_dut();
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Load Data (Enable=1)", test_num);
        reset_dut();
        @(posedge Clk_i);
        D_i = 16'hA5A5;
        Enable_i = 1;
        @(posedge Clk_i);
        #1;
        #1;

        check_outputs(16'hA5A5);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Data Hold (Enable=0)", test_num);
        reset_dut();

        @(posedge Clk_i);
        D_i = 16'h1234;
        Enable_i = 1;
        @(posedge Clk_i);

        #1;
        D_i = 16'hFFFF;
        Enable_i = 0;
        @(posedge Clk_i);
        #1;
        #1;

        check_outputs(16'h1234);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Async Reset Priority", test_num);
        reset_dut();
        @(posedge Clk_i);
        D_i = 16'h5555;
        Enable_i = 1;
        @(posedge Clk_i);
        #1;
        Reset_n_i = 0;
        #2;
        #1;

        check_outputs(16'h0000);
        Reset_n_i = 1;
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Multiple Sequential Loads", test_num);
        reset_dut();
        Enable_i = 1;
        @(posedge Clk_i);
        D_i = 16'h1111;
        @(posedge Clk_i);
        D_i = 16'h2222;
        @(posedge Clk_i);
        D_i = 16'h3333;
        @(posedge Clk_i);
        #1;
        #1;

        check_outputs(16'h3333);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Max Value (All 1s)", test_num);
        reset_dut();
        @(posedge Clk_i);
        D_i = 16'hFFFF;
        Enable_i = 1;
        @(posedge Clk_i);
        #1;
        #1;

        check_outputs(16'hFFFF);
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
        input [15:0] expected_Q_o;
        begin
            if (expected_Q_o === (expected_Q_o ^ Q_o ^ expected_Q_o)) begin
                $display("PASS");
                $display("  Outputs: Q_o=%h",
                         Q_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q_o=%h",
                         expected_Q_o);
                $display("  Got:      Q_o=%h",
                         Q_o);
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
        $dumpvars(0,Clk_i, D_i, Enable_i, Reset_n_i, Q_o);
    end

endmodule
