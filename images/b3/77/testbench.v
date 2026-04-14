`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [77:0] arbdp_store_data_c2;
    wire [77:0] rep_store_data_c2;
    wire [77:0] sctag_scdata_stdecc_c2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .arbdp_store_data_c2(arbdp_store_data_c2),
        .rep_store_data_c2(rep_store_data_c2),
        .sctag_scdata_stdecc_c2(sctag_scdata_stdecc_c2)
    );
    task testcase001;

        begin
            $display("\nRunning testcase001: All Zeros Pattern");
            arbdp_store_data_c2 = 78'h00000000000000000000;
            #1;

            check_outputs(78'h00000000000000000000, 78'h00000000000000000000);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning testcase002: All Ones Pattern");
            arbdp_store_data_c2 = 78'h3FFFFFFFFFFFFFFFFFFF;
            #1;

            check_outputs(78'h3FFFFFFFFFFFFFFFFFFF, 78'h3FFFFFFFFFFFFFFFFFFF);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning testcase003: Checkerboard Pattern (AAAA...)");
            arbdp_store_data_c2 = 78'h2AAAAAAAAAAAAAAAAAAA;
            #1;

            check_outputs(78'h2AAAAAAAAAAAAAAAAAAA, 78'h2AAAAAAAAAAAAAAAAAAA);
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning testcase004: Checkerboard Pattern (5555...)");
            arbdp_store_data_c2 = 78'h1555555555555555555;
            #1;

            check_outputs(78'h1555555555555555555, 78'h1555555555555555555);
        end
        endtask

    task testcase005;

        begin
            $display("\nRunning testcase005: Walking Bit 0");
            arbdp_store_data_c2 = 78'h00000000000000000001;
            #1;

            check_outputs(78'h00000000000000000001, 78'h00000000000000000001);
        end
        endtask

    task testcase006;

        begin
            $display("\nRunning testcase006: Walking Bit 77 (MSB)");
            arbdp_store_data_c2 = 78'h20000000000000000000;
            #1;

            check_outputs(78'h20000000000000000000, 78'h20000000000000000000);
        end
        endtask

    task testcase007;

        begin
            $display("\nRunning testcase007: Random Data Vector");
            arbdp_store_data_c2 = 78'h369CF0258BE147AD03F;
            #1;

            check_outputs(78'h369CF0258BE147AD03F, 78'h369CF0258BE147AD03F);
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
        testcase007();
        
        
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
        input [77:0] expected_rep_store_data_c2;
        input [77:0] expected_sctag_scdata_stdecc_c2;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_rep_store_data_c2 === (expected_rep_store_data_c2 ^ rep_store_data_c2 ^ expected_rep_store_data_c2) &&
                expected_sctag_scdata_stdecc_c2 === (expected_sctag_scdata_stdecc_c2 ^ sctag_scdata_stdecc_c2 ^ expected_sctag_scdata_stdecc_c2)) begin
                $display("PASS");
                $display("  Outputs: rep_store_data_c2=%h, sctag_scdata_stdecc_c2=%h",
                         rep_store_data_c2, sctag_scdata_stdecc_c2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rep_store_data_c2=%h, sctag_scdata_stdecc_c2=%h",
                         expected_rep_store_data_c2, expected_sctag_scdata_stdecc_c2);
                $display("  Got:      rep_store_data_c2=%h, sctag_scdata_stdecc_c2=%h",
                         rep_store_data_c2, sctag_scdata_stdecc_c2);
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
