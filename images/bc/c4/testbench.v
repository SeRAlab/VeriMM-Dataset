`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg [7:0] ZEN;
    reg [23:0] ZN;
    reg ZS;
    wire [7:0] ZEN1;
    wire [23:0] ZN1;
    wire ZS1;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .ZEN(ZEN),
        .ZN(ZN),
        .ZS(ZS),
        .ZEN1(ZEN1),
        .ZN1(ZN1),
        .ZS1(ZS1)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            ZN = 24'h0;
            ZEN = 8'h0;
            ZS = 1'b0;
            @(posedge CLK);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning testcase001: All Zeros");
            reset_dut();
            ZN = 24'h000000;
            ZEN = 8'h00;
            ZS = 1'b0;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(8'h00, 24'h000000, 1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning testcase002: All Ones");
            reset_dut();
            ZN = 24'hFFFFFF;
            ZEN = 8'hFF;
            ZS = 1'b1;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(8'hFF, 24'hFFFFFF, 1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning testcase003: Alternating Bits Pattern A");
            reset_dut();
            ZN = 24'hAAAAAA;
            ZEN = 8'hAA;
            ZS = 1'b1;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(8'hAA, 24'hAAAAAA, 1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning testcase004: Alternating Bits Pattern B");
            reset_dut();
            ZN = 24'h555555;
            ZEN = 8'h55;
            ZS = 1'b0;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(8'h55, 24'h555555, 1'b0);
        end
        endtask

    task testcase005;

        begin
            $display("\nRunning testcase005: Arbitrary Hex Pattern");
            reset_dut();
            ZN = 24'h123456;
            ZEN = 8'h78;
            ZS = 1'b1;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(8'h78, 24'h123456, 1'b1);
        end
        endtask

    task testcase006;

        begin
            $display("\nRunning testcase006: Single Bit and Boundary Check");
            reset_dut();
            ZN = 24'h800001;
            ZEN = 8'h81;
            ZS = 1'b0;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(8'h81, 24'h800001, 1'b0);
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
        input [7:0] expected_ZEN1;
        input [23:0] expected_ZN1;
        input expected_ZS1;
        begin
            if (expected_ZEN1 === (expected_ZEN1 ^ ZEN1 ^ expected_ZEN1) &&
                expected_ZN1 === (expected_ZN1 ^ ZN1 ^ expected_ZN1) &&
                expected_ZS1 === (expected_ZS1 ^ ZS1 ^ expected_ZS1)) begin
                $display("PASS");
                $display("  Outputs: ZEN1=%h, ZN1=%h, ZS1=%b",
                         ZEN1, ZN1, ZS1);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ZEN1=%h, ZN1=%h, ZS1=%b",
                         expected_ZEN1, expected_ZN1, expected_ZS1);
                $display("  Got:      ZEN1=%h, ZN1=%h, ZS1=%b",
                         ZEN1, ZN1, ZS1);
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
        $dumpvars(0,CLK, ZEN, ZN, ZS, ZEN1, ZN1, ZS1);
    end

endmodule
