`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg clk;
    reg [35:0] datasw;
    reg key_dep;
    reg key_dep_nxt;
    reg key_ex;
    reg key_ex_nxt;
    reg key_exec;
    reg key_inst_cont;
    reg key_inst_stop;
    reg key_io_reset;
    reg key_mem_cont;
    reg key_mem_stop;
    reg key_read_in;
    reg key_start;
    reg [17:0] mas;
    reg reset;
    reg sw_addr_stop;
    reg sw_art3_maint;
    reg sw_mem_disable;
    reg sw_power;
    reg sw_repeat;
    reg sw_repeat_bypass;
    reg sw_rim_maint;
    reg sw_sct_maint;
    reg sw_split_cyc;
    wire [35:0] ar;
    wire [7:0] ff0;
    wire [7:0] ff1;
    wire [7:0] ff10;
    wire [7:0] ff11;
    wire [7:0] ff12;
    wire [7:0] ff13;
    wire [7:0] ff2;
    wire [7:0] ff3;
    wire [7:0] ff4;
    wire [7:0] ff5;
    wire [7:0] ff6;
    wire [7:0] ff7;
    wire [7:0] ff8;
    wire [7:0] ff9;
    wire [17:0] ir;
    wire [17:0] ma;
    wire [35:0] mb;
    wire mc_stop;
    wire [35:0] mi;
    wire [35:0] mq;
    wire [17:0] pc;
    wire pi_active;
    wire [6:0] pih;
    wire [6:0] pio;
    wire [6:0] pir;
    wire power;
    wire [7:0] pr;
    wire [7:0] rla;
    wire [7:0] rlr;
    wire run;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .datasw(datasw),
        .key_dep(key_dep),
        .key_dep_nxt(key_dep_nxt),
        .key_ex(key_ex),
        .key_ex_nxt(key_ex_nxt),
        .key_exec(key_exec),
        .key_inst_cont(key_inst_cont),
        .key_inst_stop(key_inst_stop),
        .key_io_reset(key_io_reset),
        .key_mem_cont(key_mem_cont),
        .key_mem_stop(key_mem_stop),
        .key_read_in(key_read_in),
        .key_start(key_start),
        .mas(mas),
        .reset(reset),
        .sw_addr_stop(sw_addr_stop),
        .sw_art3_maint(sw_art3_maint),
        .sw_mem_disable(sw_mem_disable),
        .sw_power(sw_power),
        .sw_repeat(sw_repeat),
        .sw_repeat_bypass(sw_repeat_bypass),
        .sw_rim_maint(sw_rim_maint),
        .sw_sct_maint(sw_sct_maint),
        .sw_split_cyc(sw_split_cyc),
        .ar(ar),
        .ff0(ff0),
        .ff1(ff1),
        .ff10(ff10),
        .ff11(ff11),
        .ff12(ff12),
        .ff13(ff13),
        .ff2(ff2),
        .ff3(ff3),
        .ff4(ff4),
        .ff5(ff5),
        .ff6(ff6),
        .ff7(ff7),
        .ff8(ff8),
        .ff9(ff9),
        .ir(ir),
        .ma(ma),
        .mb(mb),
        .mc_stop(mc_stop),
        .mi(mi),
        .mq(mq),
        .pc(pc),
        .pi_active(pi_active),
        .pih(pih),
        .pio(pio),
        .pir(pir),
        .power(power),
        .pr(pr),
        .rla(rla),
        .rlr(rlr),
        .run(run)
    );
    task initialize;

        begin
            datasw = 0; key_dep = 0; key_dep_nxt = 0; key_ex = 0; key_ex_nxt = 0;
            key_exec = 0; key_inst_cont = 0; key_inst_stop = 0; key_io_reset = 0;
            key_mem_cont = 0; key_mem_stop = 0; key_read_in = 0; key_start = 0;
            mas = 0; reset = 0; sw_addr_stop = 0; sw_art3_maint = 0; sw_mem_disable = 0;
            sw_power = 0; sw_repeat = 0; sw_repeat_bypass = 0; sw_rim_maint = 0;
            sw_sct_maint = 0; sw_split_cyc = 0;
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: System Reset and Power Off state", test_num);
            initialize();
            reset = 1;
            #20;
            reset = 0;
            #10;
            #1;

            check_outputs(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Power On initialization", test_num);
            initialize();
            reset = 1; #10; reset = 0; #10;
            sw_power = 1;
            #20;

            #1;


            check_outputs(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Load Memory Address via Examine Key", test_num);
            initialize();
            reset = 1; #10; reset = 0;
            sw_power = 1;
            mas = 18'h3ABCD;
            #10;
            key_ex = 1;
            #20;
            key_ex = 0;
            #10;

            #1;


            check_outputs(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 18'h3ABCD, 0, 0, 0, 0, 18'h3ABCD, 0, 0, 0, 0, 1, 0, 0, 0, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Deposit Data via Deposit Key", test_num);
            initialize();
            reset = 1; #10; reset = 0;
            sw_power = 1;
            mas = 18'h10000;
            datasw = 36'hCAFEBABE5;
            #10;
            key_dep = 1;
            #20;
            key_dep = 0;
            #10;

            #1;


            check_outputs(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 18'h10000, 36'hCAFEBABE5, 0, 36'hCAFEBABE5, 0, 18'h10000, 0, 0, 0, 0, 1, 0, 0, 0, 0);
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
        input [35:0] expected_ar;
        input [7:0] expected_ff0;
        input [7:0] expected_ff1;
        input [7:0] expected_ff10;
        input [7:0] expected_ff11;
        input [7:0] expected_ff12;
        input [7:0] expected_ff13;
        input [7:0] expected_ff2;
        input [7:0] expected_ff3;
        input [7:0] expected_ff4;
        input [7:0] expected_ff5;
        input [7:0] expected_ff6;
        input [7:0] expected_ff7;
        input [7:0] expected_ff8;
        input [7:0] expected_ff9;
        input [17:0] expected_ir;
        input [17:0] expected_ma;
        input [35:0] expected_mb;
        input expected_mc_stop;
        input [35:0] expected_mi;
        input [35:0] expected_mq;
        input [17:0] expected_pc;
        input expected_pi_active;
        input [6:0] expected_pih;
        input [6:0] expected_pio;
        input [6:0] expected_pir;
        input expected_power;
        input [7:0] expected_pr;
        input [7:0] expected_rla;
        input [7:0] expected_rlr;
        input expected_run;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ar === (expected_ar ^ ar ^ expected_ar) &&
                expected_ff0 === (expected_ff0 ^ ff0 ^ expected_ff0) &&
                expected_ff1 === (expected_ff1 ^ ff1 ^ expected_ff1) &&
                expected_ff10 === (expected_ff10 ^ ff10 ^ expected_ff10) &&
                expected_ff11 === (expected_ff11 ^ ff11 ^ expected_ff11) &&
                expected_ff12 === (expected_ff12 ^ ff12 ^ expected_ff12) &&
                expected_ff13 === (expected_ff13 ^ ff13 ^ expected_ff13) &&
                expected_ff2 === (expected_ff2 ^ ff2 ^ expected_ff2) &&
                expected_ff3 === (expected_ff3 ^ ff3 ^ expected_ff3) &&
                expected_ff4 === (expected_ff4 ^ ff4 ^ expected_ff4) &&
                expected_ff5 === (expected_ff5 ^ ff5 ^ expected_ff5) &&
                expected_ff6 === (expected_ff6 ^ ff6 ^ expected_ff6) &&
                expected_ff7 === (expected_ff7 ^ ff7 ^ expected_ff7) &&
                expected_ff8 === (expected_ff8 ^ ff8 ^ expected_ff8) &&
                expected_ff9 === (expected_ff9 ^ ff9 ^ expected_ff9) &&
                expected_ir === (expected_ir ^ ir ^ expected_ir) &&
                expected_ma === (expected_ma ^ ma ^ expected_ma) &&
                expected_mb === (expected_mb ^ mb ^ expected_mb) &&
                expected_mc_stop === (expected_mc_stop ^ mc_stop ^ expected_mc_stop) &&
                expected_mi === (expected_mi ^ mi ^ expected_mi) &&
                expected_mq === (expected_mq ^ mq ^ expected_mq) &&
                expected_pc === (expected_pc ^ pc ^ expected_pc) &&
                expected_pi_active === (expected_pi_active ^ pi_active ^ expected_pi_active) &&
                expected_pih === (expected_pih ^ pih ^ expected_pih) &&
                expected_pio === (expected_pio ^ pio ^ expected_pio) &&
                expected_pir === (expected_pir ^ pir ^ expected_pir) &&
                expected_power === (expected_power ^ power ^ expected_power) &&
                expected_pr === (expected_pr ^ pr ^ expected_pr) &&
                expected_rla === (expected_rla ^ rla ^ expected_rla) &&
                expected_rlr === (expected_rlr ^ rlr ^ expected_rlr) &&
                expected_run === (expected_run ^ run ^ expected_run)) begin
                $display("PASS");
                $display("  Outputs: ar=%h, ff0=%h, ff1=%h, ff10=%h, ff11=%h, ff12=%h, ff13=%h, ff2=%h, ff3=%h, ff4=%h, ff5=%h, ff6=%h, ff7=%h, ff8=%h, ff9=%h, ir=%h, ma=%h, mb=%h, mc_stop=%b, mi=%h, mq=%h, pc=%h, pi_active=%b, pih=%h, pio=%h, pir=%h, power=%b, pr=%h, rla=%h, rlr=%h, run=%b",
                         ar, ff0, ff1, ff10, ff11, ff12, ff13, ff2, ff3, ff4, ff5, ff6, ff7, ff8, ff9, ir, ma, mb, mc_stop, mi, mq, pc, pi_active, pih, pio, pir, power, pr, rla, rlr, run);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ar=%h, ff0=%h, ff1=%h, ff10=%h, ff11=%h, ff12=%h, ff13=%h, ff2=%h, ff3=%h, ff4=%h, ff5=%h, ff6=%h, ff7=%h, ff8=%h, ff9=%h, ir=%h, ma=%h, mb=%h, mc_stop=%b, mi=%h, mq=%h, pc=%h, pi_active=%b, pih=%h, pio=%h, pir=%h, power=%b, pr=%h, rla=%h, rlr=%h, run=%b",
                         expected_ar, expected_ff0, expected_ff1, expected_ff10, expected_ff11, expected_ff12, expected_ff13, expected_ff2, expected_ff3, expected_ff4, expected_ff5, expected_ff6, expected_ff7, expected_ff8, expected_ff9, expected_ir, expected_ma, expected_mb, expected_mc_stop, expected_mi, expected_mq, expected_pc, expected_pi_active, expected_pih, expected_pio, expected_pir, expected_power, expected_pr, expected_rla, expected_rlr, expected_run);
                $display("  Got:      ar=%h, ff0=%h, ff1=%h, ff10=%h, ff11=%h, ff12=%h, ff13=%h, ff2=%h, ff3=%h, ff4=%h, ff5=%h, ff6=%h, ff7=%h, ff8=%h, ff9=%h, ir=%h, ma=%h, mb=%h, mc_stop=%b, mi=%h, mq=%h, pc=%h, pi_active=%b, pih=%h, pio=%h, pir=%h, power=%b, pr=%h, rla=%h, rlr=%h, run=%b",
                         ar, ff0, ff1, ff10, ff11, ff12, ff13, ff2, ff3, ff4, ff5, ff6, ff7, ff8, ff9, ir, ma, mb, mc_stop, mi, mq, pc, pi_active, pih, pio, pir, power, pr, rla, rlr, run);
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
