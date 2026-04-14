`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] HighMaskSel_Bot;
    reg [4:0] HighMaskSel_Top;
    reg [4:0] LowMaskSel_Bot;
    reg [4:0] LowMaskSel_Top;
    wire [63:0] HighLogicImm;
    wire [63:0] LogicImm;
    wire [63:0] LowLogicImm;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .HighMaskSel_Bot(HighMaskSel_Bot),
        .HighMaskSel_Top(HighMaskSel_Top),
        .LowMaskSel_Bot(LowMaskSel_Bot),
        .LowMaskSel_Top(LowMaskSel_Top),
        .HighLogicImm(HighLogicImm),
        .LogicImm(LogicImm),
        .LowLogicImm(LowLogicImm)
    );
    task testcase001;

        begin
            LowMaskSel_Bot  = 5'd0;
            HighMaskSel_Bot = 5'd31;
            LowMaskSel_Top  = 5'd0;
            HighMaskSel_Top = 5'd31;
            #1;

            check_outputs(64'hFFFFFFFF_FFFFFFFF, 64'hFFFFFFFF_FFFFFFFF, 64'hFFFFFFFF_FFFFFFFF);
        end
        endtask

    task testcase002;

        begin
            LowMaskSel_Bot  = 5'd16;
            HighMaskSel_Bot = 5'd31;
            LowMaskSel_Top  = 5'd0;
            HighMaskSel_Top = 5'd15;



            #1;




            check_outputs(64'h0000FFFF_FFFFFFFF, 64'h0000FFFF_FFFF0000, 64'hFFFFFFFF_FFFF0000);
        end
        endtask

    task testcase003;

        begin
            LowMaskSel_Bot  = 5'd31;
            HighMaskSel_Bot = 5'd31;
            LowMaskSel_Top  = 5'd0;
            HighMaskSel_Top = 5'd0;


            #1;



            check_outputs(64'h00000001_FFFFFFFF, 64'h00000001_80000000, 64'hFFFFFFFF_80000000);
        end
        endtask

    task testcase004;

        begin
            LowMaskSel_Bot  = 5'd8;
            HighMaskSel_Bot = 5'd23;
            LowMaskSel_Top  = 5'd4;
            HighMaskSel_Top = 5'd11;


            #1;



            check_outputs(64'h00000FFF_00FFFFFF, 64'h00000FF0_00FFFF00, 64'hFFFFFFF0_FFFFFF00);
        end
        endtask

    task testcase005;

        begin
            LowMaskSel_Bot  = 5'd20;
            HighMaskSel_Bot = 5'd10;
            LowMaskSel_Top  = 5'd10;
            HighMaskSel_Top = 5'd20;


            #1;



            check_outputs(64'h001FFFFF_000007FF, 64'h001FFC00_00000000, 64'hFFFFFC00_FFF00000);
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
        input [63:0] expected_HighLogicImm;
        input [63:0] expected_LogicImm;
        input [63:0] expected_LowLogicImm;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_HighLogicImm === (expected_HighLogicImm ^ HighLogicImm ^ expected_HighLogicImm) &&
                expected_LogicImm === (expected_LogicImm ^ LogicImm ^ expected_LogicImm) &&
                expected_LowLogicImm === (expected_LowLogicImm ^ LowLogicImm ^ expected_LowLogicImm)) begin
                $display("PASS");
                $display("  Outputs: HighLogicImm=%h, LogicImm=%h, LowLogicImm=%h",
                         HighLogicImm, LogicImm, LowLogicImm);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: HighLogicImm=%h, LogicImm=%h, LowLogicImm=%h",
                         expected_HighLogicImm, expected_LogicImm, expected_LowLogicImm);
                $display("  Got:      HighLogicImm=%h, LogicImm=%h, LowLogicImm=%h",
                         HighLogicImm, LogicImm, LowLogicImm);
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
