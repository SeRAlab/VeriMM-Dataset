`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] cpx_scache_grant_ca;
    reg scache_cpx_atom_bufpt_cq_l;
    reg [7:0] scache_cpx_req_bufpt_cq_l;
    wire [7:0] cpx_scache_grant_bufpm_ca;
    wire scache_cpx_atom_bufpm_cq;
    wire [7:0] scache_cpx_req_bufpm_cq;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .cpx_scache_grant_ca(cpx_scache_grant_ca),
        .scache_cpx_atom_bufpt_cq_l(scache_cpx_atom_bufpt_cq_l),
        .scache_cpx_req_bufpt_cq_l(scache_cpx_req_bufpt_cq_l),
        .cpx_scache_grant_bufpm_ca(cpx_scache_grant_bufpm_ca),
        .scache_cpx_atom_bufpm_cq(scache_cpx_atom_bufpm_cq),
        .scache_cpx_req_bufpm_cq(scache_cpx_req_bufpm_cq)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: All Zeros Input", test_num);
            cpx_scache_grant_ca = 8'h00;
            scache_cpx_req_bufpt_cq_l = 8'h00;
            scache_cpx_atom_bufpt_cq_l = 1'b0;


            #1;



            check_outputs(8'h00, 1'b1, 8'hFF);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: All Ones Input", test_num);
            cpx_scache_grant_ca = 8'hFF;
            scache_cpx_req_bufpt_cq_l = 8'hFF;
            scache_cpx_atom_bufpt_cq_l = 1'b1;


            #1;



            check_outputs(8'hFF, 1'b0, 8'h00);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Mixed Pattern A", test_num);
            cpx_scache_grant_ca = 8'hA5;
            scache_cpx_req_bufpt_cq_l = 8'h3C;
            scache_cpx_atom_bufpt_cq_l = 1'b1;


            #1;



            check_outputs(8'hA5, 1'b0, 8'hC3);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Walking Bit Pattern", test_num);
            cpx_scache_grant_ca = 8'h01;
            scache_cpx_req_bufpt_cq_l = 8'hFE;
            scache_cpx_atom_bufpt_cq_l = 1'b0;


            #1;



            check_outputs(8'h01, 1'b1, 8'h01);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Nibble Check", test_num);
            cpx_scache_grant_ca = 8'hF0;
            scache_cpx_req_bufpt_cq_l = 8'h0F;
            scache_cpx_atom_bufpt_cq_l = 1'b1;


            #1;



            check_outputs(8'hF0, 1'b0, 8'hF0);
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
        input [7:0] expected_cpx_scache_grant_bufpm_ca;
        input expected_scache_cpx_atom_bufpm_cq;
        input [7:0] expected_scache_cpx_req_bufpm_cq;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_cpx_scache_grant_bufpm_ca === (expected_cpx_scache_grant_bufpm_ca ^ cpx_scache_grant_bufpm_ca ^ expected_cpx_scache_grant_bufpm_ca) &&
                expected_scache_cpx_atom_bufpm_cq === (expected_scache_cpx_atom_bufpm_cq ^ scache_cpx_atom_bufpm_cq ^ expected_scache_cpx_atom_bufpm_cq) &&
                expected_scache_cpx_req_bufpm_cq === (expected_scache_cpx_req_bufpm_cq ^ scache_cpx_req_bufpm_cq ^ expected_scache_cpx_req_bufpm_cq)) begin
                $display("PASS");
                $display("  Outputs: cpx_scache_grant_bufpm_ca=%h, scache_cpx_atom_bufpm_cq=%b, scache_cpx_req_bufpm_cq=%h",
                         cpx_scache_grant_bufpm_ca, scache_cpx_atom_bufpm_cq, scache_cpx_req_bufpm_cq);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cpx_scache_grant_bufpm_ca=%h, scache_cpx_atom_bufpm_cq=%b, scache_cpx_req_bufpm_cq=%h",
                         expected_cpx_scache_grant_bufpm_ca, expected_scache_cpx_atom_bufpm_cq, expected_scache_cpx_req_bufpm_cq);
                $display("  Got:      cpx_scache_grant_bufpm_ca=%h, scache_cpx_atom_bufpm_cq=%b, scache_cpx_req_bufpm_cq=%h",
                         cpx_scache_grant_bufpm_ca, scache_cpx_atom_bufpm_cq, scache_cpx_req_bufpm_cq);
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
