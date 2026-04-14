`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg c_cerr_rr;
    reg c_crdy_rr;
    reg is_reconfn;
    reg [31:0] p_data_rr;
    reg p_prdy_rr;
    reg rc_ackn_rr;
    wire c_cerr;
    wire c_crdy;
    wire [31:0] p_data;
    wire p_prdy;
    wire rc_ackn;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .c_cerr_rr(c_cerr_rr),
        .c_crdy_rr(c_crdy_rr),
        .is_reconfn(is_reconfn),
        .p_data_rr(p_data_rr),
        .p_prdy_rr(p_prdy_rr),
        .rc_ackn_rr(rc_ackn_rr),
        .c_cerr(c_cerr),
        .c_crdy(c_crdy),
        .p_data(p_data),
        .p_prdy(p_prdy),
        .rc_ackn(rc_ackn)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Normal operation (is_reconfn=1), all inputs high", test_num);

            is_reconfn = 1'b1;
            rc_ackn_rr = 1'b1;
            p_prdy_rr  = 1'b1;
            p_data_rr  = 32'hFFFFFFFF;
            c_crdy_rr  = 1'b1;
            c_cerr_rr  = 1'b1;


            #1;



            check_outputs(1'b1, 1'b1, 32'hFFFFFFFF, 1'b1, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Normal operation (is_reconfn=1), hex pattern DEADBEEF", test_num);

            is_reconfn = 1'b1;
            rc_ackn_rr = 1'b0;
            p_prdy_rr  = 1'b1;
            p_data_rr  = 32'hDEADBEEF;
            c_crdy_rr  = 1'b0;
            c_cerr_rr  = 1'b1;

            #1;


            check_outputs(1'b1, 1'b0, 32'hDEADBEEF, 1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Reconfig mode (is_reconfn=0), inputs high, expect outputs suppressed", test_num);

            is_reconfn = 1'b0;
            rc_ackn_rr = 1'b1;
            p_prdy_rr  = 1'b1;
            p_data_rr  = 32'hFFFFFFFF;
            c_crdy_rr  = 1'b1;
            c_cerr_rr  = 1'b1;


            #1;



            check_outputs(1'b0, 1'b0, 32'h00000000, 1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Normal operation (is_reconfn=1), alternating bit pattern", test_num);

            is_reconfn = 1'b1;
            rc_ackn_rr = 1'b1;
            p_prdy_rr  = 1'b0;
            p_data_rr  = 32'hAAAAAAAA;
            c_crdy_rr  = 1'b1;
            c_cerr_rr  = 1'b0;

            #1;


            check_outputs(1'b0, 1'b1, 32'hAAAAAAAA, 1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Transition from Normal to Reconfig mode", test_num);


            rc_ackn_rr = 1'b1;
            p_prdy_rr  = 1'b1;
            p_data_rr  = 32'h55555555;
            c_crdy_rr  = 1'b1;
            c_cerr_rr  = 1'b1;


            is_reconfn = 1'b1;
            #5;
            is_reconfn = 1'b0;


            #1;



            check_outputs(1'b0, 1'b0, 32'h00000000, 1'b0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Reconfig mode (is_reconfn=0), verify outputs stay zero with random data", test_num);

            is_reconfn = 1'b0;
            rc_ackn_rr = 1'b0;
            p_prdy_rr  = 1'b1;
            p_data_rr  = 32'h12345678;
            c_crdy_rr  = 1'b1;
            c_cerr_rr  = 1'b0;

            #1;


            check_outputs(1'b0, 1'b0, 32'h00000000, 1'b0, 1'b0);
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
        input expected_c_cerr;
        input expected_c_crdy;
        input [31:0] expected_p_data;
        input expected_p_prdy;
        input expected_rc_ackn;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_c_cerr === (expected_c_cerr ^ c_cerr ^ expected_c_cerr) &&
                expected_c_crdy === (expected_c_crdy ^ c_crdy ^ expected_c_crdy) &&
                expected_p_data === (expected_p_data ^ p_data ^ expected_p_data) &&
                expected_p_prdy === (expected_p_prdy ^ p_prdy ^ expected_p_prdy) &&
                expected_rc_ackn === (expected_rc_ackn ^ rc_ackn ^ expected_rc_ackn)) begin
                $display("PASS");
                $display("  Outputs: c_cerr=%b, c_crdy=%b, p_data=%h, p_prdy=%b, rc_ackn=%b",
                         c_cerr, c_crdy, p_data, p_prdy, rc_ackn);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: c_cerr=%b, c_crdy=%b, p_data=%h, p_prdy=%b, rc_ackn=%b",
                         expected_c_cerr, expected_c_crdy, expected_p_data, expected_p_prdy, expected_rc_ackn);
                $display("  Got:      c_cerr=%b, c_crdy=%b, p_data=%h, p_prdy=%b, rc_ackn=%b",
                         c_cerr, c_crdy, p_data, p_prdy, rc_ackn);
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
