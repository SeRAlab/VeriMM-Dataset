`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] pcx_spc_grant_pa;
    reg pcx_stall_pq;
    wire [4:0] pcx_spc_grant_bufpm_pa;
    wire pcx_stall_bufpm_pq;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .pcx_spc_grant_pa(pcx_spc_grant_pa),
        .pcx_stall_pq(pcx_stall_pq),
        .pcx_spc_grant_bufpm_pa(pcx_spc_grant_bufpm_pa),
        .pcx_stall_bufpm_pq(pcx_stall_bufpm_pq)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: All Zeros", test_num);
            pcx_spc_grant_pa = 5'b00000;
            pcx_stall_pq = 1'b0;
            #1;

            check_outputs(5'b00000, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: All Ones", test_num);
            pcx_spc_grant_pa = 5'b11111;
            pcx_stall_pq = 1'b1;
            #1;

            check_outputs(5'b11111, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Alternating Grant Bits 10101", test_num);
            pcx_spc_grant_pa = 5'b10101;
            pcx_stall_pq = 1'b0;
            #1;

            check_outputs(5'b10101, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Alternating Grant Bits 01010", test_num);
            pcx_spc_grant_pa = 5'b01010;
            pcx_stall_pq = 1'b1;
            #1;

            check_outputs(5'b01010, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Single Bit Grant", test_num);
            pcx_spc_grant_pa = 5'b00100;
            pcx_stall_pq = 1'b0;
            #1;

            check_outputs(5'b00100, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Edge Case 10000", test_num);
            pcx_spc_grant_pa = 5'b10000;
            pcx_stall_pq = 1'b1;
            #1;

            check_outputs(5'b10000, 1'b1);
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
        input [4:0] expected_pcx_spc_grant_bufpm_pa;
        input expected_pcx_stall_bufpm_pq;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_pcx_spc_grant_bufpm_pa === (expected_pcx_spc_grant_bufpm_pa ^ pcx_spc_grant_bufpm_pa ^ expected_pcx_spc_grant_bufpm_pa) &&
                expected_pcx_stall_bufpm_pq === (expected_pcx_stall_bufpm_pq ^ pcx_stall_bufpm_pq ^ expected_pcx_stall_bufpm_pq)) begin
                $display("PASS");
                $display("  Outputs: pcx_spc_grant_bufpm_pa=%h, pcx_stall_bufpm_pq=%b",
                         pcx_spc_grant_bufpm_pa, pcx_stall_bufpm_pq);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: pcx_spc_grant_bufpm_pa=%h, pcx_stall_bufpm_pq=%b",
                         expected_pcx_spc_grant_bufpm_pa, expected_pcx_stall_bufpm_pq);
                $display("  Got:      pcx_spc_grant_bufpm_pa=%h, pcx_stall_bufpm_pq=%b",
                         pcx_spc_grant_bufpm_pa, pcx_stall_bufpm_pq);
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
