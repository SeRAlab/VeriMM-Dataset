`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] inALUOut;
    reg reset;
    wire [31:0] outALUOut;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .inALUOut(inALUOut),
        .reset(reset),
        .outALUOut(outALUOut)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        @(posedge clk);
        reset = 1;
        inALUOut = 32'hFFFFFFFF;
        @(posedge clk);
        reset = 0;
        inALUOut = 32'h0;
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Check reset state", test_num);
        reset_dut();
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Capture specific value 0x12345678", test_num);
        reset_dut();
        inALUOut = 32'h12345678;
        @(posedge clk);
        #1;
        #1;

        check_outputs(32'h12345678);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Capture alternating pattern 0xAAAAAAAA", test_num);
        reset_dut();
        inALUOut = 32'hAAAAAAAA;
        @(posedge clk);
        #1;
        #1;

        check_outputs(32'hAAAAAAAA);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Capture all ones 0xFFFFFFFF", test_num);
        reset_dut();
        inALUOut = 32'hFFFFFFFF;
        @(posedge clk);
        #1;
        #1;

        check_outputs(32'hFFFFFFFF);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Verify update on consecutive cycles", test_num);
        reset_dut();
        inALUOut = 32'h11111111;
        @(posedge clk);
        inALUOut = 32'h22222222;
        @(posedge clk);
        inALUOut = 32'h33333333;
        @(posedge clk);
        #1;
        #1;

        check_outputs(32'h33333333);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Reset priority over input", test_num);
        reset_dut();

        inALUOut = 32'hBEEFBEEF;
        @(posedge clk);

        reset = 1;
        inALUOut = 32'hCAFECAFE;
        @(posedge clk);
        #1;
        #1;

        check_outputs(32'h00000000);
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
        input [31:0] expected_outALUOut;
        begin
            if (expected_outALUOut === (expected_outALUOut ^ outALUOut ^ expected_outALUOut)) begin
                $display("PASS");
                $display("  Outputs: outALUOut=%h",
                         outALUOut);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: outALUOut=%h",
                         expected_outALUOut);
                $display("  Got:      outALUOut=%h",
                         outALUOut);
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
        $dumpvars(0,clk, inALUOut, reset, outALUOut);
    end

endmodule
