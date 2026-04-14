`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] ALUSrcB;
    reg clk;
    reg [31:0] in0;
    reg [31:0] in2;
    reg [31:0] in3;
    wire [31:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ALUSrcB(ALUSrcB),
        .clk(clk),
        .in0(in0),
        .in2(in2),
        .in3(in3),
        .out(out)
    );
    task testcase001;

    begin
        test_num = 1;
        in0 = 32'hDEAD_BEEF;
        in2 = 32'h0;
        in3 = 32'h0;
        ALUSrcB = 2'b00;
        $display("Testcase %0d: ALUSrcB=00 - Selecting in0", test_num);
        #1;

        check_outputs(in0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        in0 = 32'h1234_5678;
        in2 = 32'hAAAA_BBBB;
        in3 = 32'hCCCC_DDDD;
        ALUSrcB = 2'b01;
        $display("Testcase %0d: ALUSrcB=01 - Selecting constant 32'd4", test_num);
        #1;

        check_outputs(32'd4);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        in0 = 32'h0;
        in2 = 32'hCAFE_BABE;
        in3 = 32'h0;
        ALUSrcB = 2'b10;
        $display("Testcase %0d: ALUSrcB=10 - Selecting in2", test_num);
        #1;

        check_outputs(in2);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        in0 = 32'h0;
        in2 = 32'h0;
        in3 = 32'hFACE_FEED;
        ALUSrcB = 2'b11;
        $display("Testcase %0d: ALUSrcB=11 - Selecting in3", test_num);
        #1;

        check_outputs(in3);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        ALUSrcB = 2'b00;
        in0 = 32'hF0F0_F0F0;
        $display("Testcase %0d: ALUSrcB=00 - Changing in0 value", test_num);
        #1;

        check_outputs(32'hF0F0_F0F0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        ALUSrcB = 2'b10;
        in2 = 32'h00FF_00FF;
        $display("Testcase %0d: ALUSrcB=10 - Changing in2 value", test_num);
        #1;

        check_outputs(32'h00FF_00FF);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        ALUSrcB = 2'b11;
        in3 = 32'hFFFF_0000;
        $display("Testcase %0d: ALUSrcB=11 - Changing in3 value", test_num);
        #1;

        check_outputs(32'hFFFF_0000);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        ALUSrcB = 2'b01;
        in0 = 32'hFFFF_FFFF;
        in2 = 32'hEEEE_EEEE;
        in3 = 32'hDDDD_DDDD;
        $display("Testcase %0d: ALUSrcB=01 - Verify output remains 4 regardless of input signals", test_num);
        #1;

        check_outputs(32'd4);
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
        testcase008();
        
        
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
        input [31:0] expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
