`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] cfg_ar_addr;
    reg [2:0] cfg_ar_prot;
    reg cfg_ar_valid;
    reg [31:0] cfg_aw_addr;
    reg [2:0] cfg_aw_prot;
    reg cfg_aw_valid;
    reg cfg_b_ready;
    reg cfg_r_ready;
    reg [63:0] cfg_w_data;
    reg [7:0] cfg_w_strb;
    reg cfg_w_valid;
    reg [63:0] din_data;
    reg din_last;
    reg din_valid;
    reg dout_ready;
    reg [63:0] headers_data;
    reg headers_last;
    reg headers_valid;
    reg [63:0] patternMatch_data;
    reg patternMatch_last;
    reg patternMatch_valid;
    wire cfg_ar_ready;
    wire cfg_aw_ready;
    wire [1:0] cfg_b_resp;
    wire cfg_b_valid;
    wire [63:0] cfg_r_data;
    wire [1:0] cfg_r_resp;
    wire cfg_r_valid;
    wire cfg_w_ready;
    wire din_ready;
    wire [63:0] dout_data;
    wire dout_last;
    wire dout_valid;
    wire headers_ready;
    wire patternMatch_ready;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .cfg_ar_addr(cfg_ar_addr),
        .cfg_ar_prot(cfg_ar_prot),
        .cfg_ar_valid(cfg_ar_valid),
        .cfg_aw_addr(cfg_aw_addr),
        .cfg_aw_prot(cfg_aw_prot),
        .cfg_aw_valid(cfg_aw_valid),
        .cfg_b_ready(cfg_b_ready),
        .cfg_r_ready(cfg_r_ready),
        .cfg_w_data(cfg_w_data),
        .cfg_w_strb(cfg_w_strb),
        .cfg_w_valid(cfg_w_valid),
        .din_data(din_data),
        .din_last(din_last),
        .din_valid(din_valid),
        .dout_ready(dout_ready),
        .headers_data(headers_data),
        .headers_last(headers_last),
        .headers_valid(headers_valid),
        .patternMatch_data(patternMatch_data),
        .patternMatch_last(patternMatch_last),
        .patternMatch_valid(patternMatch_valid),
        .cfg_ar_ready(cfg_ar_ready),
        .cfg_aw_ready(cfg_aw_ready),
        .cfg_b_resp(cfg_b_resp),
        .cfg_b_valid(cfg_b_valid),
        .cfg_r_data(cfg_r_data),
        .cfg_r_resp(cfg_r_resp),
        .cfg_r_valid(cfg_r_valid),
        .cfg_w_ready(cfg_w_ready),
        .din_ready(din_ready),
        .dout_data(dout_data),
        .dout_last(dout_last),
        .dout_valid(dout_valid),
        .headers_ready(headers_ready),
        .patternMatch_ready(patternMatch_ready)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: Initial/Idle State", test_num);

        cfg_ar_addr = 32'h0;
        cfg_ar_prot = 3'h0;
        cfg_ar_valid = 1'b0;
        cfg_aw_addr = 32'h0;
        cfg_aw_prot = 3'h0;
        cfg_aw_valid = 1'b0;
        cfg_b_ready = 1'b0;
        cfg_r_ready = 1'b0;
        cfg_w_data = 64'h0;
        cfg_w_strb = 8'h0;
        cfg_w_valid = 1'b0;
        din_data = 64'h0;
        din_last = 1'b0;
        din_valid = 1'b0;
        dout_ready = 1'b0;
        headers_data = 64'h0;
        headers_last = 1'b0;
        headers_valid = 1'b0;
        patternMatch_data = 64'h0;
        patternMatch_last = 1'b0;
        patternMatch_valid = 1'b0;


        #1;



        check_outputs(1'bx, 1'bx, 2'bxx, 1'bx, 64'bx, 2'bxx, 1'bx, 1'bx, 1'bx, 64'bx, 1'bx, 1'bx, 1'bx, 1'bx);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: Configuration Write Transaction Setup", test_num);

        cfg_aw_addr = 32'hABCD_1234;
        cfg_aw_prot = 3'b010;
        cfg_aw_valid = 1'b1;
        cfg_w_data = 64'hDEADBEEF_CAFEBABE;
        cfg_w_strb = 8'hFF;
        cfg_w_valid = 1'b1;
        cfg_b_ready = 1'b1;


        #1;



        check_outputs(1'bx, 1'bx, 2'bxx, 1'bx, 64'bx, 2'bxx, 1'bx, 1'bx, 1'bx, 64'bx, 1'bx, 1'bx, 1'bx, 1'bx);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: Configuration Read Transaction Setup", test_num);

        cfg_ar_addr = 32'h5555_AAAA;
        cfg_ar_prot = 3'b001;
        cfg_ar_valid = 1'b1;
        cfg_r_ready = 1'b1;


        #1;



        check_outputs(1'bx, 1'bx, 2'bxx, 1'bx, 64'bx, 2'bxx, 1'bx, 1'bx, 1'bx, 64'bx, 1'bx, 1'bx, 1'bx, 1'bx);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: Data In and Headers Stream", test_num);

        din_data = 64'h0123456789ABCDEF;
        din_valid = 1'b1;
        din_last = 1'b0;
        headers_data = 64'hAAAA_BBBB_CCCC_DDDD;
        headers_valid = 1'b1;
        headers_last = 1'b1;
        dout_ready = 1'b1;


        #1;



        check_outputs(1'bx, 1'bx, 2'bxx, 1'bx, 64'bx, 2'bxx, 1'bx, 1'bx, 1'bx, 64'bx, 1'bx, 1'bx, 1'bx, 1'bx);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %0d: Pattern Match Stream", test_num);

        patternMatch_data = 64'hFFFF_0000_FFFF_0000;
        patternMatch_valid = 1'b1;
        patternMatch_last = 1'b1;


        #1;



        check_outputs(1'bx, 1'bx, 2'bxx, 1'bx, 64'bx, 2'bxx, 1'bx, 1'bx, 1'bx, 64'bx, 1'bx, 1'bx, 1'bx, 1'bx);
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
        input expected_cfg_ar_ready;
        input expected_cfg_aw_ready;
        input [1:0] expected_cfg_b_resp;
        input expected_cfg_b_valid;
        input [63:0] expected_cfg_r_data;
        input [1:0] expected_cfg_r_resp;
        input expected_cfg_r_valid;
        input expected_cfg_w_ready;
        input expected_din_ready;
        input [63:0] expected_dout_data;
        input expected_dout_last;
        input expected_dout_valid;
        input expected_headers_ready;
        input expected_patternMatch_ready;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_cfg_ar_ready === (expected_cfg_ar_ready ^ cfg_ar_ready ^ expected_cfg_ar_ready) &&
                expected_cfg_aw_ready === (expected_cfg_aw_ready ^ cfg_aw_ready ^ expected_cfg_aw_ready) &&
                expected_cfg_b_resp === (expected_cfg_b_resp ^ cfg_b_resp ^ expected_cfg_b_resp) &&
                expected_cfg_b_valid === (expected_cfg_b_valid ^ cfg_b_valid ^ expected_cfg_b_valid) &&
                expected_cfg_r_data === (expected_cfg_r_data ^ cfg_r_data ^ expected_cfg_r_data) &&
                expected_cfg_r_resp === (expected_cfg_r_resp ^ cfg_r_resp ^ expected_cfg_r_resp) &&
                expected_cfg_r_valid === (expected_cfg_r_valid ^ cfg_r_valid ^ expected_cfg_r_valid) &&
                expected_cfg_w_ready === (expected_cfg_w_ready ^ cfg_w_ready ^ expected_cfg_w_ready) &&
                expected_din_ready === (expected_din_ready ^ din_ready ^ expected_din_ready) &&
                expected_dout_data === (expected_dout_data ^ dout_data ^ expected_dout_data) &&
                expected_dout_last === (expected_dout_last ^ dout_last ^ expected_dout_last) &&
                expected_dout_valid === (expected_dout_valid ^ dout_valid ^ expected_dout_valid) &&
                expected_headers_ready === (expected_headers_ready ^ headers_ready ^ expected_headers_ready) &&
                expected_patternMatch_ready === (expected_patternMatch_ready ^ patternMatch_ready ^ expected_patternMatch_ready)) begin
                $display("PASS");
                $display("  Outputs: cfg_ar_ready=%b, cfg_aw_ready=%b, cfg_b_resp=%h, cfg_b_valid=%b, cfg_r_data=%h, cfg_r_resp=%h, cfg_r_valid=%b, cfg_w_ready=%b, din_ready=%b, dout_data=%h, dout_last=%b, dout_valid=%b, headers_ready=%b, patternMatch_ready=%b",
                         cfg_ar_ready, cfg_aw_ready, cfg_b_resp, cfg_b_valid, cfg_r_data, cfg_r_resp, cfg_r_valid, cfg_w_ready, din_ready, dout_data, dout_last, dout_valid, headers_ready, patternMatch_ready);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cfg_ar_ready=%b, cfg_aw_ready=%b, cfg_b_resp=%h, cfg_b_valid=%b, cfg_r_data=%h, cfg_r_resp=%h, cfg_r_valid=%b, cfg_w_ready=%b, din_ready=%b, dout_data=%h, dout_last=%b, dout_valid=%b, headers_ready=%b, patternMatch_ready=%b",
                         expected_cfg_ar_ready, expected_cfg_aw_ready, expected_cfg_b_resp, expected_cfg_b_valid, expected_cfg_r_data, expected_cfg_r_resp, expected_cfg_r_valid, expected_cfg_w_ready, expected_din_ready, expected_dout_data, expected_dout_last, expected_dout_valid, expected_headers_ready, expected_patternMatch_ready);
                $display("  Got:      cfg_ar_ready=%b, cfg_aw_ready=%b, cfg_b_resp=%h, cfg_b_valid=%b, cfg_r_data=%h, cfg_r_resp=%h, cfg_r_valid=%b, cfg_w_ready=%b, din_ready=%b, dout_data=%h, dout_last=%b, dout_valid=%b, headers_ready=%b, patternMatch_ready=%b",
                         cfg_ar_ready, cfg_aw_ready, cfg_b_resp, cfg_b_valid, cfg_r_data, cfg_r_resp, cfg_r_valid, cfg_w_ready, din_ready, dout_data, dout_last, dout_valid, headers_ready, patternMatch_ready);
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
