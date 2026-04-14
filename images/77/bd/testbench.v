`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] pcx_spc7_grant_bufp3_pa_l;
    reg spc6_pcx_atom_bufpt_pq_l;
    reg [4:0] spc6_pcx_req_bufpt_pq_l;
    reg spc7_pcx_atom_bufpt_pq_l;
    reg [4:0] spc7_pcx_req_bufpt_pq_l;
    wire [4:0] pcx_spc7_grant_bufp4_pa;
    wire spc6_pcx_atom_bufp4_pq;
    wire [4:0] spc6_pcx_req_bufp4_pq;
    wire spc7_pcx_atom_bufp4_pq;
    wire [4:0] spc7_pcx_req_bufp4_pq;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .pcx_spc7_grant_bufp3_pa_l(pcx_spc7_grant_bufp3_pa_l),
        .spc6_pcx_atom_bufpt_pq_l(spc6_pcx_atom_bufpt_pq_l),
        .spc6_pcx_req_bufpt_pq_l(spc6_pcx_req_bufpt_pq_l),
        .spc7_pcx_atom_bufpt_pq_l(spc7_pcx_atom_bufpt_pq_l),
        .spc7_pcx_req_bufpt_pq_l(spc7_pcx_req_bufpt_pq_l),
        .pcx_spc7_grant_bufp4_pa(pcx_spc7_grant_bufp4_pa),
        .spc6_pcx_atom_bufp4_pq(spc6_pcx_atom_bufp4_pq),
        .spc6_pcx_req_bufp4_pq(spc6_pcx_req_bufp4_pq),
        .spc7_pcx_atom_bufp4_pq(spc7_pcx_atom_bufp4_pq),
        .spc7_pcx_req_bufp4_pq(spc7_pcx_req_bufp4_pq)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: All Zeros Input", test_num);
            pcx_spc7_grant_bufp3_pa_l = 5'b00000;
            spc6_pcx_atom_bufpt_pq_l  = 1'b0;
            spc6_pcx_req_bufpt_pq_l   = 5'b00000;
            spc7_pcx_atom_bufpt_pq_l  = 1'b0;
            spc7_pcx_req_bufpt_pq_l   = 5'b00000;

            #1;


            check_outputs(5'b11111, 1'b1, 5'b11111, 1'b1, 5'b11111);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: All Ones Input", test_num);
            pcx_spc7_grant_bufp3_pa_l = 5'b11111;
            spc6_pcx_atom_bufpt_pq_l  = 1'b1;
            spc6_pcx_req_bufpt_pq_l   = 5'b11111;
            spc7_pcx_atom_bufpt_pq_l  = 1'b1;
            spc7_pcx_req_bufpt_pq_l   = 5'b11111;

            #1;


            check_outputs(5'b00000, 1'b0, 5'b00000, 1'b0, 5'b00000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Alternating Pattern A", test_num);
            pcx_spc7_grant_bufp3_pa_l = 5'b10101;
            spc6_pcx_atom_bufpt_pq_l  = 1'b1;
            spc6_pcx_req_bufpt_pq_l   = 5'b01010;
            spc7_pcx_atom_bufpt_pq_l  = 1'b0;
            spc7_pcx_req_bufpt_pq_l   = 5'b11001;

            #1;


            check_outputs(5'b01010, 1'b0, 5'b10101, 1'b1, 5'b00110);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Alternating Pattern B", test_num);
            pcx_spc7_grant_bufp3_pa_l = 5'b01110;
            spc6_pcx_atom_bufpt_pq_l  = 1'b0;
            spc6_pcx_req_bufpt_pq_l   = 5'b10001;
            spc7_pcx_atom_bufpt_pq_l  = 1'b1;
            spc7_pcx_req_bufpt_pq_l   = 5'b00111;

            #1;


            check_outputs(5'b10001, 1'b1, 5'b01110, 1'b0, 5'b11000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Single Bit Set", test_num);
            pcx_spc7_grant_bufp3_pa_l = 5'b00001;
            spc6_pcx_atom_bufpt_pq_l  = 1'b1;
            spc6_pcx_req_bufpt_pq_l   = 5'b10000;
            spc7_pcx_atom_bufpt_pq_l  = 1'b0;
            spc7_pcx_req_bufpt_pq_l   = 5'b00100;

            #1;


            check_outputs(5'b11110, 1'b0, 5'b01111, 1'b1, 5'b11011);
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
        input [4:0] expected_pcx_spc7_grant_bufp4_pa;
        input expected_spc6_pcx_atom_bufp4_pq;
        input [4:0] expected_spc6_pcx_req_bufp4_pq;
        input expected_spc7_pcx_atom_bufp4_pq;
        input [4:0] expected_spc7_pcx_req_bufp4_pq;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_pcx_spc7_grant_bufp4_pa === (expected_pcx_spc7_grant_bufp4_pa ^ pcx_spc7_grant_bufp4_pa ^ expected_pcx_spc7_grant_bufp4_pa) &&
                expected_spc6_pcx_atom_bufp4_pq === (expected_spc6_pcx_atom_bufp4_pq ^ spc6_pcx_atom_bufp4_pq ^ expected_spc6_pcx_atom_bufp4_pq) &&
                expected_spc6_pcx_req_bufp4_pq === (expected_spc6_pcx_req_bufp4_pq ^ spc6_pcx_req_bufp4_pq ^ expected_spc6_pcx_req_bufp4_pq) &&
                expected_spc7_pcx_atom_bufp4_pq === (expected_spc7_pcx_atom_bufp4_pq ^ spc7_pcx_atom_bufp4_pq ^ expected_spc7_pcx_atom_bufp4_pq) &&
                expected_spc7_pcx_req_bufp4_pq === (expected_spc7_pcx_req_bufp4_pq ^ spc7_pcx_req_bufp4_pq ^ expected_spc7_pcx_req_bufp4_pq)) begin
                $display("PASS");
                $display("  Outputs: pcx_spc7_grant_bufp4_pa=%h, spc6_pcx_atom_bufp4_pq=%b, spc6_pcx_req_bufp4_pq=%h, spc7_pcx_atom_bufp4_pq=%b, spc7_pcx_req_bufp4_pq=%h",
                         pcx_spc7_grant_bufp4_pa, spc6_pcx_atom_bufp4_pq, spc6_pcx_req_bufp4_pq, spc7_pcx_atom_bufp4_pq, spc7_pcx_req_bufp4_pq);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: pcx_spc7_grant_bufp4_pa=%h, spc6_pcx_atom_bufp4_pq=%b, spc6_pcx_req_bufp4_pq=%h, spc7_pcx_atom_bufp4_pq=%b, spc7_pcx_req_bufp4_pq=%h",
                         expected_pcx_spc7_grant_bufp4_pa, expected_spc6_pcx_atom_bufp4_pq, expected_spc6_pcx_req_bufp4_pq, expected_spc7_pcx_atom_bufp4_pq, expected_spc7_pcx_req_bufp4_pq);
                $display("  Got:      pcx_spc7_grant_bufp4_pa=%h, spc6_pcx_atom_bufp4_pq=%b, spc6_pcx_req_bufp4_pq=%h, spc7_pcx_atom_bufp4_pq=%b, spc7_pcx_req_bufp4_pq=%h",
                         pcx_spc7_grant_bufp4_pa, spc6_pcx_atom_bufp4_pq, spc6_pcx_req_bufp4_pq, spc7_pcx_atom_bufp4_pq, spc7_pcx_req_bufp4_pq);
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
