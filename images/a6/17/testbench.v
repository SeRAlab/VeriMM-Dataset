`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] regFw;
    reg [3:0] regIndex0;
    reg [3:0] regIndex1;
    reg [3:0] regIndexWr;
    reg [31:0] regRd0;
    reg [31:0] regRd1;
    reg wrEn;
    wire [31:0] reg0;
    wire [31:0] reg1;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .regFw(regFw),
        .regIndex0(regIndex0),
        .regIndex1(regIndex1),
        .regIndexWr(regIndexWr),
        .regRd0(regRd0),
        .regRd1(regRd1),
        .wrEn(wrEn),
        .reg0(reg0),
        .reg1(reg1)
    );
    task testcase001;

        begin
            test_num = 1;
            regRd0 = 32'hAAAA_AAAA;
            regRd1 = 32'hBBBB_BBBB;
            regFw  = 32'hFFFF_FFFF;
            regIndex0 = 4'd1;
            regIndex1 = 4'd2;
            regIndexWr = 4'd1;
            wrEn = 1'b0;
            #1;

            check_outputs(32'hAAAA_AAAA, 32'hBBBB_BBBB);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            regRd0 = 32'h1111_1111;
            regRd1 = 32'h2222_2222;
            regFw  = 32'hCCCC_CCCC;
            regIndex0 = 4'd5;
            regIndex1 = 4'd6;
            regIndexWr = 4'd5;
            wrEn = 1'b1;
            #1;

            check_outputs(32'hCCCC_CCCC, 32'h2222_2222);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            regRd0 = 32'h3333_3333;
            regRd1 = 32'h4444_4444;
            regFw  = 32'hDDDD_DDDD;
            regIndex0 = 4'd7;
            regIndex1 = 4'd8;
            regIndexWr = 4'd8;
            wrEn = 1'b1;
            #1;

            check_outputs(32'h3333_3333, 32'hDDDD_DDDD);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            regRd0 = 32'h5555_5555;
            regRd1 = 32'h6666_6666;
            regFw  = 32'hEEEE_EEEE;
            regIndex0 = 4'd10;
            regIndex1 = 4'd10;
            regIndexWr = 4'd10;
            wrEn = 1'b1;
            #1;

            check_outputs(32'hEEEE_EEEE, 32'hEEEE_EEEE);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            regRd0 = 32'h7777_7777;
            regRd1 = 32'h8888_8888;
            regFw  = 32'h9999_9999;
            regIndex0 = 4'd1;
            regIndex1 = 4'd2;
            regIndexWr = 4'd3;
            wrEn = 1'b1;
            #1;

            check_outputs(32'h7777_7777, 32'h8888_8888);
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
        input [31:0] expected_reg0;
        input [31:0] expected_reg1;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_reg0 === (expected_reg0 ^ reg0 ^ expected_reg0) &&
                expected_reg1 === (expected_reg1 ^ reg1 ^ expected_reg1)) begin
                $display("PASS");
                $display("  Outputs: reg0=%h, reg1=%h",
                         reg0, reg1);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: reg0=%h, reg1=%h",
                         expected_reg0, expected_reg1);
                $display("  Got:      reg0=%h, reg1=%h",
                         reg0, reg1);
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
