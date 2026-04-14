`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg clk;
    reg [7:0] data;
    reg ena;
    reg rst;
    wire [15:0] opc_iraddr;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data(data),
        .ena(ena),
        .rst(rst),
        .opc_iraddr(opc_iraddr)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Running Testcase 001: Reset Check");
        rst = 1;
        ena = 0;
        data = 8'hFF;
        @(negedge clk);
        rst = 0;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Running Testcase 002: Standard 16-bit Load");
        rst = 1; @(negedge clk); rst = 0;

        ena = 1; data = 8'hAB; @(negedge clk);
        ena = 1; data = 8'hCD; @(negedge clk);
        ena = 0;

        #1;


        check_outputs(16'hABCD);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Running Testcase 003: Enable Gating Check");
        rst = 1; @(negedge clk); rst = 0;

        ena = 1; data = 8'h12; @(negedge clk);
        ena = 0; data = 8'hFF; @(negedge clk);
        ena = 0; data = 8'hEE; @(negedge clk);
        ena = 1; data = 8'h34; @(negedge clk);
        ena = 0;

        #1;


        check_outputs(16'h1234);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Running Testcase 004: Consecutive Loads");
        rst = 1; @(negedge clk); rst = 0;


        ena = 1; data = 8'h11; @(negedge clk);
        ena = 1; data = 8'h22; @(negedge clk);

        ena = 1; data = 8'h33; @(negedge clk);
        ena = 1; data = 8'h44; @(negedge clk);
        ena = 0;

        #1;


        check_outputs(16'h3344);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Running Testcase 005: Mid-Phase Reset");
        rst = 1; @(negedge clk); rst = 0;

        ena = 1; data = 8'hAA; @(negedge clk);
        rst = 1; @(negedge clk);
        rst = 0;

        ena = 1; data = 8'h55; @(negedge clk);
        ena = 1; data = 8'h66; @(negedge clk);
        ena = 0;

        #1;


        check_outputs(16'h5566);
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
        input [15:0] expected_opc_iraddr;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_opc_iraddr === (expected_opc_iraddr ^ opc_iraddr ^ expected_opc_iraddr)) begin
                $display("PASS");
                $display("  Outputs: opc_iraddr=%h",
                         opc_iraddr);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: opc_iraddr=%h",
                         expected_opc_iraddr);
                $display("  Got:      opc_iraddr=%h",
                         opc_iraddr);
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

endmodule
