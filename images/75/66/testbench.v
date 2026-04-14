`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg Enable;
    reg [7:0] Inst;
    reg [31:0] RD2_input;
    wire [31:0] ALUSrc2_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Enable(Enable),
        .Inst(Inst),
        .RD2_input(RD2_input),
        .ALUSrc2_output(ALUSrc2_output)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test %0d: Bypass Mode - Enable=0", test_num);
        Enable = 1'b0;
        RD2_input = 32'hABCD_1234;
        Inst = 8'h05;
        #1;

        check_outputs(32'hABCD_1234);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %0d: Shift Amount 0 - Enable=1", test_num);
        Enable = 1'b1;
        RD2_input = 32'h1234_5678;
        Inst = 8'h00;
        #1;

        check_outputs(32'h1234_5678);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %0d: Shift Left 1 bit - Enable=1", test_num);
        Enable = 1'b1;
        RD2_input = 32'h0000_0001;
        Inst = 8'h01;
        #1;

        check_outputs(32'h0000_0002);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %0d: Shift Left 4 bits - Enable=1", test_num);
        Enable = 1'b1;
        RD2_input = 32'h0000_000F;
        Inst = 8'h04;
        #1;

        check_outputs(32'h0000_00F0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %0d: Shift Left 16 bits - Enable=1", test_num);
        Enable = 1'b1;
        RD2_input = 32'h0000_FFFF;
        Inst = 8'h10;
        #1;

        check_outputs(32'hFFFF_0000);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test %0d: Max Shift 31 bits - Enable=1", test_num);
        Enable = 1'b1;
        RD2_input = 32'h0000_0001;
        Inst = 8'h1F;
        #1;

        check_outputs(32'h8000_0000);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test %0d: Input Validation - Higher Inst bits should be ignored", test_num);
        Enable = 1'b1;
        RD2_input = 32'h0000_0001;
        Inst = 8'hE2;
        #1;

        check_outputs(32'h0000_0004);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test %0d: Bypass Mode - Enable=0 with High Data", test_num);
        Enable = 1'b0;
        RD2_input = 32'hFFFF_FFFF;
        Inst = 8'h1F;
        #1;

        check_outputs(32'hFFFF_FFFF);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test %0d: Shifting Zero - Enable=1", test_num);
        Enable = 1'b1;
        RD2_input = 32'h0000_0000;
        Inst = 8'h08;
        #1;

        check_outputs(32'h0000_0000);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Test %0d: Shifting data out - Enable=1", test_num);
        Enable = 1'b1;
        RD2_input = 32'hF000_0000;
        Inst = 8'h04;
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
        testcase006();
        testcase007();
        testcase008();
        testcase009();
        testcase010();
        
        
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
        input [31:0] expected_ALUSrc2_output;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ALUSrc2_output === (expected_ALUSrc2_output ^ ALUSrc2_output ^ expected_ALUSrc2_output)) begin
                $display("PASS");
                $display("  Outputs: ALUSrc2_output=%h",
                         ALUSrc2_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ALUSrc2_output=%h",
                         expected_ALUSrc2_output);
                $display("  Got:      ALUSrc2_output=%h",
                         ALUSrc2_output);
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
