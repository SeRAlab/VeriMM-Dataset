`timescale 1ns/1ps

module aeMB2_iwbif_tb;

    // Testbench signals (sequential circuit)
    reg [29:0] bpc_ex;
    reg [1:0] bra_ex;
    reg dena;
    reg gclk;
    reg gpha;
    reg grst;
    reg hzd_bpc;
    reg hzd_fwd;
    reg ich_hit;
    reg iena;
    reg iwb_ack_i;
    reg [31:0] iwb_dat_i;
    reg [2:0] msr_ex;
    wire exc_iwb;
    wire fet_fb;
    wire [29:0] ich_adr;
    wire [29:0] iwb_adr_o;
    wire iwb_cyc_o;
    wire [3:0] iwb_sel_o;
    wire iwb_stb_o;
    wire iwb_tag_o;
    wire iwb_wre_o;
    wire [29:0] rpc_ex;
    wire [29:0] rpc_if;
    wire [29:0] rpc_mx;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    aeMB2_iwbif dut (
        .bpc_ex(bpc_ex),
        .bra_ex(bra_ex),
        .dena(dena),
        .gclk(gclk),
        .gpha(gpha),
        .grst(grst),
        .hzd_bpc(hzd_bpc),
        .hzd_fwd(hzd_fwd),
        .ich_hit(ich_hit),
        .iena(iena),
        .iwb_ack_i(iwb_ack_i),
        .iwb_dat_i(iwb_dat_i),
        .msr_ex(msr_ex),
        .exc_iwb(exc_iwb),
        .fet_fb(fet_fb),
        .ich_adr(ich_adr),
        .iwb_adr_o(iwb_adr_o),
        .iwb_cyc_o(iwb_cyc_o),
        .iwb_sel_o(iwb_sel_o),
        .iwb_stb_o(iwb_stb_o),
        .iwb_tag_o(iwb_tag_o),
        .iwb_wre_o(iwb_wre_o),
        .rpc_ex(rpc_ex),
        .rpc_if(rpc_if),
        .rpc_mx(rpc_mx)
    );

    // Clock generation (10ns period)
    initial begin
        gclk = 0;
        forever #5 gclk = ~gclk;
    end

        task reset_dut;

        begin
            bpc_ex = 30'h0;
            bra_ex = 2'b0;
            dena = 1'b0;
            gpha = 1'b0;
            grst = 1'b1;
            hzd_bpc = 1'b0;
            hzd_fwd = 1'b0;
            ich_hit = 1'b0;
            iena = 1'b0;
            iwb_ack_i = 1'b0;
            iwb_dat_i = 32'h0;
            msr_ex = 3'b0;
            @(posedge gclk);
            #1;
            grst = 1'b0;
            @(posedge gclk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Initial State and Reset", test_num);
            reset_dut();


            #1;



            check_outputs(
                1'b0,
                1'b0,
                30'h0,
                30'h0,
                1'b0,
                4'hF,
                1'b0,
                1'b0,
                1'b0,
                30'h0,
                30'h0,
                30'h0
            );
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Sequential Fetching", test_num);
            reset_dut();

            iena = 1'b1;
            dena = 1'b1;
            iwb_ack_i = 1'b1;


            @(posedge gclk); #1;

            @(posedge gclk); #1;

            @(posedge gclk); #1;

            @(posedge gclk); #1;

            #1;


            check_outputs(
                1'b0,
                1'b1,
                30'h4,
                30'h4,
                1'b1,
                4'hF,
                1'b1,
                1'b0,
                1'b0,
                30'h2,
                30'h3,
                30'h1
            );
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Branch Execution", test_num);
            reset_dut();

            iena = 1'b1;
            dena = 1'b1;
            iwb_ack_i = 1'b1;
            bra_ex = 2'b10;
            bpc_ex = 30'h12345678;

            @(posedge gclk); #1;
            bra_ex = 2'b00;


            #1;



            check_outputs(
                1'b0,
                1'b1,
                30'h12345679,
                30'h12345679,
                1'b1,
                4'hF,
                1'b1,
                1'b0,
                1'b0,
                30'h0,
                30'h12345678,
                30'h0
            );
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Pipeline Stall", test_num);
            reset_dut();

            iena = 1'b1;
            dena = 1'b1;
            iwb_ack_i = 1'b1;


            @(posedge gclk); #1;


            dena = 1'b0;
            @(posedge gclk); #1;
            @(posedge gclk); #1;

            #1;


            check_outputs(
                1'b0,
                1'b1,
                30'h3,
                30'h3,
                1'b1,
                4'hF,
                1'b1,
                1'b0,
                1'b0,
                30'h0,
                30'h2,
                30'h0
            );
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Instruction Cache Hit", test_num);
            reset_dut();

            iena = 1'b1;
            dena = 1'b1;
            ich_hit = 1'b1;
            iwb_ack_i = 1'b0;

            @(posedge gclk); #1;

            #1;


            check_outputs(
                1'b0,
                1'b1,
                30'h1,
                30'h1,
                1'b0,
                4'hF,
                1'b0,
                1'b0,
                1'b0,
                30'h0,
                30'h0,
                30'h0
            );
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Tag and Exception bit", test_num);
            reset_dut();

            iena = 1'b1;
            dena = 1'b1;
            iwb_ack_i = 1'b1;
            msr_ex = 3'b100;

            @(posedge gclk); #1;




            #1;





            check_outputs(
                1'b0,
                1'b1,
                30'h1,
                30'h1,
                1'b1,
                4'hF,
                1'b1,
                1'b1,
                1'b0,
                30'h0,
                30'h0,
                30'h0
            );
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("aeMB2_iwbif Testbench");
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
        input expected_exc_iwb;
        input expected_fet_fb;
        input [29:0] expected_ich_adr;
        input [29:0] expected_iwb_adr_o;
        input expected_iwb_cyc_o;
        input [3:0] expected_iwb_sel_o;
        input expected_iwb_stb_o;
        input expected_iwb_tag_o;
        input expected_iwb_wre_o;
        input [29:0] expected_rpc_ex;
        input [29:0] expected_rpc_if;
        input [29:0] expected_rpc_mx;
        begin
            if (expected_exc_iwb === (expected_exc_iwb ^ exc_iwb ^ expected_exc_iwb) &&
                expected_fet_fb === (expected_fet_fb ^ fet_fb ^ expected_fet_fb) &&
                expected_ich_adr === (expected_ich_adr ^ ich_adr ^ expected_ich_adr) &&
                expected_iwb_adr_o === (expected_iwb_adr_o ^ iwb_adr_o ^ expected_iwb_adr_o) &&
                expected_iwb_cyc_o === (expected_iwb_cyc_o ^ iwb_cyc_o ^ expected_iwb_cyc_o) &&
                expected_iwb_sel_o === (expected_iwb_sel_o ^ iwb_sel_o ^ expected_iwb_sel_o) &&
                expected_iwb_stb_o === (expected_iwb_stb_o ^ iwb_stb_o ^ expected_iwb_stb_o) &&
                expected_iwb_tag_o === (expected_iwb_tag_o ^ iwb_tag_o ^ expected_iwb_tag_o) &&
                expected_iwb_wre_o === (expected_iwb_wre_o ^ iwb_wre_o ^ expected_iwb_wre_o) &&
                expected_rpc_ex === (expected_rpc_ex ^ rpc_ex ^ expected_rpc_ex) &&
                expected_rpc_if === (expected_rpc_if ^ rpc_if ^ expected_rpc_if) &&
                expected_rpc_mx === (expected_rpc_mx ^ rpc_mx ^ expected_rpc_mx)) begin
                $display("PASS");
                $display("  Outputs: exc_iwb=%b, fet_fb=%b, ich_adr=%h, iwb_adr_o=%h, iwb_cyc_o=%b, iwb_sel_o=%h, iwb_stb_o=%b, iwb_tag_o=%b, iwb_wre_o=%b, rpc_ex=%h, rpc_if=%h, rpc_mx=%h",
                         exc_iwb, fet_fb, ich_adr, iwb_adr_o, iwb_cyc_o, iwb_sel_o, iwb_stb_o, iwb_tag_o, iwb_wre_o, rpc_ex, rpc_if, rpc_mx);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: exc_iwb=%b, fet_fb=%b, ich_adr=%h, iwb_adr_o=%h, iwb_cyc_o=%b, iwb_sel_o=%h, iwb_stb_o=%b, iwb_tag_o=%b, iwb_wre_o=%b, rpc_ex=%h, rpc_if=%h, rpc_mx=%h",
                         expected_exc_iwb, expected_fet_fb, expected_ich_adr, expected_iwb_adr_o, expected_iwb_cyc_o, expected_iwb_sel_o, expected_iwb_stb_o, expected_iwb_tag_o, expected_iwb_wre_o, expected_rpc_ex, expected_rpc_if, expected_rpc_mx);
                $display("  Got:      exc_iwb=%b, fet_fb=%b, ich_adr=%h, iwb_adr_o=%h, iwb_cyc_o=%b, iwb_sel_o=%h, iwb_stb_o=%b, iwb_tag_o=%b, iwb_wre_o=%b, rpc_ex=%h, rpc_if=%h, rpc_mx=%h",
                         exc_iwb, fet_fb, ich_adr, iwb_adr_o, iwb_cyc_o, iwb_sel_o, iwb_stb_o, iwb_tag_o, iwb_wre_o, rpc_ex, rpc_if, rpc_mx);
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
        $dumpvars(0,bpc_ex, bra_ex, dena, gclk, gpha, grst, hzd_bpc, hzd_fwd, ich_hit, iena, iwb_ack_i, iwb_dat_i, msr_ex, exc_iwb, fet_fb, ich_adr, iwb_adr_o, iwb_cyc_o, iwb_sel_o, iwb_stb_o, iwb_tag_o, iwb_wre_o, rpc_ex, rpc_if, rpc_mx);
    end

endmodule
