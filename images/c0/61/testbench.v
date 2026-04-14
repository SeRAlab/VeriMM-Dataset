`timescale 1ns/1ps

module table_reader_tb;

    // Testbench signals (sequential circuit)
    reg A;
    reg B;
    reg HCN;
    reg O;
    reg clk;
    reg [37:0] d;
    reg [37:0] d_rdata;
    reg [8:0] d_waddr;
    reg d_we;
    reg datavalid;
    reg [8:0] h_rdata;
    reg [8:0] h_wdata;
    reg [8:0] n_rdata;
    reg r1;
    reg r2;
    reg rst;
    reg [8:0] t_rdata;
    reg [8:0] t_wdata;
    wire [8:0] d_raddr;
    wire [37:0] dp;
    wire fn;
    wire fp;
    wire [8:0] h_raddr;
    wire [8:0] hp;
    wire [8:0] n_raddr;
    wire [8:0] np;
    wire [8:0] p;
    wire [8:0] t_raddr;
    wire [8:0] tp;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    table_reader dut (
        .A(A),
        .B(B),
        .HCN(HCN),
        .O(O),
        .clk(clk),
        .d(d),
        .d_rdata(d_rdata),
        .d_waddr(d_waddr),
        .d_we(d_we),
        .datavalid(datavalid),
        .h_rdata(h_rdata),
        .h_wdata(h_wdata),
        .n_rdata(n_rdata),
        .r1(r1),
        .r2(r2),
        .rst(rst),
        .t_rdata(t_rdata),
        .t_wdata(t_wdata),
        .d_raddr(d_raddr),
        .dp(dp),
        .fn(fn),
        .fp(fp),
        .h_raddr(h_raddr),
        .hp(hp),
        .n_raddr(n_raddr),
        .np(np),
        .p(p),
        .t_raddr(t_raddr),
        .tp(tp)
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
        $display("table_reader Testbench");
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
        input [8:0] expected_d_raddr;
        input [37:0] expected_dp;
        input expected_fn;
        input expected_fp;
        input [8:0] expected_h_raddr;
        input [8:0] expected_hp;
        input [8:0] expected_n_raddr;
        input [8:0] expected_np;
        input [8:0] expected_p;
        input [8:0] expected_t_raddr;
        input [8:0] expected_tp;
        begin
            if (expected_d_raddr === (expected_d_raddr ^ d_raddr ^ expected_d_raddr) &&
                expected_dp === (expected_dp ^ dp ^ expected_dp) &&
                expected_fn === (expected_fn ^ fn ^ expected_fn) &&
                expected_fp === (expected_fp ^ fp ^ expected_fp) &&
                expected_h_raddr === (expected_h_raddr ^ h_raddr ^ expected_h_raddr) &&
                expected_hp === (expected_hp ^ hp ^ expected_hp) &&
                expected_n_raddr === (expected_n_raddr ^ n_raddr ^ expected_n_raddr) &&
                expected_np === (expected_np ^ np ^ expected_np) &&
                expected_p === (expected_p ^ p ^ expected_p) &&
                expected_t_raddr === (expected_t_raddr ^ t_raddr ^ expected_t_raddr) &&
                expected_tp === (expected_tp ^ tp ^ expected_tp)) begin
                $display("PASS");
                $display("  Outputs: d_raddr=%h, dp=%h, fn=%b, fp=%b, h_raddr=%h, hp=%h, n_raddr=%h, np=%h, p=%h, t_raddr=%h, tp=%h",
                         d_raddr, dp, fn, fp, h_raddr, hp, n_raddr, np, p, t_raddr, tp);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: d_raddr=%h, dp=%h, fn=%b, fp=%b, h_raddr=%h, hp=%h, n_raddr=%h, np=%h, p=%h, t_raddr=%h, tp=%h",
                         expected_d_raddr, expected_dp, expected_fn, expected_fp, expected_h_raddr, expected_hp, expected_n_raddr, expected_np, expected_p, expected_t_raddr, expected_tp);
                $display("  Got:      d_raddr=%h, dp=%h, fn=%b, fp=%b, h_raddr=%h, hp=%h, n_raddr=%h, np=%h, p=%h, t_raddr=%h, tp=%h",
                         d_raddr, dp, fn, fp, h_raddr, hp, n_raddr, np, p, t_raddr, tp);
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
        $dumpvars(0,A, B, HCN, O, clk, d, d_rdata, d_waddr, d_we, datavalid, h_rdata, h_wdata, n_rdata, r1, r2, rst, t_rdata, t_wdata, d_raddr, dp, fn, fp, h_raddr, hp, n_raddr, np, p, t_raddr, tp);
    end

endmodule
