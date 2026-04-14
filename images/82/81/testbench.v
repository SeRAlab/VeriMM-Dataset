`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] cpx_scache0_grant_bufp1_ca_l;
    reg cpx_spc0_data_rdy_bufp1_cx;
    reg scache0_cpx_atom_bufpt_cq_l;
    reg [7:0] scache0_cpx_req_bufpt_cq_l;
    wire [7:0] cpx_scache0_grant_bufp0_ca;
    wire cpx_spc0_data_rdy_bufp0_cx;
    wire scache0_cpx_atom_bufp0_cq;
    wire [7:0] scache0_cpx_req_bufp0_cq;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .cpx_scache0_grant_bufp1_ca_l(cpx_scache0_grant_bufp1_ca_l),
        .cpx_spc0_data_rdy_bufp1_cx(cpx_spc0_data_rdy_bufp1_cx),
        .scache0_cpx_atom_bufpt_cq_l(scache0_cpx_atom_bufpt_cq_l),
        .scache0_cpx_req_bufpt_cq_l(scache0_cpx_req_bufpt_cq_l),
        .cpx_scache0_grant_bufp0_ca(cpx_scache0_grant_bufp0_ca),
        .cpx_spc0_data_rdy_bufp0_cx(cpx_spc0_data_rdy_bufp0_cx),
        .scache0_cpx_atom_bufp0_cq(scache0_cpx_atom_bufp0_cq),
        .scache0_cpx_req_bufp0_cq(scache0_cpx_req_bufp0_cq)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case 001: All Zeros Input");
        cpx_scache0_grant_bufp1_ca_l = 8'h00;
        cpx_spc0_data_rdy_bufp1_cx = 1'b0;
        scache0_cpx_atom_bufpt_cq_l = 1'b0;
        scache0_cpx_req_bufpt_cq_l = 8'h00;



        #1;




        check_outputs(8'hFF, 1'b1, 1'b1, 8'hFF);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case 002: All Ones Input");
        cpx_scache0_grant_bufp1_ca_l = 8'hFF;
        cpx_spc0_data_rdy_bufp1_cx = 1'b1;
        scache0_cpx_atom_bufpt_cq_l = 1'b1;
        scache0_cpx_req_bufpt_cq_l = 8'hFF;


        #1;



        check_outputs(8'h00, 1'b0, 1'b0, 8'h00);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case 003: Pattern 0xAA Input");
        cpx_scache0_grant_bufp1_ca_l = 8'hAA;
        cpx_spc0_data_rdy_bufp1_cx = 1'b1;
        scache0_cpx_atom_bufpt_cq_l = 1'b0;
        scache0_cpx_req_bufpt_cq_l = 8'hAA;


        #1;



        check_outputs(8'h55, 1'b0, 1'b1, 8'h55);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case 004: Pattern 0x55 Input");
        cpx_scache0_grant_bufp1_ca_l = 8'h55;
        cpx_spc0_data_rdy_bufp1_cx = 1'b0;
        scache0_cpx_atom_bufpt_cq_l = 1'b1;
        scache0_cpx_req_bufpt_cq_l = 8'h55;


        #1;



        check_outputs(8'hAA, 1'b1, 1'b0, 8'hAA);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case 005: Nibble-wise Mixed Input");
        cpx_scache0_grant_bufp1_ca_l = 8'hF0;
        cpx_spc0_data_rdy_bufp1_cx = 1'b1;
        scache0_cpx_atom_bufpt_cq_l = 1'b1;
        scache0_cpx_req_bufpt_cq_l = 8'h0F;

        #1;


        check_outputs(8'h0F, 1'b0, 1'b0, 8'hF0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case 006: Single Bit Toggle Input");
        cpx_scache0_grant_bufp1_ca_l = 8'h01;
        cpx_spc0_data_rdy_bufp1_cx = 1'b0;
        scache0_cpx_atom_bufpt_cq_l = 1'b0;
        scache0_cpx_req_bufpt_cq_l = 8'h80;

        #1;


        check_outputs(8'hFE, 1'b1, 1'b1, 8'h7F);
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
        input [7:0] expected_cpx_scache0_grant_bufp0_ca;
        input expected_cpx_spc0_data_rdy_bufp0_cx;
        input expected_scache0_cpx_atom_bufp0_cq;
        input [7:0] expected_scache0_cpx_req_bufp0_cq;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_cpx_scache0_grant_bufp0_ca === (expected_cpx_scache0_grant_bufp0_ca ^ cpx_scache0_grant_bufp0_ca ^ expected_cpx_scache0_grant_bufp0_ca) &&
                expected_cpx_spc0_data_rdy_bufp0_cx === (expected_cpx_spc0_data_rdy_bufp0_cx ^ cpx_spc0_data_rdy_bufp0_cx ^ expected_cpx_spc0_data_rdy_bufp0_cx) &&
                expected_scache0_cpx_atom_bufp0_cq === (expected_scache0_cpx_atom_bufp0_cq ^ scache0_cpx_atom_bufp0_cq ^ expected_scache0_cpx_atom_bufp0_cq) &&
                expected_scache0_cpx_req_bufp0_cq === (expected_scache0_cpx_req_bufp0_cq ^ scache0_cpx_req_bufp0_cq ^ expected_scache0_cpx_req_bufp0_cq)) begin
                $display("PASS");
                $display("  Outputs: cpx_scache0_grant_bufp0_ca=%h, cpx_spc0_data_rdy_bufp0_cx=%b, scache0_cpx_atom_bufp0_cq=%b, scache0_cpx_req_bufp0_cq=%h",
                         cpx_scache0_grant_bufp0_ca, cpx_spc0_data_rdy_bufp0_cx, scache0_cpx_atom_bufp0_cq, scache0_cpx_req_bufp0_cq);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cpx_scache0_grant_bufp0_ca=%h, cpx_spc0_data_rdy_bufp0_cx=%b, scache0_cpx_atom_bufp0_cq=%b, scache0_cpx_req_bufp0_cq=%h",
                         expected_cpx_scache0_grant_bufp0_ca, expected_cpx_spc0_data_rdy_bufp0_cx, expected_scache0_cpx_atom_bufp0_cq, expected_scache0_cpx_req_bufp0_cq);
                $display("  Got:      cpx_scache0_grant_bufp0_ca=%h, cpx_spc0_data_rdy_bufp0_cx=%b, scache0_cpx_atom_bufp0_cq=%b, scache0_cpx_req_bufp0_cq=%h",
                         cpx_scache0_grant_bufp0_ca, cpx_spc0_data_rdy_bufp0_cx, scache0_cpx_atom_bufp0_cq, scache0_cpx_req_bufp0_cq);
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
