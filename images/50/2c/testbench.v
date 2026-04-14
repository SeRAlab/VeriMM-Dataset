`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [6:0] jbi_scbuf_ecc;
    reg [31:0] jbi_sctag_req;
    reg jbi_sctag_req_vld;
    reg scbuf_jbi_ctag_vld;
    reg [31:0] scbuf_jbi_data;
    reg scbuf_jbi_ue_err;
    reg sctag_jbi_iq_dequeue;
    reg sctag_jbi_por_req;
    reg sctag_jbi_wib_dequeue;
    wire [6:0] jbi_scbuf_ecc_buf;
    wire [31:0] jbi_sctag_req_buf;
    wire jbi_sctag_req_vld_buf;
    wire scbuf_jbi_ctag_vld_buf;
    wire [31:0] scbuf_jbi_data_buf;
    wire scbuf_jbi_ue_err_buf;
    wire sctag_jbi_iq_dequeue_buf;
    wire sctag_jbi_por_req_buf;
    wire sctag_jbi_wib_dequeue_buf;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .jbi_scbuf_ecc(jbi_scbuf_ecc),
        .jbi_sctag_req(jbi_sctag_req),
        .jbi_sctag_req_vld(jbi_sctag_req_vld),
        .scbuf_jbi_ctag_vld(scbuf_jbi_ctag_vld),
        .scbuf_jbi_data(scbuf_jbi_data),
        .scbuf_jbi_ue_err(scbuf_jbi_ue_err),
        .sctag_jbi_iq_dequeue(sctag_jbi_iq_dequeue),
        .sctag_jbi_por_req(sctag_jbi_por_req),
        .sctag_jbi_wib_dequeue(sctag_jbi_wib_dequeue),
        .jbi_scbuf_ecc_buf(jbi_scbuf_ecc_buf),
        .jbi_sctag_req_buf(jbi_sctag_req_buf),
        .jbi_sctag_req_vld_buf(jbi_sctag_req_vld_buf),
        .scbuf_jbi_ctag_vld_buf(scbuf_jbi_ctag_vld_buf),
        .scbuf_jbi_data_buf(scbuf_jbi_data_buf),
        .scbuf_jbi_ue_err_buf(scbuf_jbi_ue_err_buf),
        .sctag_jbi_iq_dequeue_buf(sctag_jbi_iq_dequeue_buf),
        .sctag_jbi_por_req_buf(sctag_jbi_por_req_buf),
        .sctag_jbi_wib_dequeue_buf(sctag_jbi_wib_dequeue_buf)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: All Zeros Initialization", test_num);

        jbi_scbuf_ecc = 7'h00;
        jbi_sctag_req = 32'h00000000;
        jbi_sctag_req_vld = 1'b0;
        scbuf_jbi_ctag_vld = 1'b0;
        scbuf_jbi_data = 32'h00000000;
        scbuf_jbi_ue_err = 1'b0;
        sctag_jbi_iq_dequeue = 1'b0;
        sctag_jbi_por_req = 1'b0;
        sctag_jbi_wib_dequeue = 1'b0;

        #1;


        check_outputs(7'h00, 32'h00000000, 1'b0, 1'b0, 32'h00000000, 1'b0, 1'b0, 1'b0, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: All Ones Logic Level", test_num);

        jbi_scbuf_ecc = 7'h7F;
        jbi_sctag_req = 32'hFFFFFFFF;
        jbi_sctag_req_vld = 1'b1;
        scbuf_jbi_ctag_vld = 1'b1;
        scbuf_jbi_data = 32'hFFFFFFFF;
        scbuf_jbi_ue_err = 1'b1;
        sctag_jbi_iq_dequeue = 1'b1;
        sctag_jbi_por_req = 1'b1;
        sctag_jbi_wib_dequeue = 1'b1;

        #1;


        check_outputs(7'h7F, 32'hFFFFFFFF, 1'b1, 1'b1, 32'hFFFFFFFF, 1'b1, 1'b1, 1'b1, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Checkerboard Pattern A", test_num);

        jbi_scbuf_ecc = 7'h55;
        jbi_sctag_req = 32'h55555555;
        jbi_sctag_req_vld = 1'b1;
        scbuf_jbi_ctag_vld = 1'b0;
        scbuf_jbi_data = 32'hAAAAAAAA;
        scbuf_jbi_ue_err = 1'b1;
        sctag_jbi_iq_dequeue = 1'b0;
        sctag_jbi_por_req = 1'b1;
        sctag_jbi_wib_dequeue = 1'b0;

        #1;


        check_outputs(7'h55, 32'h55555555, 1'b1, 1'b0, 32'hAAAAAAAA, 1'b1, 1'b0, 1'b1, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Checkerboard Pattern B", test_num);

        jbi_scbuf_ecc = 7'h2A;
        jbi_sctag_req = 32'hAAAAAAAA;
        jbi_sctag_req_vld = 1'b0;
        scbuf_jbi_ctag_vld = 1'b1;
        scbuf_jbi_data = 32'h55555555;
        scbuf_jbi_ue_err = 1'b0;
        sctag_jbi_iq_dequeue = 1'b1;
        sctag_jbi_por_req = 1'b0;
        sctag_jbi_wib_dequeue = 1'b1;

        #1;


        check_outputs(7'h2A, 32'hAAAAAAAA, 1'b0, 1'b1, 32'h55555555, 1'b0, 1'b1, 1'b0, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Specific Data Transaction", test_num);

        jbi_scbuf_ecc = 7'h1C;
        jbi_sctag_req = 32'hDEADBEEF;
        jbi_sctag_req_vld = 1'b1;
        scbuf_jbi_ctag_vld = 1'b1;
        scbuf_jbi_data = 32'hCAFEBABE;
        scbuf_jbi_ue_err = 1'b0;
        sctag_jbi_iq_dequeue = 1'b1;
        sctag_jbi_por_req = 1'b0;
        sctag_jbi_wib_dequeue = 1'b1;

        #1;


        check_outputs(7'h1C, 32'hDEADBEEF, 1'b1, 1'b1, 32'hCAFEBABE, 1'b0, 1'b1, 1'b0, 1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Walking Bits Pattern", test_num);

        jbi_scbuf_ecc = 7'h40;
        jbi_sctag_req = 32'h80000000;
        jbi_sctag_req_vld = 1'b0;
        scbuf_jbi_ctag_vld = 1'b0;
        scbuf_jbi_data = 32'h00000001;
        scbuf_jbi_ue_err = 1'b1;
        sctag_jbi_iq_dequeue = 1'b1;
        sctag_jbi_por_req = 1'b1;
        sctag_jbi_wib_dequeue = 1'b1;

        #1;


        check_outputs(7'h40, 32'h80000000, 1'b0, 1'b0, 32'h00000001, 1'b1, 1'b1, 1'b1, 1'b1);
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
        input [6:0] expected_jbi_scbuf_ecc_buf;
        input [31:0] expected_jbi_sctag_req_buf;
        input expected_jbi_sctag_req_vld_buf;
        input expected_scbuf_jbi_ctag_vld_buf;
        input [31:0] expected_scbuf_jbi_data_buf;
        input expected_scbuf_jbi_ue_err_buf;
        input expected_sctag_jbi_iq_dequeue_buf;
        input expected_sctag_jbi_por_req_buf;
        input expected_sctag_jbi_wib_dequeue_buf;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_jbi_scbuf_ecc_buf === (expected_jbi_scbuf_ecc_buf ^ jbi_scbuf_ecc_buf ^ expected_jbi_scbuf_ecc_buf) &&
                expected_jbi_sctag_req_buf === (expected_jbi_sctag_req_buf ^ jbi_sctag_req_buf ^ expected_jbi_sctag_req_buf) &&
                expected_jbi_sctag_req_vld_buf === (expected_jbi_sctag_req_vld_buf ^ jbi_sctag_req_vld_buf ^ expected_jbi_sctag_req_vld_buf) &&
                expected_scbuf_jbi_ctag_vld_buf === (expected_scbuf_jbi_ctag_vld_buf ^ scbuf_jbi_ctag_vld_buf ^ expected_scbuf_jbi_ctag_vld_buf) &&
                expected_scbuf_jbi_data_buf === (expected_scbuf_jbi_data_buf ^ scbuf_jbi_data_buf ^ expected_scbuf_jbi_data_buf) &&
                expected_scbuf_jbi_ue_err_buf === (expected_scbuf_jbi_ue_err_buf ^ scbuf_jbi_ue_err_buf ^ expected_scbuf_jbi_ue_err_buf) &&
                expected_sctag_jbi_iq_dequeue_buf === (expected_sctag_jbi_iq_dequeue_buf ^ sctag_jbi_iq_dequeue_buf ^ expected_sctag_jbi_iq_dequeue_buf) &&
                expected_sctag_jbi_por_req_buf === (expected_sctag_jbi_por_req_buf ^ sctag_jbi_por_req_buf ^ expected_sctag_jbi_por_req_buf) &&
                expected_sctag_jbi_wib_dequeue_buf === (expected_sctag_jbi_wib_dequeue_buf ^ sctag_jbi_wib_dequeue_buf ^ expected_sctag_jbi_wib_dequeue_buf)) begin
                $display("PASS");
                $display("  Outputs: jbi_scbuf_ecc_buf=%h, jbi_sctag_req_buf=%h, jbi_sctag_req_vld_buf=%b, scbuf_jbi_ctag_vld_buf=%b, scbuf_jbi_data_buf=%h, scbuf_jbi_ue_err_buf=%b, sctag_jbi_iq_dequeue_buf=%b, sctag_jbi_por_req_buf=%b, sctag_jbi_wib_dequeue_buf=%b",
                         jbi_scbuf_ecc_buf, jbi_sctag_req_buf, jbi_sctag_req_vld_buf, scbuf_jbi_ctag_vld_buf, scbuf_jbi_data_buf, scbuf_jbi_ue_err_buf, sctag_jbi_iq_dequeue_buf, sctag_jbi_por_req_buf, sctag_jbi_wib_dequeue_buf);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: jbi_scbuf_ecc_buf=%h, jbi_sctag_req_buf=%h, jbi_sctag_req_vld_buf=%b, scbuf_jbi_ctag_vld_buf=%b, scbuf_jbi_data_buf=%h, scbuf_jbi_ue_err_buf=%b, sctag_jbi_iq_dequeue_buf=%b, sctag_jbi_por_req_buf=%b, sctag_jbi_wib_dequeue_buf=%b",
                         expected_jbi_scbuf_ecc_buf, expected_jbi_sctag_req_buf, expected_jbi_sctag_req_vld_buf, expected_scbuf_jbi_ctag_vld_buf, expected_scbuf_jbi_data_buf, expected_scbuf_jbi_ue_err_buf, expected_sctag_jbi_iq_dequeue_buf, expected_sctag_jbi_por_req_buf, expected_sctag_jbi_wib_dequeue_buf);
                $display("  Got:      jbi_scbuf_ecc_buf=%h, jbi_sctag_req_buf=%h, jbi_sctag_req_vld_buf=%b, scbuf_jbi_ctag_vld_buf=%b, scbuf_jbi_data_buf=%h, scbuf_jbi_ue_err_buf=%b, sctag_jbi_iq_dequeue_buf=%b, sctag_jbi_por_req_buf=%b, sctag_jbi_wib_dequeue_buf=%b",
                         jbi_scbuf_ecc_buf, jbi_sctag_req_buf, jbi_sctag_req_vld_buf, scbuf_jbi_ctag_vld_buf, scbuf_jbi_data_buf, scbuf_jbi_ue_err_buf, sctag_jbi_iq_dequeue_buf, sctag_jbi_por_req_buf, sctag_jbi_wib_dequeue_buf);
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
