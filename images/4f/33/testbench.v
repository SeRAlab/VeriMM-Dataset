`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] instrIn;
    reg [31:0] pcplus4;
    wire [31:0] instrOut;
    wire [31:0] pcplus_4;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .instrIn(instrIn),
        .pcplus4(pcplus4),
        .instrOut(instrOut),
        .pcplus_4(pcplus_4)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            instrIn = 32'h0;
            pcplus4 = 32'h0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Standard Instruction");
            reset_dut();
            instrIn = 32'h00AF8020;
            pcplus4 = 32'h00000004;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h00AF8020, 32'h00000004);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: All Zeros");
            reset_dut();
            instrIn = 32'h00000000;
            pcplus4 = 32'h00000000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h00000000, 32'h00000000);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: All Ones");
            reset_dut();
            instrIn = 32'hFFFFFFFF;
            pcplus4 = 32'hFFFFFFFF;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'hFFFFFFFF, 32'hFFFFFFFF);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Bit Patterns");
            reset_dut();
            instrIn = 32'hAAAAAAAA;
            pcplus4 = 32'h55555555;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'hAAAAAAAA, 32'h55555555);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: High Memory Address");
            reset_dut();
            instrIn = 32'h03E00008;
            pcplus4 = 32'hBFFFFFFC;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h03E00008, 32'hBFFFFFFC);
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
        input [31:0] expected_instrOut;
        input [31:0] expected_pcplus_4;
        begin
            if (expected_instrOut === (expected_instrOut ^ instrOut ^ expected_instrOut) &&
                expected_pcplus_4 === (expected_pcplus_4 ^ pcplus_4 ^ expected_pcplus_4)) begin
                $display("PASS");
                $display("  Outputs: instrOut=%h, pcplus_4=%h",
                         instrOut, pcplus_4);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: instrOut=%h, pcplus_4=%h",
                         expected_instrOut, expected_pcplus_4);
                $display("  Got:      instrOut=%h, pcplus_4=%h",
                         instrOut, pcplus_4);
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
        $dumpvars(0,clk, instrIn, pcplus4, instrOut, pcplus_4);
    end

endmodule
