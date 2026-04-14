`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] GPRSel;
    reg clk;
    reg [31:0] in0;
    reg [31:0] in1;
    reg [31:0] in2;
    wire [31:0] WrReg;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .GPRSel(GPRSel),
        .clk(clk),
        .in0(in0),
        .in1(in1),
        .in2(in2),
        .WrReg(WrReg)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Select in0 (GPRSel = 00)", test_num);
            in0 = 32'hAAAA_BBBB;
            in1 = 32'hCCCC_DDDD;
            in2 = 32'hEEEE_FFFF;
            GPRSel = 2'b00;
            @(posedge clk);
            #1;

            check_outputs(32'hAAAA_BBBB);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Select in1 (GPRSel = 01)", test_num);
            in0 = 32'h1234_5678;
            in1 = 32'h8765_4321;
            in2 = 32'hDEAD_BEEF;
            GPRSel = 2'b01;
            @(posedge clk);
            #1;

            check_outputs(32'h8765_4321);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Select in2 (GPRSel = 10)", test_num);
            in0 = 32'h0000_1111;
            in1 = 32'h2222_3333;
            in2 = 32'h4444_5555;
            GPRSel = 2'b10;
            @(posedge clk);
            #1;

            check_outputs(32'h4444_5555);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Select Default/Zero (GPRSel = 11)", test_num);
            in0 = 32'hFFFF_FFFF;
            in1 = 32'hFFFF_FFFF;
            in2 = 32'hFFFF_FFFF;
            GPRSel = 2'b11;
            @(posedge clk);
            #1;

            check_outputs(32'h0000_0000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: All zero inputs selection", test_num);
            in0 = 32'h0;
            in1 = 32'h0;
            in2 = 32'h0;
            GPRSel = 2'b01;
            @(posedge clk);
            #1;

            check_outputs(32'h0000_0000);
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
        input [31:0] expected_WrReg;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_WrReg === (expected_WrReg ^ WrReg ^ expected_WrReg)) begin
                $display("PASS");
                $display("  Outputs: WrReg=%h",
                         WrReg);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: WrReg=%h",
                         expected_WrReg);
                $display("  Got:      WrReg=%h",
                         WrReg);
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
