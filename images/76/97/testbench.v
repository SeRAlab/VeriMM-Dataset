`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] D_IN;
    reg [4:0] SH_AMT;
    reg SH_DIR;
    wire [31:0] D_OUT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .D_IN(D_IN),
        .SH_AMT(SH_AMT),
        .SH_DIR(SH_DIR),
        .D_OUT(D_OUT)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Pass-through (SH_AMT[2]=0, DIR=0)", test_num);
        D_IN = 32'h12345678;
        SH_AMT = 5'b00000;
        SH_DIR = 0;
        #1;

        check_outputs(32'h12345678);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Pass-through (SH_AMT[2]=0, other bits set, DIR=1)", test_num);
        D_IN = 32'hA5A5A5A5;
        SH_AMT = 5'b11011;
        SH_DIR = 1;
        #1;

        check_outputs(32'hA5A5A5A5);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Right Shift 4 bits (MSB=0)", test_num);
        D_IN = 32'h12345678;
        SH_AMT = 5'b00100;
        SH_DIR = 0;

        #1;


        check_outputs(32'h01234567);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Right Shift 4 bits (MSB=1, fill with 0)", test_num);
        D_IN = 32'hF0F0F0F0;
        SH_AMT = 5'b00100;
        SH_DIR = 0;

        #1;


        check_outputs(32'h0F0F0F0F);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Left Shift 4 bits (Sign bit=0, fill with 0)", test_num);
        D_IN = 32'h12345678;
        SH_AMT = 5'b00100;
        SH_DIR = 1;

        #1;


        check_outputs(32'h23456780);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Left Shift 4 bits (Sign bit=1, fill with 1s)", test_num);
        D_IN = 32'h87654321;
        SH_AMT = 5'b00100;
        SH_DIR = 1;

        #1;


        check_outputs(32'h7654321F);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Left Shift with all 1s", test_num);
        D_IN = 32'hFFFFFFFF;
        SH_AMT = 5'b11100;
        SH_DIR = 1;
        #1;

        check_outputs(32'hFFFFFFFF);
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
        input [31:0] expected_D_OUT;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_D_OUT === (expected_D_OUT ^ D_OUT ^ expected_D_OUT)) begin
                $display("PASS");
                $display("  Outputs: D_OUT=%h",
                         D_OUT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: D_OUT=%h",
                         expected_D_OUT);
                $display("  Got:      D_OUT=%h",
                         D_OUT);
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
