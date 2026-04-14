`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [63:0] PC_In;
    reg clk;
    reg reset;
    wire [63:0] PC_Out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .PC_In(PC_In),
        .clk(clk),
        .reset(reset),
        .PC_Out(PC_Out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        PC_In = 64'h0;
        @(posedge clk);
        #1 reset = 0;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Synchronous Reset Check", test_num);
        reset_dut();

        #1;


        check_outputs(64'h0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Standard Value Load", test_num);
        reset_dut();
        PC_In = 64'hA5A5_B4B4_C3C3_D2D2;
        @(posedge clk);
        #1 #1;
 check_outputs(64'hA5A5_B4B4_C3C3_D2D2);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Boundary Value (All 1s)", test_num);
        reset_dut();
        PC_In = 64'hFFFF_FFFF_FFFF_FFFF;
        @(posedge clk);
        #1 #1;
 check_outputs(64'hFFFF_FFFF_FFFF_FFFF);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Sequential Cycle Updates", test_num);
        reset_dut();
        PC_In = 64'h100;
        @(posedge clk);
        PC_In = 64'h104;
        @(posedge clk);
        PC_In = 64'h108;
        @(posedge clk);
        #1 #1;
 check_outputs(64'h108);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Reset Priority Check", test_num);
        reset_dut();
        PC_In = 64'hDEAD_BEEF_CAFE_BABE;
        @(posedge clk);

        reset = 1;
        PC_In = 64'h1234_5678_90AB_CDEF;
        @(posedge clk);
        #1 #1;
 check_outputs(64'h0);
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
        input [63:0] expected_PC_Out;
        begin
            if (expected_PC_Out === (expected_PC_Out ^ PC_Out ^ expected_PC_Out)) begin
                $display("PASS");
                $display("  Outputs: PC_Out=%h",
                         PC_Out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: PC_Out=%h",
                         expected_PC_Out);
                $display("  Got:      PC_Out=%h",
                         PC_Out);
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
        $dumpvars(0,PC_In, clk, reset, PC_Out);
    end

endmodule
