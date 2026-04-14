`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg jrst_n;
    reg [15:0] trc_ctrl;
    reg [35:0] tw;
    wire tracemem_on;
    wire [35:0] tracemem_trcdata;
    wire tracemem_tw;
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
        .jrst_n(jrst_n),
        .trc_ctrl(trc_ctrl),
        .tw(tw),
        .tracemem_on(tracemem_on),
        .tracemem_trcdata(tracemem_trcdata),
        .tracemem_tw(tracemem_tw),
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
            trc_ctrl = 16'h0000;
            tw = 36'h0;
            repeat(2) @(posedge clk);
            jrst_n = 1;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Reset State Verification", test_num);
            reset_dut();

            #1;


            check_outputs(1'b0, 36'h0, 1'b0, 7'h0, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Single Word Trace Write", test_num);
            reset_dut();


            @(negedge clk);
            trc_ctrl = 16'h0001;
            tw = 36'hA_5555_AAAA;

            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 36'hA_5555_AAAA, 1'b1, 7'h0, 1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Multi-word Trace and Address Increment", test_num);
            reset_dut();

            @(negedge clk);
            trc_ctrl = 16'h0001;
            tw = 36'h11111_1111;

            repeat(10) @(posedge clk);

            @(negedge clk);
            tw = 36'h99999_9999;

            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 36'h99999_9999, 1'b1, 7'h0A, 1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Trace Memory Wrap Around", test_num);
            reset_dut();

            @(negedge clk);
            trc_ctrl = 16'h0001;
            tw = 36'hF_0000_FFFF;


            repeat(128) @(posedge clk);

            @(negedge clk);
            tw = 36'hE_EEEE_EEEE;

            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 36'hE_EEEE_EEEE, 1'b1, 7'h00, 1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Trace Disable on Wrap", test_num);
            reset_dut();


            @(negedge clk);
            trc_ctrl = 16'h0003;
            tw = 36'hD_DDDD_DDDD;


            repeat(128) @(posedge clk);

            @(posedge clk);
            #1;


            #1;



            check_outputs(1'b0, 36'hD_DDDD_DDDD, 1'b0, 7'h00, 1'b1, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Manual Trace Disable", test_num);
            reset_dut();

            @(negedge clk);
            trc_ctrl = 16'h0001;
            tw = 36'hB_BBBB_BBBB;

            repeat(5) @(posedge clk);

            @(negedge clk);
            trc_ctrl = 16'h0000;

            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, 36'hB_BBBB_BBBB, 1'b0, 7'h05, 1'b0, 1'b0);
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
        input [6:0] expected_trc_im_addr;
        input expected_trc_wrap;
        input expected_xbrk_wrap_traceoff;
        begin
            if (expected_tracemem_on === (expected_tracemem_on ^ tracemem_on ^ expected_tracemem_on) &&
                expected_tracemem_trcdata === (expected_tracemem_trcdata ^ tracemem_trcdata ^ expected_tracemem_trcdata) &&
                expected_tracemem_tw === (expected_tracemem_tw ^ tracemem_tw ^ expected_tracemem_tw) &&
                expected_trc_im_addr === (expected_trc_im_addr ^ trc_im_addr ^ expected_trc_im_addr) &&
                expected_trc_wrap === (expected_trc_wrap ^ trc_wrap ^ expected_trc_wrap) &&
                expected_xbrk_wrap_traceoff === (expected_xbrk_wrap_traceoff ^ xbrk_wrap_traceoff ^ expected_xbrk_wrap_traceoff)) begin
                $display("PASS");
                $display("  Outputs: tracemem_on=%b, tracemem_trcdata=%h, tracemem_tw=%b, trc_im_addr=%h, trc_wrap=%b, xbrk_wrap_traceoff=%b",
                         tracemem_on, tracemem_trcdata, tracemem_tw, trc_im_addr, trc_wrap, xbrk_wrap_traceoff);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: tracemem_on=%b, tracemem_trcdata=%h, tracemem_tw=%b, trc_im_addr=%h, trc_wrap=%b, xbrk_wrap_traceoff=%b",
                         expected_tracemem_on, expected_tracemem_trcdata, expected_tracemem_tw, expected_trc_im_addr, expected_trc_wrap, expected_xbrk_wrap_traceoff);
                $display("  Got:      tracemem_on=%b, tracemem_trcdata=%h, tracemem_tw=%b, trc_im_addr=%h, trc_wrap=%b, xbrk_wrap_traceoff=%b",
                         tracemem_on, tracemem_trcdata, tracemem_tw, trc_im_addr, trc_wrap, xbrk_wrap_traceoff);
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
        $dumpvars(0,clk, jrst_n, trc_ctrl, tw, tracemem_on, tracemem_trcdata, tracemem_tw, trc_im_addr, trc_wrap, xbrk_wrap_traceoff);
    end

endmodule
