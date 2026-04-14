`timescale 1ns/1ps

module hpdmc_ctlif_tb;

    // Testbench signals (sequential circuit)
    reg [13:0] csr_a;
    reg [31:0] csr_di;
    reg csr_we;
    reg dqs_psdone;
    reg [1:0] pll_stat;
    reg sys_clk;
    reg sys_rst;
    wire bypass;
    wire [31:0] csr_do;
    wire dqs_psen;
    wire dqs_psincdec;
    wire idelay_ce;
    wire idelay_inc;
    wire idelay_rst;
    wire [12:0] sdram_adr;
    wire [1:0] sdram_ba;
    wire sdram_cas_n;
    wire sdram_cke;
    wire sdram_cs_n;
    wire sdram_ras_n;
    wire sdram_rst;
    wire sdram_we_n;
    wire tim_cas;
    wire [2:0] tim_rcd;
    wire [10:0] tim_refi;
    wire [3:0] tim_rfc;
    wire [2:0] tim_rp;
    wire [1:0] tim_wr;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    hpdmc_ctlif dut (
        .csr_a(csr_a),
        .csr_di(csr_di),
        .csr_we(csr_we),
        .dqs_psdone(dqs_psdone),
        .pll_stat(pll_stat),
        .sys_clk(sys_clk),
        .sys_rst(sys_rst),
        .bypass(bypass),
        .csr_do(csr_do),
        .dqs_psen(dqs_psen),
        .dqs_psincdec(dqs_psincdec),
        .idelay_ce(idelay_ce),
        .idelay_inc(idelay_inc),
        .idelay_rst(idelay_rst),
        .sdram_adr(sdram_adr),
        .sdram_ba(sdram_ba),
        .sdram_cas_n(sdram_cas_n),
        .sdram_cke(sdram_cke),
        .sdram_cs_n(sdram_cs_n),
        .sdram_ras_n(sdram_ras_n),
        .sdram_rst(sdram_rst),
        .sdram_we_n(sdram_we_n),
        .tim_cas(tim_cas),
        .tim_rcd(tim_rcd),
        .tim_refi(tim_refi),
        .tim_rfc(tim_rfc),
        .tim_rp(tim_rp),
        .tim_wr(tim_wr)
    );

    // Clock generation (10ns period)
    initial begin
        sys_clk = 0;
        forever #5 sys_clk = ~sys_clk;
    end

        task reset_dut;

        begin
            sys_rst = 1;
            csr_a = 0;
            csr_di = 0;
            csr_we = 0;
            dqs_psdone = 0;
            pll_stat = 2'b00;
            repeat (5) @(posedge sys_clk);
            sys_rst = 0;
            repeat (2) @(posedge sys_clk);
        end
        endtask
    task csr_write;

        input [13:0] addr;
        input [31:0] data;
        begin
            @(posedge sys_clk);
            csr_a <= addr;
            csr_di <= data;
            csr_we <= 1;
            @(posedge sys_clk);
            csr_we <= 0;
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %03d: Reset State Verification", test_num);
            reset_dut();

            #1;


            check_outputs(0, 32'h0, 0, 0, 0, 0, 0, 13'h0, 2'h0, 1, 0, 1, 1, 0, 1, 0, 3'h0, 11'h0, 4'h0, 3'h0, 2'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %03d: DRAM Mode/Control CSR Write", test_num);
            reset_dut();


            csr_write(14'h0000, 32'h0000_005D);
            repeat (2) @(posedge sys_clk);
            #1;

            check_outputs(1, 32'h5D, 0, 0, 0, 0, 0, 13'h0, 2'h0, 0, 1, 1, 1, 0, 1, 0, 3'h0, 11'h0, 4'h0, 3'h0, 2'h0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %03d: Timing Parameters Verification", test_num);
            reset_dut();

            csr_write(14'h0002, 32'h0000_004B);
            repeat (2) @(posedge sys_clk);
            #1;

            check_outputs(0, 32'h4B, 0, 0, 0, 0, 0, 13'h0, 2'h0, 1, 0, 1, 1, 0, 1, 1, 3'h1, 11'h0, 4'h0, 3'h3, 2'h0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %03d: SDRAM Address and Bank CSR", test_num);
            reset_dut();

            csr_write(14'h0001, 32'h0000_5ABC);
            repeat (2) @(posedge sys_clk);
            #1;

            check_outputs(0, 32'h5ABC, 0, 0, 0, 0, 0, 13'h1ABC, 2'h2, 1, 0, 1, 1, 0, 1, 0, 3'h0, 11'h0, 4'h0, 3'h0, 2'h0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %03d: DQS Phase Shift Initiation", test_num);
            reset_dut();

            csr_write(14'h0005, 32'h0000_0003);
            repeat (2) @(posedge sys_clk);

            #1;


            check_outputs(0, 32'h3, 1, 1, 0, 0, 0, 13'h0, 2'h0, 1, 0, 1, 1, 0, 1, 0, 3'h0, 11'h0, 4'h0, 3'h0, 2'h0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTestcase %03d: Status Register Read", test_num);
            reset_dut();
            pll_stat = 2'b11;

            csr_a = 14'h0006;
            csr_we = 0;
            repeat (2) @(posedge sys_clk);

            #1;


            check_outputs(0, 32'h3, 0, 0, 0, 0, 0, 13'h0, 2'h0, 1, 0, 1, 1, 0, 1, 0, 3'h0, 11'h0, 4'h0, 3'h0, 2'h0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("hpdmc_ctlif Testbench");
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
        input expected_bypass;
        input [31:0] expected_csr_do;
        input expected_dqs_psen;
        input expected_dqs_psincdec;
        input expected_idelay_ce;
        input expected_idelay_inc;
        input expected_idelay_rst;
        input [12:0] expected_sdram_adr;
        input [1:0] expected_sdram_ba;
        input expected_sdram_cas_n;
        input expected_sdram_cke;
        input expected_sdram_cs_n;
        input expected_sdram_ras_n;
        input expected_sdram_rst;
        input expected_sdram_we_n;
        input expected_tim_cas;
        input [2:0] expected_tim_rcd;
        input [10:0] expected_tim_refi;
        input [3:0] expected_tim_rfc;
        input [2:0] expected_tim_rp;
        input [1:0] expected_tim_wr;
        begin
            if (expected_bypass === (expected_bypass ^ bypass ^ expected_bypass) &&
                expected_csr_do === (expected_csr_do ^ csr_do ^ expected_csr_do) &&
                expected_dqs_psen === (expected_dqs_psen ^ dqs_psen ^ expected_dqs_psen) &&
                expected_dqs_psincdec === (expected_dqs_psincdec ^ dqs_psincdec ^ expected_dqs_psincdec) &&
                expected_idelay_ce === (expected_idelay_ce ^ idelay_ce ^ expected_idelay_ce) &&
                expected_idelay_inc === (expected_idelay_inc ^ idelay_inc ^ expected_idelay_inc) &&
                expected_idelay_rst === (expected_idelay_rst ^ idelay_rst ^ expected_idelay_rst) &&
                expected_sdram_adr === (expected_sdram_adr ^ sdram_adr ^ expected_sdram_adr) &&
                expected_sdram_ba === (expected_sdram_ba ^ sdram_ba ^ expected_sdram_ba) &&
                expected_sdram_cas_n === (expected_sdram_cas_n ^ sdram_cas_n ^ expected_sdram_cas_n) &&
                expected_sdram_cke === (expected_sdram_cke ^ sdram_cke ^ expected_sdram_cke) &&
                expected_sdram_cs_n === (expected_sdram_cs_n ^ sdram_cs_n ^ expected_sdram_cs_n) &&
                expected_sdram_ras_n === (expected_sdram_ras_n ^ sdram_ras_n ^ expected_sdram_ras_n) &&
                expected_sdram_rst === (expected_sdram_rst ^ sdram_rst ^ expected_sdram_rst) &&
                expected_sdram_we_n === (expected_sdram_we_n ^ sdram_we_n ^ expected_sdram_we_n) &&
                expected_tim_cas === (expected_tim_cas ^ tim_cas ^ expected_tim_cas) &&
                expected_tim_rcd === (expected_tim_rcd ^ tim_rcd ^ expected_tim_rcd) &&
                expected_tim_refi === (expected_tim_refi ^ tim_refi ^ expected_tim_refi) &&
                expected_tim_rfc === (expected_tim_rfc ^ tim_rfc ^ expected_tim_rfc) &&
                expected_tim_rp === (expected_tim_rp ^ tim_rp ^ expected_tim_rp) &&
                expected_tim_wr === (expected_tim_wr ^ tim_wr ^ expected_tim_wr)) begin
                $display("PASS");
                $display("  Outputs: bypass=%b, csr_do=%h, dqs_psen=%b, dqs_psincdec=%b, idelay_ce=%b, idelay_inc=%b, idelay_rst=%b, sdram_adr=%h, sdram_ba=%h, sdram_cas_n=%b, sdram_cke=%b, sdram_cs_n=%b, sdram_ras_n=%b, sdram_rst=%b, sdram_we_n=%b, tim_cas=%b, tim_rcd=%h, tim_refi=%h, tim_rfc=%h, tim_rp=%h, tim_wr=%h",
                         bypass, csr_do, dqs_psen, dqs_psincdec, idelay_ce, idelay_inc, idelay_rst, sdram_adr, sdram_ba, sdram_cas_n, sdram_cke, sdram_cs_n, sdram_ras_n, sdram_rst, sdram_we_n, tim_cas, tim_rcd, tim_refi, tim_rfc, tim_rp, tim_wr);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: bypass=%b, csr_do=%h, dqs_psen=%b, dqs_psincdec=%b, idelay_ce=%b, idelay_inc=%b, idelay_rst=%b, sdram_adr=%h, sdram_ba=%h, sdram_cas_n=%b, sdram_cke=%b, sdram_cs_n=%b, sdram_ras_n=%b, sdram_rst=%b, sdram_we_n=%b, tim_cas=%b, tim_rcd=%h, tim_refi=%h, tim_rfc=%h, tim_rp=%h, tim_wr=%h",
                         expected_bypass, expected_csr_do, expected_dqs_psen, expected_dqs_psincdec, expected_idelay_ce, expected_idelay_inc, expected_idelay_rst, expected_sdram_adr, expected_sdram_ba, expected_sdram_cas_n, expected_sdram_cke, expected_sdram_cs_n, expected_sdram_ras_n, expected_sdram_rst, expected_sdram_we_n, expected_tim_cas, expected_tim_rcd, expected_tim_refi, expected_tim_rfc, expected_tim_rp, expected_tim_wr);
                $display("  Got:      bypass=%b, csr_do=%h, dqs_psen=%b, dqs_psincdec=%b, idelay_ce=%b, idelay_inc=%b, idelay_rst=%b, sdram_adr=%h, sdram_ba=%h, sdram_cas_n=%b, sdram_cke=%b, sdram_cs_n=%b, sdram_ras_n=%b, sdram_rst=%b, sdram_we_n=%b, tim_cas=%b, tim_rcd=%h, tim_refi=%h, tim_rfc=%h, tim_rp=%h, tim_wr=%h",
                         bypass, csr_do, dqs_psen, dqs_psincdec, idelay_ce, idelay_inc, idelay_rst, sdram_adr, sdram_ba, sdram_cas_n, sdram_cke, sdram_cs_n, sdram_ras_n, sdram_rst, sdram_we_n, tim_cas, tim_rcd, tim_refi, tim_rfc, tim_rp, tim_wr);
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
        $dumpvars(0,csr_a, csr_di, csr_we, dqs_psdone, pll_stat, sys_clk, sys_rst, bypass, csr_do, dqs_psen, dqs_psincdec, idelay_ce, idelay_inc, idelay_rst, sdram_adr, sdram_ba, sdram_cas_n, sdram_cke, sdram_cs_n, sdram_ras_n, sdram_rst, sdram_we_n, tim_cas, tim_rcd, tim_refi, tim_rfc, tim_rp, tim_wr);
    end

endmodule
