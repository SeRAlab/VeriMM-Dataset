`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] pcx_spc0_grant_bufp1_pa_l;
    reg spc0_pcx_atom_bufpt_pq_l;
    reg [4:0] spc0_pcx_req_bufpt_pq_l;
    reg spc1_pcx_atom_bufpt_pq_l;
    reg [4:0] spc1_pcx_req_bufpt_pq_l;
    wire [4:0] pcx_spc0_grant_bufp0_pa;
    wire spc0_pcx_atom_bufp0_pq;
    wire [4:0] spc0_pcx_req_bufp0_pq;
    wire spc1_pcx_atom_bufp0_pq;
    wire [4:0] spc1_pcx_req_bufp0_pq;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .pcx_spc0_grant_bufp1_pa_l(pcx_spc0_grant_bufp1_pa_l),
        .spc0_pcx_atom_bufpt_pq_l(spc0_pcx_atom_bufpt_pq_l),
        .spc0_pcx_req_bufpt_pq_l(spc0_pcx_req_bufpt_pq_l),
        .spc1_pcx_atom_bufpt_pq_l(spc1_pcx_atom_bufpt_pq_l),
        .spc1_pcx_req_bufpt_pq_l(spc1_pcx_req_bufpt_pq_l),
        .pcx_spc0_grant_bufp0_pa(pcx_spc0_grant_bufp0_pa),
        .spc0_pcx_atom_bufp0_pq(spc0_pcx_atom_bufp0_pq),
        .spc0_pcx_req_bufp0_pq(spc0_pcx_req_bufp0_pq),
        .spc1_pcx_atom_bufp0_pq(spc1_pcx_atom_bufp0_pq),
        .spc1_pcx_req_bufp0_pq(spc1_pcx_req_bufp0_pq)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All inputs logical zero", test_num);

            pcx_spc0_grant_bufp1_pa_l = 5'b00000;
            spc0_pcx_atom_bufpt_pq_l  = 1'b0;
            spc0_pcx_req_bufpt_pq_l   = 5'b00000;
            spc1_pcx_atom_bufpt_pq_l  = 1'b0;
            spc1_pcx_req_bufpt_pq_l   = 5'b00000;


            #1;



            check_outputs(5'h1F, 1'b1, 5'h1F, 1'b1, 5'h1F);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All inputs logical one", test_num);

            pcx_spc0_grant_bufp1_pa_l = 5'h1F;
            spc0_pcx_atom_bufpt_pq_l  = 1'b1;
            spc0_pcx_req_bufpt_pq_l   = 5'h1F;
            spc1_pcx_atom_bufpt_pq_l  = 1'b1;
            spc1_pcx_req_bufpt_pq_l   = 5'h1F;


            #1;



            check_outputs(5'h00, 1'b0, 5'h00, 1'b0, 5'h00);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Mixed pattern 1 (Checkerboard)", test_num);

            pcx_spc0_grant_bufp1_pa_l = 5'b01010;
            spc0_pcx_atom_bufpt_pq_l  = 1'b1;
            spc0_pcx_req_bufpt_pq_l   = 5'b10101;
            spc1_pcx_atom_bufpt_pq_l  = 1'b0;
            spc1_pcx_req_bufpt_pq_l   = 5'b01010;


            #1;



            check_outputs(5'h15, 1'b0, 5'h0A, 1'b1, 5'h15);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Walking bit pattern", test_num);

            pcx_spc0_grant_bufp1_pa_l = 5'b00001;
            spc0_pcx_atom_bufpt_pq_l  = 1'b1;
            spc0_pcx_req_bufpt_pq_l   = 5'b00010;
            spc1_pcx_atom_bufpt_pq_l  = 1'b1;
            spc1_pcx_req_bufpt_pq_l   = 5'b00100;

            #1;


            check_outputs(5'b11110, 1'b0, 5'b11101, 1'b0, 5'b11011);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: SPC0 Active, SPC1 Idle", test_num);

            pcx_spc0_grant_bufp1_pa_l = 5'h00;
            spc0_pcx_atom_bufpt_pq_l  = 1'b0;
            spc0_pcx_req_bufpt_pq_l   = 5'h00;
            spc1_pcx_atom_bufpt_pq_l  = 1'b1;
            spc1_pcx_req_bufpt_pq_l   = 5'h1F;

            #1;


            check_outputs(5'h1F, 1'b1, 5'h1F, 1'b0, 5'h00);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Random bit combinations", test_num);
            pcx_spc0_grant_bufp1_pa_l = 5'h12;
            spc0_pcx_atom_bufpt_pq_l  = 1'b1;
            spc0_pcx_req_bufpt_pq_l   = 5'h07;
            spc1_pcx_atom_bufpt_pq_l  = 1'b0;
            spc1_pcx_req_bufpt_pq_l   = 5'h18;

            #1;


            check_outputs(5'h0D, 1'b0, 5'h18, 1'b1, 5'h07);
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
        input [4:0] expected_pcx_spc0_grant_bufp0_pa;
        input expected_spc0_pcx_atom_bufp0_pq;
        input [4:0] expected_spc0_pcx_req_bufp0_pq;
        input expected_spc1_pcx_atom_bufp0_pq;
        input [4:0] expected_spc1_pcx_req_bufp0_pq;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_pcx_spc0_grant_bufp0_pa === (expected_pcx_spc0_grant_bufp0_pa ^ pcx_spc0_grant_bufp0_pa ^ expected_pcx_spc0_grant_bufp0_pa) &&
                expected_spc0_pcx_atom_bufp0_pq === (expected_spc0_pcx_atom_bufp0_pq ^ spc0_pcx_atom_bufp0_pq ^ expected_spc0_pcx_atom_bufp0_pq) &&
                expected_spc0_pcx_req_bufp0_pq === (expected_spc0_pcx_req_bufp0_pq ^ spc0_pcx_req_bufp0_pq ^ expected_spc0_pcx_req_bufp0_pq) &&
                expected_spc1_pcx_atom_bufp0_pq === (expected_spc1_pcx_atom_bufp0_pq ^ spc1_pcx_atom_bufp0_pq ^ expected_spc1_pcx_atom_bufp0_pq) &&
                expected_spc1_pcx_req_bufp0_pq === (expected_spc1_pcx_req_bufp0_pq ^ spc1_pcx_req_bufp0_pq ^ expected_spc1_pcx_req_bufp0_pq)) begin
                $display("PASS");
                $display("  Outputs: pcx_spc0_grant_bufp0_pa=%h, spc0_pcx_atom_bufp0_pq=%b, spc0_pcx_req_bufp0_pq=%h, spc1_pcx_atom_bufp0_pq=%b, spc1_pcx_req_bufp0_pq=%h",
                         pcx_spc0_grant_bufp0_pa, spc0_pcx_atom_bufp0_pq, spc0_pcx_req_bufp0_pq, spc1_pcx_atom_bufp0_pq, spc1_pcx_req_bufp0_pq);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: pcx_spc0_grant_bufp0_pa=%h, spc0_pcx_atom_bufp0_pq=%b, spc0_pcx_req_bufp0_pq=%h, spc1_pcx_atom_bufp0_pq=%b, spc1_pcx_req_bufp0_pq=%h",
                         expected_pcx_spc0_grant_bufp0_pa, expected_spc0_pcx_atom_bufp0_pq, expected_spc0_pcx_req_bufp0_pq, expected_spc1_pcx_atom_bufp0_pq, expected_spc1_pcx_req_bufp0_pq);
                $display("  Got:      pcx_spc0_grant_bufp0_pa=%h, spc0_pcx_atom_bufp0_pq=%b, spc0_pcx_req_bufp0_pq=%h, spc1_pcx_atom_bufp0_pq=%b, spc1_pcx_req_bufp0_pq=%h",
                         pcx_spc0_grant_bufp0_pa, spc0_pcx_atom_bufp0_pq, spc0_pcx_req_bufp0_pq, spc1_pcx_atom_bufp0_pq, spc1_pcx_req_bufp0_pq);
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
