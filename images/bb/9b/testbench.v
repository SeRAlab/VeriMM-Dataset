`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg enable;
    reg [31:0] frontend_i;
    reg [31:0] frontend_q;
    wire [31:0] bb_sample;
    wire bb_strobe;
    wire [31:0] ddc_in_i;
    wire [31:0] ddc_in_q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .enable(enable),
        .frontend_i(frontend_i),
        .frontend_q(frontend_q),
        .bb_sample(bb_sample),
        .bb_strobe(bb_strobe),
        .ddc_in_i(ddc_in_i),
        .ddc_in_q(ddc_in_q)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: All signals zero", test_num);
            enable = 0;
            frontend_i = 32'h0;
            frontend_q = 32'h0;

            #1;


            check_outputs(32'h0, 0, 32'h0, 32'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Transmission enabled with standard pattern", test_num);
            enable = 1;
            frontend_i = 32'h12345678;
            frontend_q = 32'h9ABCDEF0;

            #1;


            check_outputs(32'h12345678, 1, 32'h12345678, 32'h9ABCDEF0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Transmission enabled with alternating bits", test_num);
            enable = 1;
            frontend_i = 32'h5555AAAA;
            frontend_q = 32'hAAAA5555;
            #1;

            check_outputs(32'h5555AAAA, 1, 32'h5555AAAA, 32'hAAAA5555);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Strobe disabled with active data", test_num);
            enable = 0;
            frontend_i = 32'hDEADBEEF;
            frontend_q = 32'hCAFEBABE;


            #1;



            check_outputs(32'hDEADBEEF, 0, 32'hDEADBEEF, 32'hCAFEBABE);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Maximum values", test_num);
            enable = 1;
            frontend_i = 32'hFFFFFFFF;
            frontend_q = 32'hFFFFFFFF;
            #1;

            check_outputs(32'hFFFFFFFF, 1, 32'hFFFFFFFF, 32'hFFFFFFFF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Single bit changes", test_num);
            enable = 1;
            frontend_i = 32'h00000001;
            frontend_q = 32'h80000000;
            #1;

            check_outputs(32'h00000001, 1, 32'h00000001, 32'h80000000);
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
        input [31:0] expected_bb_sample;
        input expected_bb_strobe;
        input [31:0] expected_ddc_in_i;
        input [31:0] expected_ddc_in_q;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_bb_sample === (expected_bb_sample ^ bb_sample ^ expected_bb_sample) &&
                expected_bb_strobe === (expected_bb_strobe ^ bb_strobe ^ expected_bb_strobe) &&
                expected_ddc_in_i === (expected_ddc_in_i ^ ddc_in_i ^ expected_ddc_in_i) &&
                expected_ddc_in_q === (expected_ddc_in_q ^ ddc_in_q ^ expected_ddc_in_q)) begin
                $display("PASS");
                $display("  Outputs: bb_sample=%h, bb_strobe=%b, ddc_in_i=%h, ddc_in_q=%h",
                         bb_sample, bb_strobe, ddc_in_i, ddc_in_q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: bb_sample=%h, bb_strobe=%b, ddc_in_i=%h, ddc_in_q=%h",
                         expected_bb_sample, expected_bb_strobe, expected_ddc_in_i, expected_ddc_in_q);
                $display("  Got:      bb_sample=%h, bb_strobe=%b, ddc_in_i=%h, ddc_in_q=%h",
                         bb_sample, bb_strobe, ddc_in_i, ddc_in_q);
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
