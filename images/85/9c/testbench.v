`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [37:0] jdo;
    reg jrst_n;
    reg reset_n;
    reg take_action_tracectrl;
    reg take_action_tracemem_a;
    reg take_action_tracemem_b;
    reg take_no_action_tracemem_a;
    reg [15:0] trc_ctrl;
    reg [35:0] tw;
    wire tracemem_on;
    wire [35:0] tracemem_trcdata;
    wire tracemem_tw;
    wire trc_enb;
    wire [6:0] trc_im_addr;
    wire trc_wrap;
    wire xbrk_wrap_traceoff;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .jdo(jdo),
        .jrst_n(jrst_n),
        .reset_n(reset_n),
        .take_action_tracectrl(take_action_tracectrl),
        .take_action_tracemem_a(take_action_tracemem_a),
        .take_action_tracemem_b(take_action_tracemem_b),
        .take_no_action_tracemem_a(take_no_action_tracemem_a),
        .trc_ctrl(trc_ctrl),
        .tw(tw),
        .tracemem_on(tracemem_on),
        .tracemem_trcdata(tracemem_trcdata),
        .tracemem_tw(tracemem_tw),
        .trc_enb(trc_enb),
        .trc_im_addr(trc_im_addr),
        .trc_wrap(trc_wrap),
        .xbrk_wrap_traceoff(xbrk_wrap_traceoff)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            jrst_n = 0;
            reset_n = 0;
            jdo = 0;
            take_action_tracectrl = 0;
            take_action_tracemem_a = 0;
            take_action_tracemem_b = 0;
            take_no_action_tracemem_a = 0;
            trc_ctrl = 0;
            tw = 0;
            @(posedge clk);
            #1;
            jrst_n = 1;
            reset_n = 1;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Basic Reset");
            reset_dut();

            #1;


            check_outputs(0, 36'h0, 0, 0, 7'h0, 0, 0);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Enable Tracing");
            reset_dut();


            trc_ctrl = 16'h0001;
            jdo = 38'h0000000001;
            take_action_tracectrl = 1;
            @(posedge clk);
            #1;
            take_action_tracectrl = 0;
            @(posedge clk);
            #1;


            #1;



            check_outputs(1, 36'h0, 0, 1, 7'h0, 0, 0);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Data Capture");
            reset_dut();


            jdo = 38'h0000000001;
            take_action_tracectrl = 1;
            @(posedge clk);
            #1;
            take_action_tracectrl = 0;


            tw = 36'hA5A5A5A5A;
            take_action_tracemem_a = 1;
            @(posedge clk);
            #1;
            take_action_tracemem_a = 0;
            @(posedge clk);
            #1;


            #1;



            check_outputs(1, 36'hA5A5A5A5A, 0, 1, 7'h01, 0, 0);
        end
        endtask

    task testcase004;

        integer i;
        begin
            $display("Running testcase004: Wrap Around logic");
            reset_dut();


            jdo = 38'h0000000001;
            take_action_tracectrl = 1;
            @(posedge clk);
            #1;
            take_action_tracectrl = 0;


            for(i=0; i<128; i=i+1) begin
                tw = i;
                take_action_tracemem_a = 1;
                @(posedge clk);
                #1;
                take_action_tracemem_a = 0;
                @(posedge clk);
                #1;
            end


            #1;



            check_outputs(1, 36'h00000007F, 0, 1, 7'h00, 1, 0);
        end
        endtask

    task testcase005;

        integer i;
        begin
            $display("Running testcase005: Trace off on Wrap");
            reset_dut();


            trc_ctrl = 16'h0010;
            jdo = 38'h0000000001;
            take_action_tracectrl = 1;
            @(posedge clk);
            #1;
            take_action_tracectrl = 0;


            for(i=0; i<128; i=i+1) begin
                take_action_tracemem_b = 1;
                @(posedge clk);
                #1;
                take_action_tracemem_b = 0;
                @(posedge clk);
                #1;
            end



            #1;




            check_outputs(0, 36'h0, 0, 0, 7'h00, 1, 1);
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
        input expected_tracemem_on;
        input [35:0] expected_tracemem_trcdata;
        input expected_tracemem_tw;
        input expected_trc_enb;
        input [6:0] expected_trc_im_addr;
        input expected_trc_wrap;
        input expected_xbrk_wrap_traceoff;
        begin
            if (expected_tracemem_on === (expected_tracemem_on ^ tracemem_on ^ expected_tracemem_on) &&
                expected_tracemem_trcdata === (expected_tracemem_trcdata ^ tracemem_trcdata ^ expected_tracemem_trcdata) &&
                expected_tracemem_tw === (expected_tracemem_tw ^ tracemem_tw ^ expected_tracemem_tw) &&
                expected_trc_enb === (expected_trc_enb ^ trc_enb ^ expected_trc_enb) &&
                expected_trc_im_addr === (expected_trc_im_addr ^ trc_im_addr ^ expected_trc_im_addr) &&
                expected_trc_wrap === (expected_trc_wrap ^ trc_wrap ^ expected_trc_wrap) &&
                expected_xbrk_wrap_traceoff === (expected_xbrk_wrap_traceoff ^ xbrk_wrap_traceoff ^ expected_xbrk_wrap_traceoff)) begin
                $display("PASS");
                $display("  Outputs: tracemem_on=%b, tracemem_trcdata=%h, tracemem_tw=%b, trc_enb=%b, trc_im_addr=%h, trc_wrap=%b, xbrk_wrap_traceoff=%b",
                         tracemem_on, tracemem_trcdata, tracemem_tw, trc_enb, trc_im_addr, trc_wrap, xbrk_wrap_traceoff);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: tracemem_on=%b, tracemem_trcdata=%h, tracemem_tw=%b, trc_enb=%b, trc_im_addr=%h, trc_wrap=%b, xbrk_wrap_traceoff=%b",
                         expected_tracemem_on, expected_tracemem_trcdata, expected_tracemem_tw, expected_trc_enb, expected_trc_im_addr, expected_trc_wrap, expected_xbrk_wrap_traceoff);
                $display("  Got:      tracemem_on=%b, tracemem_trcdata=%h, tracemem_tw=%b, trc_enb=%b, trc_im_addr=%h, trc_wrap=%b, xbrk_wrap_traceoff=%b",
                         tracemem_on, tracemem_trcdata, tracemem_tw, trc_enb, trc_im_addr, trc_wrap, xbrk_wrap_traceoff);
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
        $dumpvars(0,clk, jdo, jrst_n, reset_n, take_action_tracectrl, take_action_tracemem_a, take_action_tracemem_b, take_no_action_tracemem_a, trc_ctrl, tw, tracemem_on, tracemem_trcdata, tracemem_tw, trc_enb, trc_im_addr, trc_wrap, xbrk_wrap_traceoff);
    end

endmodule
