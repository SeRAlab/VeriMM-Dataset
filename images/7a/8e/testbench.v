`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg wbck_i_err;
    reg wbck_i_flags;
    reg wbck_i_pc;
    reg wbck_i_rdfpu;
    reg wbck_i_rdidx;
    reg wbck_i_valid;
    reg wbck_i_wdat;
    wire oitf_ret_ena;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .wbck_i_err(wbck_i_err),
        .wbck_i_flags(wbck_i_flags),
        .wbck_i_pc(wbck_i_pc),
        .wbck_i_rdfpu(wbck_i_rdfpu),
        .wbck_i_rdidx(wbck_i_rdidx),
        .wbck_i_valid(wbck_i_valid),
        .wbck_i_wdat(wbck_i_wdat),
        .oitf_ret_ena(oitf_ret_ena)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Basic valid write-back (no error)", test_num);
        wbck_i_valid = 1'b1;
        wbck_i_err   = 1'b0;
        wbck_i_wdat  = 1'b0;
        wbck_i_flags = 1'b0;
        wbck_i_rdfpu = 1'b0;
        wbck_i_rdidx = 1'b0;
        wbck_i_pc    = 1'b0;

        #1;


        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Invalid write-back signal", test_num);
        wbck_i_valid = 1'b0;
        wbck_i_err   = 1'b0;
        wbck_i_wdat  = 1'b1;
        wbck_i_flags = 1'b1;
        wbck_i_rdfpu = 1'b0;
        wbck_i_rdidx = 1'b1;
        wbck_i_pc    = 1'b0;

        #1;


        check_outputs(1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Valid write-back with error (exception handling)", test_num);
        wbck_i_valid = 1'b1;
        wbck_i_err   = 1'b1;
        wbck_i_wdat  = 1'b0;
        wbck_i_flags = 1'b0;
        wbck_i_rdfpu = 1'b0;
        wbck_i_rdidx = 1'b1;
        wbck_i_pc    = 1'b1;


        #1;



        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Valid write-back with FPU and Data flags", test_num);
        wbck_i_valid = 1'b1;
        wbck_i_err   = 1'b0;
        wbck_i_wdat  = 1'b1;
        wbck_i_flags = 1'b1;
        wbck_i_rdfpu = 1'b1;
        wbck_i_rdidx = 1'b0;
        wbck_i_pc    = 1'b0;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: All inputs zero", test_num);
        wbck_i_valid = 1'b0;
        wbck_i_err   = 1'b0;
        wbck_i_wdat  = 1'b0;
        wbck_i_flags = 1'b0;
        wbck_i_rdfpu = 1'b0;
        wbck_i_rdidx = 1'b0;
        wbck_i_pc    = 1'b0;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Toggle valid signal", test_num);
        wbck_i_valid = 1'b1;
        wbck_i_err   = 1'b1;
        wbck_i_wdat  = 1'b1;
        wbck_i_flags = 1'b1;
        wbck_i_rdfpu = 1'b1;
        wbck_i_rdidx = 1'b1;
        wbck_i_pc    = 1'b1;
        #5;
        wbck_i_valid = 1'b0;
        #1;

        check_outputs(1'b0);
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
        input expected_oitf_ret_ena;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_oitf_ret_ena === (expected_oitf_ret_ena ^ oitf_ret_ena ^ expected_oitf_ret_ena)) begin
                $display("PASS");
                $display("  Outputs: oitf_ret_ena=%b",
                         oitf_ret_ena);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: oitf_ret_ena=%b",
                         expected_oitf_ret_ena);
                $display("  Got:      oitf_ret_ena=%b",
                         oitf_ret_ena);
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
