`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [63:0] ic_iq_instr;
    reg [63:0] ic_iq_pc;
    wire [63:0] align_instr;
    wire [3:0] align_instr_mask;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ic_iq_instr(ic_iq_instr),
        .ic_iq_pc(ic_iq_pc),
        .align_instr(align_instr),
        .align_instr_mask(align_instr_mask)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: PC offset 0", test_num);
            ic_iq_pc = 64'h0000_0000_0000_0000;
            ic_iq_instr = 64'hFEDC_BA98_7654_3210;
            #1;

            check_outputs(64'hFEDC_BA98_7654_3210, 4'b1111);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: PC offset 2", test_num);
            ic_iq_pc = 64'h0000_0000_0000_0002;
            ic_iq_instr = 64'hFEDC_BA98_7654_3210;
            #1;

            check_outputs(64'h0000_FEDC_BA98_7654, 4'b0111);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: PC offset 4", test_num);
            ic_iq_pc = 64'h0000_0000_0000_0004;
            ic_iq_instr = 64'hFEDC_BA98_7654_3210;
            #1;

            check_outputs(64'h0000_0000_FEDC_BA98, 4'b0011);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: PC offset 6", test_num);
            ic_iq_pc = 64'h0000_0000_0000_0006;
            ic_iq_instr = 64'hFEDC_BA98_7654_3210;
            #1;

            check_outputs(64'h0000_0000_0000_FEDC, 4'b0001);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: High PC address, offset 0", test_num);
            ic_iq_pc = 64'hFFFF_FFFF_FFFF_FFF0;
            ic_iq_instr = 64'hAAAA_BBBB_CCCC_DDDD;
            #1;

            check_outputs(64'hAAAA_BBBB_CCCC_DDDD, 4'b1111);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: High PC address, offset 4", test_num);
            ic_iq_pc = 64'hAAAA_BBBB_CCCC_DDDC;
            ic_iq_instr = 64'h1111_2222_3333_4444;
            #1;

            check_outputs(64'h0000_0000_1111_2222, 4'b0011);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Odd PC address (PC=3)", test_num);
            ic_iq_pc = 64'h0000_0000_0000_0003;
            ic_iq_instr = 64'h8888_9999_AAAA_BBBB;
            #1;

            check_outputs(64'h0000_8888_9999_AAAA, 4'b0111);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: PC offset 6, zero data test", test_num);
            ic_iq_pc = 64'h0000_0000_0000_000E;
            ic_iq_instr = 64'h0000_0000_0000_0000;
            #1;

            check_outputs(64'h0000_0000_0000_0000, 4'b0001);
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
        input [63:0] expected_align_instr;
        input [3:0] expected_align_instr_mask;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_align_instr === (expected_align_instr ^ align_instr ^ expected_align_instr) &&
                expected_align_instr_mask === (expected_align_instr_mask ^ align_instr_mask ^ expected_align_instr_mask)) begin
                $display("PASS");
                $display("  Outputs: align_instr=%h, align_instr_mask=%h",
                         align_instr, align_instr_mask);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: align_instr=%h, align_instr_mask=%h",
                         expected_align_instr, expected_align_instr_mask);
                $display("  Got:      align_instr=%h, align_instr_mask=%h",
                         align_instr, align_instr_mask);
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
