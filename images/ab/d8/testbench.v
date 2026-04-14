`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [23:0] dc;
    reg m_dst_almost_full;
    reg m_dst_full;
    reg m_enable;
    reg [63:0] m_src;
    reg m_src_almost_empty;
    reg m_src_empty;
    reg m_src_last;
    reg wb_clk_i;
    reg wb_rst_i;
    wire [63:0] m_dst;
    wire m_dst_last;
    wire m_dst_putn;
    wire m_endn;
    wire m_src_getn;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .dc(dc),
        .m_dst_almost_full(m_dst_almost_full),
        .m_dst_full(m_dst_full),
        .m_enable(m_enable),
        .m_src(m_src),
        .m_src_almost_empty(m_src_almost_empty),
        .m_src_empty(m_src_empty),
        .m_src_last(m_src_last),
        .wb_clk_i(wb_clk_i),
        .wb_rst_i(wb_rst_i),
        .m_dst(m_dst),
        .m_dst_last(m_dst_last),
        .m_dst_putn(m_dst_putn),
        .m_endn(m_endn),
        .m_src_getn(m_src_getn)
    );

    // Clock generation (10ns period)
    initial begin
        wb_clk_i = 0;
        forever #5 wb_clk_i = ~wb_clk_i;
    end

        task reset_dut;

        begin
            wb_rst_i = 1;
            m_enable = 0;
            dc = 0;
            m_src = 0;
            m_src_last = 0;
            m_src_almost_empty = 0;
            m_src_empty = 0;
            m_dst_almost_full = 0;
            m_dst_full = 0;
            repeat (2) @(posedge wb_clk_i);
            wb_rst_i = 0;
            repeat (1) @(posedge wb_clk_i);
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Basic single word transfer...");
            reset_dut();
            @(posedge wb_clk_i);
            m_enable = 1;
            m_src = 64'hDEADBEEFCAFEFACE;
            m_src_last = 1;


            repeat (2) @(posedge wb_clk_i);



            #1;




            check_outputs(64'hDEADBEEFCAFEFACE, 1'b1, 1'b1, 1'b0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Destination full stall...");
            reset_dut();
            @(posedge wb_clk_i);
            m_enable = 1;
            m_src = 64'h1111222233334444;
            m_dst_full = 1;

            repeat (2) @(posedge wb_clk_i);



            #1;




            check_outputs(64'h0, 1'b0, 1'b1, 1'b1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Multi-word transfer sequence...");
            reset_dut();
            @(posedge wb_clk_i);
            m_enable = 1;
            m_src = 64'hAAAA_BBBB_CCCC_DDDD;
            m_src_last = 0;

            @(posedge wb_clk_i);
            m_src = 64'hEEEE_FFFF_0000_1111;
            m_src_last = 1;

            @(posedge wb_clk_i);

            @(posedge wb_clk_i);


            #1;



            check_outputs(64'hEEEE_FFFF_0000_1111, 1'b1, 1'b1, 1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Source empty stall...");
            reset_dut();
            @(posedge wb_clk_i);
            m_enable = 1;
            m_src_empty = 1;

            repeat (2) @(posedge wb_clk_i);


            #1;



            check_outputs(64'h0, 1'b0, 1'b1, 1'b1, 1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Disable mid-process...");
            reset_dut();
            @(posedge wb_clk_i);
            m_enable = 1;
            m_src = 64'h5555_6666_7777_8888;

            @(posedge wb_clk_i);
            m_enable = 0;

            repeat (2) @(posedge wb_clk_i);


            #1;



            check_outputs(64'h5555_6666_7777_8888, 1'b0, 1'b1, 1'b1, 1'b1);
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
        input [63:0] expected_m_dst;
        input expected_m_dst_last;
        input expected_m_dst_putn;
        input expected_m_endn;
        input expected_m_src_getn;
        begin
            if (expected_m_dst === (expected_m_dst ^ m_dst ^ expected_m_dst) &&
                expected_m_dst_last === (expected_m_dst_last ^ m_dst_last ^ expected_m_dst_last) &&
                expected_m_dst_putn === (expected_m_dst_putn ^ m_dst_putn ^ expected_m_dst_putn) &&
                expected_m_endn === (expected_m_endn ^ m_endn ^ expected_m_endn) &&
                expected_m_src_getn === (expected_m_src_getn ^ m_src_getn ^ expected_m_src_getn)) begin
                $display("PASS");
                $display("  Outputs: m_dst=%h, m_dst_last=%b, m_dst_putn=%b, m_endn=%b, m_src_getn=%b",
                         m_dst, m_dst_last, m_dst_putn, m_endn, m_src_getn);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: m_dst=%h, m_dst_last=%b, m_dst_putn=%b, m_endn=%b, m_src_getn=%b",
                         expected_m_dst, expected_m_dst_last, expected_m_dst_putn, expected_m_endn, expected_m_src_getn);
                $display("  Got:      m_dst=%h, m_dst_last=%b, m_dst_putn=%b, m_endn=%b, m_src_getn=%b",
                         m_dst, m_dst_last, m_dst_putn, m_endn, m_src_getn);
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
        $dumpvars(0,dc, m_dst_almost_full, m_dst_full, m_enable, m_src, m_src_almost_empty, m_src_empty, m_src_last, wb_clk_i, wb_rst_i, m_dst, m_dst_last, m_dst_putn, m_endn, m_src_getn);
    end

endmodule
