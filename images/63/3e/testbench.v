`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] AluCtrOut;
    reg [31:0] in1;
    reg [31:0] in2;
    wire [31:0] AluRes;
    wire zero;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .AluCtrOut(AluCtrOut),
        .in1(in1),
        .in2(in2),
        .AluRes(AluRes),
        .zero(zero)
    );
    task testcase001;

    begin
        test_num = 1;
        AluCtrOut = 4'b0010;
        in1 = 32'h0000000A;
        in2 = 32'h00000014;
        $display("Test %0d: Addition (10 + 20)", test_num);
        #1;

        check_outputs(32'h0000001E, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        AluCtrOut = 4'b0010;
        in1 = 32'hFFFFFFFF;
        in2 = 32'h00000001;
        $display("Test %0d: Addition (-1 + 1)", test_num);
        #1;

        check_outputs(32'h00000000, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        AluCtrOut = 4'b0110;
        in1 = 32'h00000064;
        in2 = 32'h00000028;
        $display("Test %0d: Subtraction (100 - 40)", test_num);
        #1;

        check_outputs(32'h0000003C, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        AluCtrOut = 4'b0110;
        in1 = 32'h00001234;
        in2 = 32'h00001234;
        $display("Test %0d: Subtraction Equal (0x1234 - 0x1234)", test_num);
        #1;

        check_outputs(32'h00000000, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        AluCtrOut = 4'b0000;
        in1 = 32'hF0F0F0F0;
        in2 = 32'hFFFF0000;
        $display("Test %0d: Bitwise AND", test_num);
        #1;

        check_outputs(32'hF0F00000, 1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        AluCtrOut = 4'b0001;
        in1 = 32'hAAAA5555;
        in2 = 32'h5555AAAA;
        $display("Test %0d: Bitwise OR", test_num);
        #1;

        check_outputs(32'hFFFFFFFF, 1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        AluCtrOut = 4'b0111;
        in1 = 32'd5;
        in2 = 32'd10;
        $display("Test %0d: SLT True (5 < 10)", test_num);
        #1;

        check_outputs(32'h00000001, 1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        AluCtrOut = 4'b0111;
        in1 = 32'd15;
        in2 = 32'd10;
        $display("Test %0d: SLT False (15 < 10)", test_num);
        #1;

        check_outputs(32'h00000000, 1'b1);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        AluCtrOut = 4'b0111;
        in1 = 32'hFFFFFFFF;
        in2 = 32'h00000001;
        $display("Test %0d: SLT Signed (-1 < 1)", test_num);
        #1;

        check_outputs(32'h00000001, 1'b0);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        AluCtrOut = 4'b0110;
        in1 = 32'd0;
        in2 = 32'd1;
        $display("Test %0d: Subtraction Negative result (0 - 1)", test_num);
        #1;

        check_outputs(32'hFFFFFFFF, 1'b0);
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
        input [31:0] expected_AluRes;
        input expected_zero;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_AluRes === (expected_AluRes ^ AluRes ^ expected_AluRes) &&
                expected_zero === (expected_zero ^ zero ^ expected_zero)) begin
                $display("PASS");
                $display("  Outputs: AluRes=%h, zero=%b",
                         AluRes, zero);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: AluRes=%h, zero=%b",
                         expected_AluRes, expected_zero);
                $display("  Got:      AluRes=%h, zero=%b",
                         AluRes, zero);
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
