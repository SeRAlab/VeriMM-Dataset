`timescale 1ns/1ps

module sparc_mul_cntl_tb;

    // Testbench signals (sequential circuit)
    reg ecl_mul_req_vld;
    reg rclk;
    reg rst_l;
    reg spu_mul_acc;
    reg spu_mul_areg_rst;
    reg spu_mul_areg_shf;
    reg spu_mul_mulres_lshft;
    reg spu_mul_req_vld;
    wire acc_actc2;
    wire acc_actc3;
    wire acc_actc5;
    wire acc_imm;
    wire acc_reg_enb;
    wire acc_reg_rst;
    wire acc_reg_shf;
    wire byp_imm;
    wire byp_sel;
    wire c0_act;
    wire mul_ecl_ack;
    wire mul_spu_ack;
    wire mul_spu_shf_ack;
    wire spick;
    wire x2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sparc_mul_cntl dut (
        .ecl_mul_req_vld(ecl_mul_req_vld),
        .rclk(rclk),
        .rst_l(rst_l),
        .spu_mul_acc(spu_mul_acc),
        .spu_mul_areg_rst(spu_mul_areg_rst),
        .spu_mul_areg_shf(spu_mul_areg_shf),
        .spu_mul_mulres_lshft(spu_mul_mulres_lshft),
        .spu_mul_req_vld(spu_mul_req_vld),
        .acc_actc2(acc_actc2),
        .acc_actc3(acc_actc3),
        .acc_actc5(acc_actc5),
        .acc_imm(acc_imm),
        .acc_reg_enb(acc_reg_enb),
        .acc_reg_rst(acc_reg_rst),
        .acc_reg_shf(acc_reg_shf),
        .byp_imm(byp_imm),
        .byp_sel(byp_sel),
        .c0_act(c0_act),
        .mul_ecl_ack(mul_ecl_ack),
        .mul_spu_ack(mul_spu_ack),
        .mul_spu_shf_ack(mul_spu_shf_ack),
        .spick(spick),
        .x2(x2)
    );

        task reset_dut;

        begin
            rst_l = 0;
            ecl_mul_req_vld = 0;
            spu_mul_req_vld = 0;
            spu_mul_acc = 0;
            spu_mul_areg_rst = 0;
            spu_mul_areg_shf = 0;
            spu_mul_mulres_lshft = 0;
            repeat(2) @(posedge rclk);
            #1 rst_l = 1;
            @(posedge rclk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Idle state check", test_num);
            reset_dut();

            #1;


            check_outputs(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: EXU Multiplication Request", test_num);
            reset_dut();
            @(posedge rclk);
            ecl_mul_req_vld = 1;
            #1;

            #1;


            check_outputs(0,0,0,0,0,0,0,0,0,1,1,0,0,0,0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: SPU Multiplication Request", test_num);
            reset_dut();
            @(posedge rclk);
            spu_mul_req_vld = 1;
            #1;

            #1;


            check_outputs(0,0,0,0,0,0,0,0,0,1,0,1,0,1,0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: SPU Accumulator Register Reset", test_num);
            reset_dut();
            @(posedge rclk);
            spu_mul_areg_rst = 1;
            #1;

            #1;


            check_outputs(0,0,0,0,0,1,0,0,0,0,0,0,0,0,0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: SPU Accumulator Register Shift", test_num);
            reset_dut();
            @(posedge rclk);
            spu_mul_areg_shf = 1;
            #1;

            #1;


            check_outputs(0,0,0,0,0,0,1,0,0,0,0,0,1,0,0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: SPU Mul Result Left Shift (X2)", test_num);
            reset_dut();
            @(posedge rclk);
            spu_mul_req_vld = 1;
            spu_mul_mulres_lshft = 1;
            #1;

            #1;


            check_outputs(0,0,0,0,0,0,0,0,0,1,0,1,0,1,1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %03d: Priority Arbitration (EXU + SPU Simultaneous)", test_num);
            reset_dut();
            @(posedge rclk);
            ecl_mul_req_vld = 1;
            spu_mul_req_vld = 1;
            #1;

            #1;


            check_outputs(0,0,0,0,0,0,0,0,0,1,1,0,0,0,0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %03d: SPU Accumulation Activation", test_num);
            reset_dut();
            @(posedge rclk);
            spu_mul_req_vld = 1;
            spu_mul_acc = 1;
            #1;



            #1;




            check_outputs(0,0,0,0,1,0,0,0,0,1,0,1,0,1,0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("sparc_mul_cntl Testbench");
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
        input expected_acc_actc2;
        input expected_acc_actc3;
        input expected_acc_actc5;
        input expected_acc_imm;
        input expected_acc_reg_enb;
        input expected_acc_reg_rst;
        input expected_acc_reg_shf;
        input expected_byp_imm;
        input expected_byp_sel;
        input expected_c0_act;
        input expected_mul_ecl_ack;
        input expected_mul_spu_ack;
        input expected_mul_spu_shf_ack;
        input expected_spick;
        input expected_x2;
        begin
            if (expected_acc_actc2 === (expected_acc_actc2 ^ acc_actc2 ^ expected_acc_actc2) &&
                expected_acc_actc3 === (expected_acc_actc3 ^ acc_actc3 ^ expected_acc_actc3) &&
                expected_acc_actc5 === (expected_acc_actc5 ^ acc_actc5 ^ expected_acc_actc5) &&
                expected_acc_imm === (expected_acc_imm ^ acc_imm ^ expected_acc_imm) &&
                expected_acc_reg_enb === (expected_acc_reg_enb ^ acc_reg_enb ^ expected_acc_reg_enb) &&
                expected_acc_reg_rst === (expected_acc_reg_rst ^ acc_reg_rst ^ expected_acc_reg_rst) &&
                expected_acc_reg_shf === (expected_acc_reg_shf ^ acc_reg_shf ^ expected_acc_reg_shf) &&
                expected_byp_imm === (expected_byp_imm ^ byp_imm ^ expected_byp_imm) &&
                expected_byp_sel === (expected_byp_sel ^ byp_sel ^ expected_byp_sel) &&
                expected_c0_act === (expected_c0_act ^ c0_act ^ expected_c0_act) &&
                expected_mul_ecl_ack === (expected_mul_ecl_ack ^ mul_ecl_ack ^ expected_mul_ecl_ack) &&
                expected_mul_spu_ack === (expected_mul_spu_ack ^ mul_spu_ack ^ expected_mul_spu_ack) &&
                expected_mul_spu_shf_ack === (expected_mul_spu_shf_ack ^ mul_spu_shf_ack ^ expected_mul_spu_shf_ack) &&
                expected_spick === (expected_spick ^ spick ^ expected_spick) &&
                expected_x2 === (expected_x2 ^ x2 ^ expected_x2)) begin
                $display("PASS");
                $display("  Outputs: acc_actc2=%b, acc_actc3=%b, acc_actc5=%b, acc_imm=%b, acc_reg_enb=%b, acc_reg_rst=%b, acc_reg_shf=%b, byp_imm=%b, byp_sel=%b, c0_act=%b, mul_ecl_ack=%b, mul_spu_ack=%b, mul_spu_shf_ack=%b, spick=%b, x2=%b",
                         acc_actc2, acc_actc3, acc_actc5, acc_imm, acc_reg_enb, acc_reg_rst, acc_reg_shf, byp_imm, byp_sel, c0_act, mul_ecl_ack, mul_spu_ack, mul_spu_shf_ack, spick, x2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: acc_actc2=%b, acc_actc3=%b, acc_actc5=%b, acc_imm=%b, acc_reg_enb=%b, acc_reg_rst=%b, acc_reg_shf=%b, byp_imm=%b, byp_sel=%b, c0_act=%b, mul_ecl_ack=%b, mul_spu_ack=%b, mul_spu_shf_ack=%b, spick=%b, x2=%b",
                         expected_acc_actc2, expected_acc_actc3, expected_acc_actc5, expected_acc_imm, expected_acc_reg_enb, expected_acc_reg_rst, expected_acc_reg_shf, expected_byp_imm, expected_byp_sel, expected_c0_act, expected_mul_ecl_ack, expected_mul_spu_ack, expected_mul_spu_shf_ack, expected_spick, expected_x2);
                $display("  Got:      acc_actc2=%b, acc_actc3=%b, acc_actc5=%b, acc_imm=%b, acc_reg_enb=%b, acc_reg_rst=%b, acc_reg_shf=%b, byp_imm=%b, byp_sel=%b, c0_act=%b, mul_ecl_ack=%b, mul_spu_ack=%b, mul_spu_shf_ack=%b, spick=%b, x2=%b",
                         acc_actc2, acc_actc3, acc_actc5, acc_imm, acc_reg_enb, acc_reg_rst, acc_reg_shf, byp_imm, byp_sel, c0_act, mul_ecl_ack, mul_spu_ack, mul_spu_shf_ack, spick, x2);
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,ecl_mul_req_vld, rclk, rst_l, spu_mul_acc, spu_mul_areg_rst, spu_mul_areg_shf, spu_mul_mulres_lshft, spu_mul_req_vld, acc_actc2, acc_actc3, acc_actc5, acc_imm, acc_reg_enb, acc_reg_rst, acc_reg_shf, byp_imm, byp_sel, c0_act, mul_ecl_ack, mul_spu_ack, mul_spu_shf_ack, spick, x2);
    end

endmodule
