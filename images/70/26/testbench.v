`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [63:0] PCIn;
    reg clk;
    reg [31:0] ibus;
    wire [63:0] PCOut;
    wire [31:0] ibusWire;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .PCIn(PCIn),
        .clk(clk),
        .ibus(ibus),
        .PCOut(PCOut),
        .ibusWire(ibusWire)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            ibus = 32'h0;
            PCIn = 64'h0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Basic Data Transfer");
            reset_dut();
            test_num = 1;
            ibus = 32'h12345678;
            PCIn = 64'h0000_0000_ABCD_EF01;
            @(posedge clk);
            #1;
            #1;

            check_outputs(64'h0000_0000_ABCD_EF01, 32'h12345678);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: All Ones Pattern");
            reset_dut();
            test_num = 2;
            ibus = 32'hFFFFFFFF;
            PCIn = 64'hFFFFFFFF_FFFFFFFF;
            @(posedge clk);
            #1;
            #1;

            check_outputs(64'hFFFFFFFF_FFFFFFFF, 32'hFFFFFFFF);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Alternating Bit Pattern (AA/55)");
            reset_dut();
            test_num = 3;
            ibus = 32'hAAAAAAAA;
            PCIn = 64'h55555555_55555555;
            @(posedge clk);
            #1;
            #1;

            check_outputs(64'h55555555_55555555, 32'hAAAAAAAA);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: High Address Range");
            reset_dut();
            test_num = 4;
            ibus = 32'hDEADBEEF;
            PCIn = 64'hA000_0000_0000_0004;
            @(posedge clk);
            #1;
            #1;

            check_outputs(64'hA000_0000_0000_0004, 32'hDEADBEEF);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Zero Data Verification");
            reset_dut();
            test_num = 5;

            ibus = 32'h11111111;
            PCIn = 64'h11111111_11111111;
            @(posedge clk);
            #1;

            ibus = 32'h00000000;
            PCIn = 64'h00000000_00000000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(64'h00000000_00000000, 32'h00000000);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Sequential Pipelining Effect");
            reset_dut();
            test_num = 6;

            ibus = 32'h00000001;
            PCIn = 64'h0000000000000001;
            @(posedge clk);
            #1;

            ibus = 32'h00000002;
            PCIn = 64'h0000000000000002;

            #1;


            check_outputs(64'h0000000000000001, 32'h00000001);


            @(posedge clk);
            #1;
            #1;

            check_outputs(64'h0000000000000002, 32'h00000002);
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
        input [63:0] expected_PCOut;
        input [31:0] expected_ibusWire;
        begin
            if (expected_PCOut === (expected_PCOut ^ PCOut ^ expected_PCOut) &&
                expected_ibusWire === (expected_ibusWire ^ ibusWire ^ expected_ibusWire)) begin
                $display("PASS");
                $display("  Outputs: PCOut=%h, ibusWire=%h",
                         PCOut, ibusWire);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: PCOut=%h, ibusWire=%h",
                         expected_PCOut, expected_ibusWire);
                $display("  Got:      PCOut=%h, ibusWire=%h",
                         PCOut, ibusWire);
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
        $dumpvars(0,PCIn, clk, ibus, PCOut, ibusWire);
    end

endmodule
