`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg cond_dout;
    reg ena_;
    reg [7:0] inst;
    wire rdy_add_;
    wire rdy_clr_;
    wire rdy_cpf_;
    wire rdy_cpt_;
    wire rdy_im_;
    wire rdy_ld_;
    wire rdy_nop_;
    wire rdy_st_;
    wire rdy_sub_;
    wire rdy_tce_;
    wire rdy_ts_;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .cond_dout(cond_dout),
        .ena_(ena_),
        .inst(inst),
        .rdy_add_(rdy_add_),
        .rdy_clr_(rdy_clr_),
        .rdy_cpf_(rdy_cpf_),
        .rdy_cpt_(rdy_cpt_),
        .rdy_im_(rdy_im_),
        .rdy_ld_(rdy_ld_),
        .rdy_nop_(rdy_nop_),
        .rdy_st_(rdy_st_),
        .rdy_sub_(rdy_sub_),
        .rdy_tce_(rdy_tce_),
        .rdy_ts_(rdy_ts_)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Module Disabled (ena_ = 1)", test_num);
            ena_ = 1;
            inst = 8'h00;
            cond_dout = 0;

            #1;


            check_outputs(1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: NOP Instruction", test_num);
            ena_ = 0;
            inst = 8'h00;
            cond_dout = 0;

            #1;


            check_outputs(1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: CPF Instruction (Condition Met: cond_dout=0)", test_num);
            ena_ = 0;
            inst = 8'h01;
            cond_dout = 0;

            #1;


            check_outputs(1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: CPF Instruction (Condition Not Met: cond_dout=1)", test_num);
            ena_ = 0;
            inst = 8'h01;
            cond_dout = 1;

            #1;


            check_outputs(1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: CPT Instruction (Condition Met: cond_dout=1)", test_num);
            ena_ = 0;
            inst = 8'h02;
            cond_dout = 1;

            #1;


            check_outputs(1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: LD Instruction", test_num);
            ena_ = 0;
            inst = 8'h03;
            cond_dout = 0;

            #1;


            check_outputs(1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: ST Instruction", test_num);
            ena_ = 0;
            inst = 8'h04;
            cond_dout = 0;

            #1;


            check_outputs(1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: CLR Instruction", test_num);
            ena_ = 0;
            inst = 8'h05;
            cond_dout = 0;

            #1;


            check_outputs(1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Testcase %0d: IM Instruction", test_num);
            ena_ = 0;
            inst = 8'h06;
            cond_dout = 0;

            #1;


            check_outputs(1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Testcase %0d: TCE Instruction", test_num);
            ena_ = 0;
            inst = 8'h07;
            cond_dout = 0;

            #1;


            check_outputs(1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1);
        end
        endtask

    task testcase011;

        begin
            test_num = 11;
            $display("Testcase %0d: TS Instruction", test_num);
            ena_ = 0;
            inst = 8'h08;
            cond_dout = 0;

            #1;


            check_outputs(1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0);
        end
        endtask

    task testcase012;

        begin
            test_num = 12;
            $display("Testcase %0d: ADD Instruction", test_num);
            ena_ = 0;
            inst = 8'h09;
            cond_dout = 0;

            #1;


            check_outputs(0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1);
        end
        endtask

    task testcase013;

        begin
            test_num = 13;
            $display("Testcase %0d: SUB Instruction", test_num);
            ena_ = 0;
            inst = 8'h0A;
            cond_dout = 0;

            #1;


            check_outputs(1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1);
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
        testcase011();
        testcase012();
        testcase013();
        
        
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
        input expected_rdy_add_;
        input expected_rdy_clr_;
        input expected_rdy_cpf_;
        input expected_rdy_cpt_;
        input expected_rdy_im_;
        input expected_rdy_ld_;
        input expected_rdy_nop_;
        input expected_rdy_st_;
        input expected_rdy_sub_;
        input expected_rdy_tce_;
        input expected_rdy_ts_;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_rdy_add_ === (expected_rdy_add_ ^ rdy_add_ ^ expected_rdy_add_) &&
                expected_rdy_clr_ === (expected_rdy_clr_ ^ rdy_clr_ ^ expected_rdy_clr_) &&
                expected_rdy_cpf_ === (expected_rdy_cpf_ ^ rdy_cpf_ ^ expected_rdy_cpf_) &&
                expected_rdy_cpt_ === (expected_rdy_cpt_ ^ rdy_cpt_ ^ expected_rdy_cpt_) &&
                expected_rdy_im_ === (expected_rdy_im_ ^ rdy_im_ ^ expected_rdy_im_) &&
                expected_rdy_ld_ === (expected_rdy_ld_ ^ rdy_ld_ ^ expected_rdy_ld_) &&
                expected_rdy_nop_ === (expected_rdy_nop_ ^ rdy_nop_ ^ expected_rdy_nop_) &&
                expected_rdy_st_ === (expected_rdy_st_ ^ rdy_st_ ^ expected_rdy_st_) &&
                expected_rdy_sub_ === (expected_rdy_sub_ ^ rdy_sub_ ^ expected_rdy_sub_) &&
                expected_rdy_tce_ === (expected_rdy_tce_ ^ rdy_tce_ ^ expected_rdy_tce_) &&
                expected_rdy_ts_ === (expected_rdy_ts_ ^ rdy_ts_ ^ expected_rdy_ts_)) begin
                $display("PASS");
                $display("  Outputs: rdy_add_=%b, rdy_clr_=%b, rdy_cpf_=%b, rdy_cpt_=%b, rdy_im_=%b, rdy_ld_=%b, rdy_nop_=%b, rdy_st_=%b, rdy_sub_=%b, rdy_tce_=%b, rdy_ts_=%b",
                         rdy_add_, rdy_clr_, rdy_cpf_, rdy_cpt_, rdy_im_, rdy_ld_, rdy_nop_, rdy_st_, rdy_sub_, rdy_tce_, rdy_ts_);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rdy_add_=%b, rdy_clr_=%b, rdy_cpf_=%b, rdy_cpt_=%b, rdy_im_=%b, rdy_ld_=%b, rdy_nop_=%b, rdy_st_=%b, rdy_sub_=%b, rdy_tce_=%b, rdy_ts_=%b",
                         expected_rdy_add_, expected_rdy_clr_, expected_rdy_cpf_, expected_rdy_cpt_, expected_rdy_im_, expected_rdy_ld_, expected_rdy_nop_, expected_rdy_st_, expected_rdy_sub_, expected_rdy_tce_, expected_rdy_ts_);
                $display("  Got:      rdy_add_=%b, rdy_clr_=%b, rdy_cpf_=%b, rdy_cpt_=%b, rdy_im_=%b, rdy_ld_=%b, rdy_nop_=%b, rdy_st_=%b, rdy_sub_=%b, rdy_tce_=%b, rdy_ts_=%b",
                         rdy_add_, rdy_clr_, rdy_cpf_, rdy_cpt_, rdy_im_, rdy_ld_, rdy_nop_, rdy_st_, rdy_sub_, rdy_tce_, rdy_ts_);
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
