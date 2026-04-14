`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] brnch_pc_sel_from_bhndlr;
    reg loop_start;
    reg [15:0] pc;
    reg [15:0] pc_plus1;
    reg [15:0] pc_plus2;
    reg [15:0] pc_plus3;
    reg update_bpred;
    wire [1:0] pred_to_pcsel;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .brnch_pc_sel_from_bhndlr(brnch_pc_sel_from_bhndlr),
        .loop_start(loop_start),
        .pc(pc),
        .pc_plus1(pc_plus1),
        .pc_plus2(pc_plus2),
        .pc_plus3(pc_plus3),
        .update_bpred(update_bpred),
        .pred_to_pcsel(pred_to_pcsel)
    );
    task set_pcs;

        begin
            pc = 16'h0000;
            pc_plus1 = 16'h0004;
            pc_plus2 = 16'h0008;
            pc_plus3 = 16'h000C;
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            set_pcs();
            update_bpred = 1'b0;
            loop_start = 1'b0;
            brnch_pc_sel_from_bhndlr = 4'b0000;
            $display("Testcase %0d: update_bpred=0, loop_start=0, branches=0000", test_num);
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            set_pcs();
            update_bpred = 1'b0;
            loop_start = 1'b1;
            brnch_pc_sel_from_bhndlr = 4'b1111;
            $display("Testcase %0d: update_bpred=0, loop_start=1, branches=1111", test_num);
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            set_pcs();
            update_bpred = 1'b1;
            loop_start = 1'b1;
            brnch_pc_sel_from_bhndlr = 4'b0000;
            $display("Testcase %0d: update_bpred=1, loop_start=1, branches=0000", test_num);
            #1;

            check_outputs(2'b11);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            set_pcs();
            update_bpred = 1'b1;
            loop_start = 1'b1;
            brnch_pc_sel_from_bhndlr = 4'b1010;
            $display("Testcase %0d: update_bpred=1, loop_start=1, branches=1010", test_num);
            #1;

            check_outputs(2'b11);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            set_pcs();
            update_bpred = 1'b1;
            loop_start = 1'b0;
            brnch_pc_sel_from_bhndlr = 4'b0001;
            $display("Testcase %0d: update_bpred=1, loop_start=0, single branch (bit 0)", test_num);
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            set_pcs();
            update_bpred = 1'b1;
            loop_start = 1'b0;
            brnch_pc_sel_from_bhndlr = 4'b1000;
            $display("Testcase %0d: update_bpred=1, loop_start=0, single branch (bit 3)", test_num);
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            set_pcs();
            update_bpred = 1'b1;
            loop_start = 1'b0;
            brnch_pc_sel_from_bhndlr = 4'b0000;
            $display("Testcase %0d: update_bpred=1, loop_start=0, zero branches", test_num);
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            set_pcs();
            update_bpred = 1'b1;
            loop_start = 1'b0;
            brnch_pc_sel_from_bhndlr = 4'b0011;
            $display("Testcase %0d: update_bpred=1, loop_start=0, multi branch (2 bits)", test_num);
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            set_pcs();
            update_bpred = 1'b1;
            loop_start = 1'b0;
            brnch_pc_sel_from_bhndlr = 4'b1111;
            $display("Testcase %0d: update_bpred=1, loop_start=0, multi branch (4 bits)", test_num);
            #1;

            check_outputs(2'b10);
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
        input [1:0] expected_pred_to_pcsel;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_pred_to_pcsel === (expected_pred_to_pcsel ^ pred_to_pcsel ^ expected_pred_to_pcsel)) begin
                $display("PASS");
                $display("  Outputs: pred_to_pcsel=%h",
                         pred_to_pcsel);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: pred_to_pcsel=%h",
                         expected_pred_to_pcsel);
                $display("  Got:      pred_to_pcsel=%h",
                         pred_to_pcsel);
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
