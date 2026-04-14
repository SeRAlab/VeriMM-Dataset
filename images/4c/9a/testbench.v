`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] fp_cpx_req_bufpt_cq_l;
    wire [7:0] fp_cpx_req_bufp0_cq;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .fp_cpx_req_bufpt_cq_l(fp_cpx_req_bufpt_cq_l),
        .fp_cpx_req_bufp0_cq(fp_cpx_req_bufp0_cq)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: All bits zero", test_num);
        fp_cpx_req_bufpt_cq_l = 8'h00;
        #1;

        check_outputs(8'hFF);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: All bits one", test_num);
        fp_cpx_req_bufpt_cq_l = 8'hFF;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Alternating bits (Pattern AA)", test_num);
        fp_cpx_req_bufpt_cq_l = 8'hAA;
        #1;

        check_outputs(8'h55);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Alternating bits (Pattern 55)", test_num);
        fp_cpx_req_bufpt_cq_l = 8'h55;
        #1;

        check_outputs(8'hAA);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: High nibble one, Low nibble zero", test_num);
        fp_cpx_req_bufpt_cq_l = 8'hF0;
        #1;

        check_outputs(8'h0F);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: High nibble zero, Low nibble one", test_num);
        fp_cpx_req_bufpt_cq_l = 8'h0F;
        #1;

        check_outputs(8'hF0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Walking bit (LSB)", test_num);
        fp_cpx_req_bufpt_cq_l = 8'h01;
        #1;

        check_outputs(8'hFE);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Walking bit (MSB)", test_num);
        fp_cpx_req_bufpt_cq_l = 8'h80;
        #1;

        check_outputs(8'h7F);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Arbitrary pattern C3", test_num);
        fp_cpx_req_bufpt_cq_l = 8'hC3;
        #1;

        check_outputs(8'h3C);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Arbitrary pattern 3C", test_num);
        fp_cpx_req_bufpt_cq_l = 8'h3C;
        #1;

        check_outputs(8'hC3);
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
        testcase008();
        testcase009();
        testcase010();
        
        
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
        input [7:0] expected_fp_cpx_req_bufp0_cq;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_fp_cpx_req_bufp0_cq === (expected_fp_cpx_req_bufp0_cq ^ fp_cpx_req_bufp0_cq ^ expected_fp_cpx_req_bufp0_cq)) begin
                $display("PASS");
                $display("  Outputs: fp_cpx_req_bufp0_cq=%h",
                         fp_cpx_req_bufp0_cq);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: fp_cpx_req_bufp0_cq=%h",
                         expected_fp_cpx_req_bufp0_cq);
                $display("  Got:      fp_cpx_req_bufp0_cq=%h",
                         fp_cpx_req_bufp0_cq);
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
