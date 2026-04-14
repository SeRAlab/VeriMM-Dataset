`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg Clk_i;
    reg [15:0] D1_i;
    reg [15:0] D2_i;
    reg Enable1_i;
    reg Enable2_i;
    reg Reset_n_i;
    wire [15:0] Q_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Clk_i(Clk_i),
        .D1_i(D1_i),
        .D2_i(D2_i),
        .Enable1_i(Enable1_i),
        .Enable2_i(Enable2_i),
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
        D1_i = 16'h0;
        D2_i = 16'h0;
        Enable1_i = 0;
        Enable2_i = 0;
        repeat(2) @(posedge Clk_i);
        #1 Reset_n_i = 1;
        @(posedge Clk_i);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %03d: Reset check", test_num);
        reset_dut();

        #1;


        check_outputs(16'h0000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %03d: Load D1_i with Enable1_i", test_num);
        reset_dut();
        D1_i = 16'hABCD;
        Enable1_i = 1;
        @(posedge Clk_i);
        #1;
        #1;

        check_outputs(16'hABCD);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %03d: Load D2_i with Enable2_i", test_num);
        reset_dut();
        D2_i = 16'h1234;
        Enable2_i = 1;
        @(posedge Clk_i);
        #1;
        #1;

        check_outputs(16'h1234);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %03d: Hold value (Enable1=0, Enable2=0)", test_num);
        reset_dut();

        D1_i = 16'h55AA;
        Enable1_i = 1;
        @(posedge Clk_i);
        #1;

        Enable1_i = 0;
        Enable2_i = 0;
        D1_i = 16'hFFFF;
        D2_i = 16'h0000;
        @(posedge Clk_i);
        #1;
        #1;

        check_outputs(16'h55AA);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %03d: Priority check (Both enables high)", test_num);
        reset_dut();
        D1_i = 16'hAAAA;
        D2_i = 16'hBBBB;
        Enable1_i = 1;
        Enable2_i = 1;
        @(posedge Clk_i);
        #1;

        #1;


        check_outputs(16'hAAAA);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %03d: Consecutive updates", test_num);
        reset_dut();

        D1_i = 16'h1111;
        Enable1_i = 1;
        @(posedge Clk_i);
        #1;

        Enable1_i = 0;
        D2_i = 16'h2222;
        Enable2_i = 1;
        @(posedge Clk_i);
        #1;
        #1;

        check_outputs(16'h2222);
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
        $dumpvars(0,Clk_i, D1_i, D2_i, Enable1_i, Enable2_i, Reset_n_i, Q_o);
    end

endmodule
