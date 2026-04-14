`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [144:0] sctag_cpx_data_pa;
    wire [144:0] sctag_cpx_data_buf_pa;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .sctag_cpx_data_pa(sctag_cpx_data_pa),
        .sctag_cpx_data_buf_pa(sctag_cpx_data_buf_pa)
    );
    task testcase001;

    begin
        $display("Testcase 001: All Zeros");
        test_num = 1;
        sctag_cpx_data_pa = 145'h0;
        #1;

        check_outputs(145'h0);
    end
        endtask

    task testcase002;

    begin
        $display("Testcase 002: All Ones");
        test_num = 2;
        sctag_cpx_data_pa = {145{1'b1}};
        #1;

        check_outputs({145{1'b1}});
    end
        endtask

    task testcase003;

    begin
        $display("Testcase 003: Alternating Pattern 1 (0101...)");
        test_num = 3;

        sctag_cpx_data_pa = 145'h0_5555_5555_5555_5555_5555_5555_5555_5555_5555;
        #1;

        check_outputs(145'h0_5555_5555_5555_5555_5555_5555_5555_5555_5555);
    end
        endtask

    task testcase004;

    begin
        $display("Testcase 004: Alternating Pattern 2 (1010...)");
        test_num = 4;

        sctag_cpx_data_pa = 145'h1_AAAA_AAAA_AAAA_AAAA_AAAA_AAAA_AAAA_AAAA_AAAA;
        #1;

        check_outputs(145'h1_AAAA_AAAA_AAAA_AAAA_AAAA_AAAA_AAAA_AAAA_AAAA);
    end
        endtask

    task testcase005;

    begin
        $display("Testcase 005: Walking One - LSB");
        test_num = 5;
        sctag_cpx_data_pa = 145'h1;
        #1;

        check_outputs(145'h1);
    end
        endtask

    task testcase006;

    begin
        $display("Testcase 006: Walking One - MSB");
        test_num = 6;
        sctag_cpx_data_pa = {1'b1, {144{1'b0}}};
        #1;

        check_outputs({1'b1, {144{1'b0}}});
    end
        endtask

    task testcase007;

    begin
        $display("Testcase 007: Random Pattern");
        test_num = 7;
        sctag_cpx_data_pa = 145'h0_DEAD_BEEF_CAFE_BABE_0123_4567_89AB_CDEF_55AA;
        #1;

        check_outputs(145'h0_DEAD_BEEF_CAFE_BABE_0123_4567_89AB_CDEF_55AA);
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
        input [144:0] expected_sctag_cpx_data_buf_pa;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_sctag_cpx_data_buf_pa === (expected_sctag_cpx_data_buf_pa ^ sctag_cpx_data_buf_pa ^ expected_sctag_cpx_data_buf_pa)) begin
                $display("PASS");
                $display("  Outputs: sctag_cpx_data_buf_pa=%h",
                         sctag_cpx_data_buf_pa);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: sctag_cpx_data_buf_pa=%h",
                         expected_sctag_cpx_data_buf_pa);
                $display("  Got:      sctag_cpx_data_buf_pa=%h",
                         sctag_cpx_data_buf_pa);
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
