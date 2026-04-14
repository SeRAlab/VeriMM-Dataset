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
        test_num = 1;
        $display("Running Testcase001: All Zeros");
        arbdp_store_data_c2 = 78'h0;
        #1;

        check_outputs(78'h0, 78'h0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Running Testcase002: All Ones");

        arbdp_store_data_c2 = 78'h3FFFFFFFFFFFFFFFFFF;
        #1;

        check_outputs(78'h3FFFFFFFFFFFFFFFFFF, 78'h3FFFFFFFFFFFFFFFFFF);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Running Testcase003: Alternating Bits (1010)");
        arbdp_store_data_c2 = 78'h2AAAAAAAAAAAAAAAAAAA;
        #1;

        check_outputs(78'h2AAAAAAAAAAAAAAAAAAA, 78'h2AAAAAAAAAAAAAAAAAAA);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Running Testcase004: Alternating Bits (0101)");
        arbdp_store_data_c2 = 78'h1555555555555555555;
        #1;

        check_outputs(78'h1555555555555555555, 78'h1555555555555555555);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Running Testcase005: Hex Pattern DEADBEEF");
        arbdp_store_data_c2 = 78'h0DEADBEEFFEEDFACED0;
        #1;

        check_outputs(78'h0DEADBEEFFEEDFACED0, 78'h0DEADBEEFFEEDFACED0);
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
