`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] EXData1;
    reg [31:0] EXData2;
    reg LoadUse1;
    reg LoadUse2;
    reg clk;
    reg rst;
    wire [31:0] EXRegister1Data;
    wire [31:0] EXRegister2Data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .EXData1(EXData1),
        .EXData2(EXData2),
        .LoadUse1(LoadUse1),
        .LoadUse2(LoadUse2),
        .clk(clk),
        .rst(rst),
        .EXRegister1Data(EXRegister1Data),
        .EXRegister2Data(EXRegister2Data)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            EXData1 = 32'h0;
            EXData2 = 32'h0;
            LoadUse1 = 1'b0;
            LoadUse2 = 1'b0;
            @(posedge clk);
            #2 rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Running Testcase 001: Reset behavior...");
            test_num = 1;
            reset_dut();

            #1;


            check_outputs(32'h0, 32'h0);
        end
        endtask

    task testcase002;

        begin
            $display("Running Testcase 002: Normal data capture (LoadUse=1)...");
            test_num = 2;
            reset_dut();
            EXData1 = 32'hAAAAAAAA;
            EXData2 = 32'hBBBBBBBB;
            LoadUse1 = 1'b1;
            LoadUse2 = 1'b1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'hAAAAAAAA, 32'hBBBBBBBB);
        end
        endtask

    task testcase003;

        begin
            $display("Running Testcase 003: Data holding (LoadUse=0)...");
            test_num = 3;
            reset_dut();

            EXData1 = 32'h11111111;
            EXData2 = 32'h22222222;
            LoadUse1 = 1'b1;
            LoadUse2 = 1'b1;
            @(posedge clk);
            #1;

            EXData1 = 32'hFFFFFFFF;
            EXData2 = 32'hEEEEEEEE;
            LoadUse1 = 1'b0;
            LoadUse2 = 1'b0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(32'h11111111, 32'h22222222);
        end
        endtask

    task testcase004;

        begin
            $display("Running Testcase 004: Mixed behavior (LoadUse1=1, LoadUse2=0)...");
            test_num = 4;
            reset_dut();

            EXData1 = 32'hDEADBEEF;
            EXData2 = 32'hCAFEBABE;
            LoadUse1 = 1'b1;
            LoadUse2 = 1'b1;
            @(posedge clk);
            #1;

            EXData1 = 32'h88888888;
            EXData2 = 32'h99999999;
            LoadUse1 = 1'b1;
            LoadUse2 = 1'b0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h88888888, 32'hCAFEBABE);
        end
        endtask

    task testcase005;

        begin
            $display("Running Testcase 005: Mixed behavior (LoadUse1=0, LoadUse2=1)...");
            test_num = 5;
            reset_dut();

            EXData1 = 32'h12345678;
            EXData2 = 32'h87654321;
            LoadUse1 = 1'b1;
            LoadUse2 = 1'b1;
            @(posedge clk);
            #1;

            EXData1 = 32'h0000FFFF;
            EXData2 = 32'hFFFF0000;
            LoadUse1 = 1'b0;
            LoadUse2 = 1'b1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h12345678, 32'hFFFF0000);
        end
        endtask

    task testcase006;

        begin
            $display("Running Testcase 006: Successive data forwarding...");
            test_num = 6;
            reset_dut();
            EXData1 = 32'hABCDEF01;
            EXData2 = 32'h10FEDCBA;
            LoadUse1 = 1'b1;
            LoadUse2 = 1'b1;
            @(posedge clk);
            #1;
            EXData1 = 32'h5555AAAA;
            EXData2 = 32'hAAAA5555;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h5555AAAA, 32'hAAAA5555);
        end
        endtask

    task testcase007;

        begin
            $display("Running Testcase 007: Mid-operation reset...");
            test_num = 7;
            reset_dut();
            EXData1 = 32'hFFFFFFFF;
            EXData2 = 32'hFFFFFFFF;
            LoadUse1 = 1'b1;
            LoadUse2 = 1'b1;
            @(posedge clk);
            #1;
            rst = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h0, 32'h0);
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
        input [31:0] expected_EXRegister1Data;
        input [31:0] expected_EXRegister2Data;
        begin
            if (expected_EXRegister1Data === (expected_EXRegister1Data ^ EXRegister1Data ^ expected_EXRegister1Data) &&
                expected_EXRegister2Data === (expected_EXRegister2Data ^ EXRegister2Data ^ expected_EXRegister2Data)) begin
                $display("PASS");
                $display("  Outputs: EXRegister1Data=%h, EXRegister2Data=%h",
                         EXRegister1Data, EXRegister2Data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: EXRegister1Data=%h, EXRegister2Data=%h",
                         expected_EXRegister1Data, expected_EXRegister2Data);
                $display("  Got:      EXRegister1Data=%h, EXRegister2Data=%h",
                         EXRegister1Data, EXRegister2Data);
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
        $dumpvars(0,EXData1, EXData2, LoadUse1, LoadUse2, clk, rst, EXRegister1Data, EXRegister2Data);
    end

endmodule
