`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] DAddr;
    reg [31:0] DataIn;
    reg clk;
    reg nRD;
    reg nWR;
    wire [31:0] DataOut;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .DAddr(DAddr),
        .DataIn(DataIn),
        .clk(clk),
        .nRD(nRD),
        .nWR(nWR),
        .DataOut(DataOut)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        nRD = 1'b1;
        nWR = 1'b1;
        DAddr = 32'h0;
        DataIn = 32'h0;
        @(negedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        reset_dut();

        DAddr = 32'h0;
        DataIn = 32'h12345678;
        nWR = 1'b0;
        @(negedge clk);
        #1;
        nWR = 1'b1;

        nRD = 1'b0;
        #2;
        #1;

        check_outputs(32'h12345678);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        reset_dut();

        DAddr = 32'h10;
        DataIn = 32'hDEADBEEF;
        nWR = 1'b0;
        @(negedge clk);
        #1;
        nWR = 1'b1;

        nRD = 1'b0;
        #2;
        #1;

        check_outputs(32'hDEADBEEF);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        reset_dut();

        DAddr = 32'h3C;
        DataIn = 32'hA5A55A5A;
        nWR = 1'b0;
        @(negedge clk);
        #1;
        nWR = 1'b1;

        nRD = 1'b0;
        #2;
        #1;

        check_outputs(32'hA5A55A5A);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        reset_dut();

        DAddr = 32'h08;
        DataIn = 32'h11111111;
        nWR = 1'b0;
        @(negedge clk);
        #1;

        DataIn = 32'h22222222;
        @(negedge clk);
        #1;
        nWR = 1'b1;

        nRD = 1'b0;
        #2;
        #1;

        check_outputs(32'h22222222);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        reset_dut();

        DAddr = 32'h14;
        DataIn = 32'h99887766;
        nWR = 1'b0;
        @(negedge clk);
        #1;
        nWR = 1'b1;
        nRD = 1'b1;
        #2;


        nRD = 1'b0;
        #2;
        #1;

        check_outputs(32'h99887766);
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
        input [31:0] expected_DataOut;
        begin
            if (expected_DataOut === (expected_DataOut ^ DataOut ^ expected_DataOut)) begin
                $display("PASS");
                $display("  Outputs: DataOut=%h",
                         DataOut);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: DataOut=%h",
                         expected_DataOut);
                $display("  Got:      DataOut=%h",
                         DataOut);
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
        $dumpvars(0,DAddr, DataIn, clk, nRD, nWR, DataOut);
    end

endmodule
