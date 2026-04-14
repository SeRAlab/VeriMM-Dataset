`timescale 1ns/1ps

module equivalence_resolver_tb;

    // Testbench signals (sequential circuit)
    reg A;
    reg B;
    reg C;
    reg D;
    reg clk;
    reg datavalid;
    reg [37:0] dd;
    reg [37:0] dp;
    reg fn;
    reg fp;
    reg [8:0] hp;
    reg [8:0] np;
    reg [8:0] p;
    reg rst;
    reg [8:0] tp;
    wire CLR;
    wire DAC;
    wire DMG;
    wire EOC;
    wire HCN;
    wire O;
    wire [8:0] d_waddr;
    wire [37:0] d_wdata;
    wire d_we;
    wire [8:0] h_waddr;
    wire [8:0] h_wdata;
    wire h_we;
    wire [8:0] n_waddr;
    wire [8:0] n_wdata;
    wire n_we;
    wire [8:0] t_waddr;
    wire [8:0] t_wdata;
    wire t_we;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    equivalence_resolver dut (
        .A(A),
        .B(B),
        .C(C),
        .D(D),
        .clk(clk),
        .datavalid(datavalid),
        .dd(dd),
        .dp(dp),
        .fn(fn),
        .fp(fp),
        .hp(hp),
        .np(np),
        .p(p),
        .rst(rst),
        .tp(tp),
        .CLR(CLR),
        .DAC(DAC),
        .DMG(DMG),
        .EOC(EOC),
        .HCN(HCN),
        .O(O),
        .d_waddr(d_waddr),
        .d_wdata(d_wdata),
        .d_we(d_we),
        .h_waddr(h_waddr),
        .h_wdata(h_wdata),
        .h_we(h_we),
        .n_waddr(n_waddr),
        .n_wdata(n_wdata),
        .n_we(n_we),
        .t_waddr(t_waddr),
        .t_wdata(t_wdata),
        .t_we(t_we)
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
        $display("equivalence_resolver Testbench");
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
        input expected_CLR;
        input expected_DAC;
        input expected_DMG;
        input expected_EOC;
        input expected_HCN;
        input expected_O;
        input [8:0] expected_d_waddr;
        input [37:0] expected_d_wdata;
        input expected_d_we;
        input [8:0] expected_h_waddr;
        input [8:0] expected_h_wdata;
        input expected_h_we;
        input [8:0] expected_n_waddr;
        input [8:0] expected_n_wdata;
        input expected_n_we;
        input [8:0] expected_t_waddr;
        input [8:0] expected_t_wdata;
        input expected_t_we;
        begin
            if (expected_CLR === (expected_CLR ^ CLR ^ expected_CLR) &&
                expected_DAC === (expected_DAC ^ DAC ^ expected_DAC) &&
                expected_DMG === (expected_DMG ^ DMG ^ expected_DMG) &&
                expected_EOC === (expected_EOC ^ EOC ^ expected_EOC) &&
                expected_HCN === (expected_HCN ^ HCN ^ expected_HCN) &&
                expected_O === (expected_O ^ O ^ expected_O) &&
                expected_d_waddr === (expected_d_waddr ^ d_waddr ^ expected_d_waddr) &&
                expected_d_wdata === (expected_d_wdata ^ d_wdata ^ expected_d_wdata) &&
                expected_d_we === (expected_d_we ^ d_we ^ expected_d_we) &&
                expected_h_waddr === (expected_h_waddr ^ h_waddr ^ expected_h_waddr) &&
                expected_h_wdata === (expected_h_wdata ^ h_wdata ^ expected_h_wdata) &&
                expected_h_we === (expected_h_we ^ h_we ^ expected_h_we) &&
                expected_n_waddr === (expected_n_waddr ^ n_waddr ^ expected_n_waddr) &&
                expected_n_wdata === (expected_n_wdata ^ n_wdata ^ expected_n_wdata) &&
                expected_n_we === (expected_n_we ^ n_we ^ expected_n_we) &&
                expected_t_waddr === (expected_t_waddr ^ t_waddr ^ expected_t_waddr) &&
                expected_t_wdata === (expected_t_wdata ^ t_wdata ^ expected_t_wdata) &&
                expected_t_we === (expected_t_we ^ t_we ^ expected_t_we)) begin
                $display("PASS");
                $display("  Outputs: CLR=%b, DAC=%b, DMG=%b, EOC=%b, HCN=%b, O=%b, d_waddr=%h, d_wdata=%h, d_we=%b, h_waddr=%h, h_wdata=%h, h_we=%b, n_waddr=%h, n_wdata=%h, n_we=%b, t_waddr=%h, t_wdata=%h, t_we=%b",
                         CLR, DAC, DMG, EOC, HCN, O, d_waddr, d_wdata, d_we, h_waddr, h_wdata, h_we, n_waddr, n_wdata, n_we, t_waddr, t_wdata, t_we);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: CLR=%b, DAC=%b, DMG=%b, EOC=%b, HCN=%b, O=%b, d_waddr=%h, d_wdata=%h, d_we=%b, h_waddr=%h, h_wdata=%h, h_we=%b, n_waddr=%h, n_wdata=%h, n_we=%b, t_waddr=%h, t_wdata=%h, t_we=%b",
                         expected_CLR, expected_DAC, expected_DMG, expected_EOC, expected_HCN, expected_O, expected_d_waddr, expected_d_wdata, expected_d_we, expected_h_waddr, expected_h_wdata, expected_h_we, expected_n_waddr, expected_n_wdata, expected_n_we, expected_t_waddr, expected_t_wdata, expected_t_we);
                $display("  Got:      CLR=%b, DAC=%b, DMG=%b, EOC=%b, HCN=%b, O=%b, d_waddr=%h, d_wdata=%h, d_we=%b, h_waddr=%h, h_wdata=%h, h_we=%b, n_waddr=%h, n_wdata=%h, n_we=%b, t_waddr=%h, t_wdata=%h, t_we=%b",
                         CLR, DAC, DMG, EOC, HCN, O, d_waddr, d_wdata, d_we, h_waddr, h_wdata, h_we, n_waddr, n_wdata, n_we, t_waddr, t_wdata, t_we);
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
        $dumpvars(0,A, B, C, D, clk, datavalid, dd, dp, fn, fp, hp, np, p, rst, tp, CLR, DAC, DMG, EOC, HCN, O, d_waddr, d_wdata, d_we, h_waddr, h_wdata, h_we, n_waddr, n_wdata, n_we, t_waddr, t_wdata, t_we);
    end

endmodule
