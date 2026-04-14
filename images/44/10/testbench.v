`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] i_mk15to12;
    reg [31:0] i_mk3to0;
    reg i_op;
    reg i_wf_post_pre;
    wire [7:0] o_wk0_4;
    wire [7:0] o_wk1_5;
    wire [7:0] o_wk2_6;
    wire [7:0] o_wk3_7;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .i_mk15to12(i_mk15to12),
        .i_mk3to0(i_mk3to0),
        .i_op(i_op),
        .i_wf_post_pre(i_wf_post_pre),
        .o_wk0_4(o_wk0_4),
        .o_wk1_5(o_wk1_5),
        .o_wk2_6(o_wk2_6),
        .o_wk3_7(o_wk3_7)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: i_op=0, i_wf_post_pre=0 (XOR=0) -> Select i_mk15to12", test_num);
            i_op = 0;
            i_wf_post_pre = 0;
            i_mk15to12 = 32'hAABBCCDD;
            i_mk3to0 = 32'h11223344;

            #1;


            check_outputs(8'hDD, 8'hCC, 8'hBB, 8'hAA);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: i_op=1, i_wf_post_pre=1 (XOR=0) -> Select i_mk15to12", test_num);
            i_op = 1;
            i_wf_post_pre = 1;
            i_mk15to12 = 32'hFEEDFACE;
            i_mk3to0 = 32'hDEADBEEF;

            #1;


            check_outputs(8'hCE, 8'hFA, 8'hED, 8'hFE);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: i_op=0, i_wf_post_pre=1 (XOR=1) -> Select i_mk3to0", test_num);
            i_op = 0;
            i_wf_post_pre = 1;
            i_mk15to12 = 32'hAABBCCDD;
            i_mk3to0 = 32'h11223344;

            #1;


            check_outputs(8'h44, 8'h33, 8'h22, 8'h11);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: i_op=1, i_wf_post_pre=0 (XOR=1) -> Select i_mk3to0", test_num);
            i_op = 1;
            i_wf_post_pre = 0;
            i_mk15to12 = 32'h00000000;
            i_mk3to0 = 32'hFFFFFFFF;

            #1;


            check_outputs(8'hFF, 8'hFF, 8'hFF, 8'hFF);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Edge case - All zeros for inputs, XOR=0", test_num);
            i_op = 0;
            i_wf_post_pre = 0;
            i_mk15to12 = 32'h0;
            i_mk3to0 = 32'hFFFFFFFF;

            #1;


            check_outputs(8'h00, 8'h00, 8'h00, 8'h00);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Pattern test, XOR=1", test_num);
            i_op = 1;
            i_wf_post_pre = 0;
            i_mk15to12 = 32'h55AA55AA;
            i_mk3to0 = 32'h12345678;

            #1;


            check_outputs(8'h78, 8'h56, 8'h34, 8'h12);
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
        input [7:0] expected_o_wk0_4;
        input [7:0] expected_o_wk1_5;
        input [7:0] expected_o_wk2_6;
        input [7:0] expected_o_wk3_7;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_o_wk0_4 === (expected_o_wk0_4 ^ o_wk0_4 ^ expected_o_wk0_4) &&
                expected_o_wk1_5 === (expected_o_wk1_5 ^ o_wk1_5 ^ expected_o_wk1_5) &&
                expected_o_wk2_6 === (expected_o_wk2_6 ^ o_wk2_6 ^ expected_o_wk2_6) &&
                expected_o_wk3_7 === (expected_o_wk3_7 ^ o_wk3_7 ^ expected_o_wk3_7)) begin
                $display("PASS");
                $display("  Outputs: o_wk0_4=%h, o_wk1_5=%h, o_wk2_6=%h, o_wk3_7=%h",
                         o_wk0_4, o_wk1_5, o_wk2_6, o_wk3_7);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o_wk0_4=%h, o_wk1_5=%h, o_wk2_6=%h, o_wk3_7=%h",
                         expected_o_wk0_4, expected_o_wk1_5, expected_o_wk2_6, expected_o_wk3_7);
                $display("  Got:      o_wk0_4=%h, o_wk1_5=%h, o_wk2_6=%h, o_wk3_7=%h",
                         o_wk0_4, o_wk1_5, o_wk2_6, o_wk3_7);
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
