`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg I_clk;
    reg [15:0] I_dmemAddress;
    reg [31:0] I_dmemData;
    reg [31:0] I_gpuData;
    reg [7:0] I_uartRxData;
    wire [31:0] O_dmemData;
    wire O_dmemEnable;
    wire O_gpuMemEnable;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .I_clk(I_clk),
        .I_dmemAddress(I_dmemAddress),
        .I_dmemData(I_dmemData),
        .I_gpuData(I_gpuData),
        .I_uartRxData(I_uartRxData),
        .O_dmemData(O_dmemData),
        .O_dmemEnable(O_dmemEnable),
        .O_gpuMemEnable(O_gpuMemEnable)
    );

    // Clock generation (10ns period)
    initial begin
        I_clk = 0;
        forever #5 I_clk = ~I_clk;
    end

        task reset_dut;

        begin
            I_dmemAddress = 16'h0;
            I_gpuData = 32'h0;
            I_dmemData = 32'h0;
            I_uartRxData = 8'h0;
            @(posedge I_clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Access Data Memory (0x1000)...");
            reset_dut();
            test_num = 1;
            I_dmemAddress = 16'h1000;
            I_dmemData = 32'h12345678;
            I_gpuData = 32'hAAAAAAAA;
            I_uartRxData = 8'h55;
            @(posedge I_clk);
            #2;
            #1;

            check_outputs(32'h12345678, 1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Access GPU Memory (0x8000)...");
            reset_dut();
            test_num = 2;
            I_dmemAddress = 16'h8000;
            I_dmemData = 32'hBBBBBBBB;
            I_gpuData = 32'h87654321;
            I_uartRxData = 8'hAA;
            @(posedge I_clk);
            #2;
            #1;

            check_outputs(32'h87654321, 1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Access UART Register (0x9000)...");
            reset_dut();
            test_num = 3;
            I_dmemAddress = 16'h9000;
            I_dmemData = 32'hCCCCCCCC;
            I_gpuData = 32'hDDDDDDDD;
            I_uartRxData = 8'hF0;
            @(posedge I_clk);
            #2;
            #1;

            check_outputs(32'h000000F0, 1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Boundary Data Memory (0x7FFF)...");
            reset_dut();
            test_num = 4;
            I_dmemAddress = 16'h7FFF;
            I_dmemData = 32'hCAFEBABE;
            @(posedge I_clk);
            #2;
            #1;

            check_outputs(32'hCAFEBABE, 1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Boundary GPU Memory (0x8FFF)...");
            reset_dut();
            test_num = 5;
            I_dmemAddress = 16'h8FFF;
            I_gpuData = 32'hDEADC0DE;
            @(posedge I_clk);
            #2;
            #1;

            check_outputs(32'hDEADC0DE, 1'b0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            $display("Running testcase006: Out of Range Address (0xFFFF)...");
            reset_dut();
            test_num = 6;
            I_dmemAddress = 16'hFFFF;
            @(posedge I_clk);
            #2;
            #1;

            check_outputs(32'h00000000, 1'b0, 1'b0);
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
        input [31:0] expected_O_dmemData;
        input expected_O_dmemEnable;
        input expected_O_gpuMemEnable;
        begin
            if (expected_O_dmemData === (expected_O_dmemData ^ O_dmemData ^ expected_O_dmemData) &&
                expected_O_dmemEnable === (expected_O_dmemEnable ^ O_dmemEnable ^ expected_O_dmemEnable) &&
                expected_O_gpuMemEnable === (expected_O_gpuMemEnable ^ O_gpuMemEnable ^ expected_O_gpuMemEnable)) begin
                $display("PASS");
                $display("  Outputs: O_dmemData=%h, O_dmemEnable=%b, O_gpuMemEnable=%b",
                         O_dmemData, O_dmemEnable, O_gpuMemEnable);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: O_dmemData=%h, O_dmemEnable=%b, O_gpuMemEnable=%b",
                         expected_O_dmemData, expected_O_dmemEnable, expected_O_gpuMemEnable);
                $display("  Got:      O_dmemData=%h, O_dmemEnable=%b, O_gpuMemEnable=%b",
                         O_dmemData, O_dmemEnable, O_gpuMemEnable);
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
        $dumpvars(0,I_clk, I_dmemAddress, I_dmemData, I_gpuData, I_uartRxData, O_dmemData, O_dmemEnable, O_gpuMemEnable);
    end

endmodule
