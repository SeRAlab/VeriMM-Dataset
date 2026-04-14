`timescale 1ns/1ps

module decode_state_tb;

    // Testbench signals (sequential circuit)
    reg address_is_1;
    reg clk;
    reg ctl_repeat_we;
    reg ctl_state_alu;
    reg ctl_state_halt_set;
    reg ctl_state_ixiy_clr;
    reg ctl_state_ixiy_we;
    reg ctl_state_iy_set;
    reg ctl_state_tbl_cb_set;
    reg ctl_state_tbl_ed_set;
    reg ctl_state_tbl_we;
    reg in_intr;
    reg in_nmi;
    reg nhold_clk_wait;
    reg nreset;
    wire in_alu;
    wire in_halt;
    wire repeat_en;
    wire table_cb;
    wire table_ed;
    wire table_xx;
    wire use_ix;
    wire use_ixiy;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    decode_state dut (
        .address_is_1(address_is_1),
        .clk(clk),
        .ctl_repeat_we(ctl_repeat_we),
        .ctl_state_alu(ctl_state_alu),
        .ctl_state_halt_set(ctl_state_halt_set),
        .ctl_state_ixiy_clr(ctl_state_ixiy_clr),
        .ctl_state_ixiy_we(ctl_state_ixiy_we),
        .ctl_state_iy_set(ctl_state_iy_set),
        .ctl_state_tbl_cb_set(ctl_state_tbl_cb_set),
        .ctl_state_tbl_ed_set(ctl_state_tbl_ed_set),
        .ctl_state_tbl_we(ctl_state_tbl_we),
        .in_intr(in_intr),
        .in_nmi(in_nmi),
        .nhold_clk_wait(nhold_clk_wait),
        .nreset(nreset),
        .in_alu(in_alu),
        .in_halt(in_halt),
        .repeat_en(repeat_en),
        .table_cb(table_cb),
        .table_ed(table_ed),
        .table_xx(table_xx),
        .use_ix(use_ix),
        .use_ixiy(use_ixiy)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    task reset_dut;
    //define reset task
    endtask
    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("decode_state Testbench");
        $display("========================================");


        
        
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
        input expected_in_alu;
        input expected_in_halt;
        input expected_repeat_en;
        input expected_table_cb;
        input expected_table_ed;
        input expected_table_xx;
        input expected_use_ix;
        input expected_use_ixiy;
        begin
            if (expected_in_alu === (expected_in_alu ^ in_alu ^ expected_in_alu) &&
                expected_in_halt === (expected_in_halt ^ in_halt ^ expected_in_halt) &&
                expected_repeat_en === (expected_repeat_en ^ repeat_en ^ expected_repeat_en) &&
                expected_table_cb === (expected_table_cb ^ table_cb ^ expected_table_cb) &&
                expected_table_ed === (expected_table_ed ^ table_ed ^ expected_table_ed) &&
                expected_table_xx === (expected_table_xx ^ table_xx ^ expected_table_xx) &&
                expected_use_ix === (expected_use_ix ^ use_ix ^ expected_use_ix) &&
                expected_use_ixiy === (expected_use_ixiy ^ use_ixiy ^ expected_use_ixiy)) begin
                $display("PASS");
                $display("  Outputs: in_alu=%b, in_halt=%b, repeat_en=%b, table_cb=%b, table_ed=%b, table_xx=%b, use_ix=%b, use_ixiy=%b",
                         in_alu, in_halt, repeat_en, table_cb, table_ed, table_xx, use_ix, use_ixiy);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: in_alu=%b, in_halt=%b, repeat_en=%b, table_cb=%b, table_ed=%b, table_xx=%b, use_ix=%b, use_ixiy=%b",
                         expected_in_alu, expected_in_halt, expected_repeat_en, expected_table_cb, expected_table_ed, expected_table_xx, expected_use_ix, expected_use_ixiy);
                $display("  Got:      in_alu=%b, in_halt=%b, repeat_en=%b, table_cb=%b, table_ed=%b, table_xx=%b, use_ix=%b, use_ixiy=%b",
                         in_alu, in_halt, repeat_en, table_cb, table_ed, table_xx, use_ix, use_ixiy);
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
        $dumpvars(0,address_is_1, clk, ctl_repeat_we, ctl_state_alu, ctl_state_halt_set, ctl_state_ixiy_clr, ctl_state_ixiy_we, ctl_state_iy_set, ctl_state_tbl_cb_set, ctl_state_tbl_ed_set, ctl_state_tbl_we, in_intr, in_nmi, nhold_clk_wait, nreset, in_alu, in_halt, repeat_en, table_cb, table_ed, table_xx, use_ix, use_ixiy);
    end

endmodule
