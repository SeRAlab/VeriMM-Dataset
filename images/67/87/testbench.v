`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg avl_st_default_iport_1_ready;
    reg [63:0] avl_st_iport_0_data;
    reg [2:0] avl_st_iport_0_empty;
    reg avl_st_iport_0_eop;
    reg [5:0] avl_st_iport_0_error;
    reg avl_st_iport_0_sop;
    reg avl_st_iport_0_val;
    reg [63:0] avl_st_iport_1_data;
    reg [2:0] avl_st_iport_1_empty;
    reg avl_st_iport_1_eop;
    reg [5:0] avl_st_iport_1_error;
    reg avl_st_iport_1_sop;
    reg avl_st_iport_1_val;
    reg avl_st_oport_ready;
    reg cfg_lpmx_sel_iport_1;
    wire avl_st_lpmx_iport_0_ready;
    wire avl_st_lpmx_iport_1_ready;
    wire [63:0] avl_st_oport_data;
    wire [2:0] avl_st_oport_empty;
    wire avl_st_oport_eop;
    wire [5:0] avl_st_oport_error;
    wire avl_st_oport_sop;
    wire avl_st_oport_val;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .avl_st_default_iport_1_ready(avl_st_default_iport_1_ready),
        .avl_st_iport_0_data(avl_st_iport_0_data),
        .avl_st_iport_0_empty(avl_st_iport_0_empty),
        .avl_st_iport_0_eop(avl_st_iport_0_eop),
        .avl_st_iport_0_error(avl_st_iport_0_error),
        .avl_st_iport_0_sop(avl_st_iport_0_sop),
        .avl_st_iport_0_val(avl_st_iport_0_val),
        .avl_st_iport_1_data(avl_st_iport_1_data),
        .avl_st_iport_1_empty(avl_st_iport_1_empty),
        .avl_st_iport_1_eop(avl_st_iport_1_eop),
        .avl_st_iport_1_error(avl_st_iport_1_error),
        .avl_st_iport_1_sop(avl_st_iport_1_sop),
        .avl_st_iport_1_val(avl_st_iport_1_val),
        .avl_st_oport_ready(avl_st_oport_ready),
        .cfg_lpmx_sel_iport_1(cfg_lpmx_sel_iport_1),
        .avl_st_lpmx_iport_0_ready(avl_st_lpmx_iport_0_ready),
        .avl_st_lpmx_iport_1_ready(avl_st_lpmx_iport_1_ready),
        .avl_st_oport_data(avl_st_oport_data),
        .avl_st_oport_empty(avl_st_oport_empty),
        .avl_st_oport_eop(avl_st_oport_eop),
        .avl_st_oport_error(avl_st_oport_error),
        .avl_st_oport_sop(avl_st_oport_sop),
        .avl_st_oport_val(avl_st_oport_val)
    );
    task testcase001;

        begin
            $display("\nTest Case 001: Select Port 0 - Basic Data Pass-through");
            test_num = test_num + 1;


            cfg_lpmx_sel_iport_1 = 1'b0;
            avl_st_oport_ready   = 1'b1;
            avl_st_default_iport_1_ready = 1'b0;


            avl_st_iport_0_data  = 64'hAAAA_BBBB_CCCC_DDDD;
            avl_st_iport_0_empty = 3'h2;
            avl_st_iport_0_eop   = 1'b1;
            avl_st_iport_0_error = 6'h05;
            avl_st_iport_0_sop   = 1'b0;
            avl_st_iport_0_val   = 1'b1;


            avl_st_iport_1_data  = 64'h1111_2222_3333_4444;
            avl_st_iport_1_empty = 3'h0;
            avl_st_iport_1_eop   = 1'b0;
            avl_st_iport_1_error = 6'h00;
            avl_st_iport_1_sop   = 1'b1;
            avl_st_iport_1_val   = 1'b0;


            #1;



            check_outputs(
                1'b1,
                1'b0,
                64'hAAAA_BBBB_CCCC_DDDD,
                3'h2,
                1'b1,
                6'h05,
                1'b0,
                1'b1
            );
        end
        endtask

    task testcase002;

        begin
            $display("\nTest Case 002: Select Port 1 - Basic Data Pass-through");
            test_num = test_num + 1;


            cfg_lpmx_sel_iport_1 = 1'b1;
            avl_st_oport_ready   = 1'b1;
            avl_st_default_iport_1_ready = 1'b0;


            avl_st_iport_0_data  = 64'hAAAA_BBBB_CCCC_DDDD;
            avl_st_iport_0_empty = 3'h2;
            avl_st_iport_0_eop   = 1'b1;
            avl_st_iport_0_error = 6'h05;
            avl_st_iport_0_sop   = 1'b0;
            avl_st_iport_0_val   = 1'b1;


            avl_st_iport_1_data  = 64'h5555_6666_7777_8888;
            avl_st_iport_1_empty = 3'h4;
            avl_st_iport_1_eop   = 1'b0;
            avl_st_iport_1_error = 6'h2A;
            avl_st_iport_1_sop   = 1'b1;
            avl_st_iport_1_val   = 1'b1;


            #1;



            check_outputs(
                1'b0,
                1'b1,
                64'h5555_6666_7777_8888,
                3'h4,
                1'b0,
                6'h2A,
                1'b1,
                1'b1
            );
        end
        endtask

    task testcase003;

        begin
            $display("\nTest Case 003: Ready Propagation - Port 0 Selected, Oport Ready Low");
            test_num = test_num + 1;

            cfg_lpmx_sel_iport_1 = 1'b0;
            avl_st_oport_ready   = 1'b0;
            avl_st_default_iport_1_ready = 1'b1;


            avl_st_iport_0_val   = 1'b1;
            avl_st_iport_0_data  = 64'hFEED_FACE_CAFE_BEEF;


            #1;



            check_outputs(
                1'b0,
                1'b1,
                64'hFEED_FACE_CAFE_BEEF,
                avl_st_iport_0_empty,
                avl_st_iport_0_eop,
                avl_st_iport_0_error,
                avl_st_iport_0_sop,
                1'b1
            );
        end
        endtask

    task testcase004;

        begin
            $display("\nTest Case 004: Ready Propagation - Port 1 Selected, Oport Ready High");
            test_num = test_num + 1;

            cfg_lpmx_sel_iport_1 = 1'b1;
            avl_st_oport_ready   = 1'b1;
            avl_st_default_iport_1_ready = 1'b0;


            avl_st_iport_1_val   = 1'b1;
            avl_st_iport_1_data  = 64'h0000_1111_0000_1111;

            #1;


            check_outputs(
                1'b0,
                1'b1,
                64'h0000_1111_0000_1111,
                avl_st_iport_1_empty,
                avl_st_iport_1_eop,
                avl_st_iport_1_error,
                avl_st_iport_1_sop,
                1'b1
            );
        end
        endtask

    task testcase005;

        begin
            $display("\nTest Case 005: Boundary Data Values Check");
            test_num = test_num + 1;

            cfg_lpmx_sel_iport_1 = 1'b0;
            avl_st_oport_ready   = 1'b1;


            avl_st_iport_0_data  = 64'h0;
            avl_st_iport_0_empty = 3'h0;
            avl_st_iport_0_eop   = 1'b0;
            avl_st_iport_0_error = 6'h0;
            avl_st_iport_0_sop   = 1'b0;
            avl_st_iport_0_val   = 1'b0;

            #1;


            check_outputs(
                1'b1, 1'b0, 64'h0, 3'h0, 1'b0, 6'h0, 1'b0, 1'b0
            );

            $display("Sub-test: All ones test on Port 0");
            avl_st_iport_0_data  = 64'hFFFF_FFFF_FFFF_FFFF;
            avl_st_iport_0_empty = 3'h7;
            avl_st_iport_0_eop   = 1'b1;
            avl_st_iport_0_error = 6'h3F;
            avl_st_iport_0_sop   = 1'b1;
            avl_st_iport_0_val   = 1'b1;

            #1;


            check_outputs(
                1'b1, 1'b0, 64'hFFFF_FFFF_FFFF_FFFF, 3'h7, 1'b1, 6'h3F, 1'b1, 1'b1
            );
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
        input expected_avl_st_lpmx_iport_0_ready;
        input expected_avl_st_lpmx_iport_1_ready;
        input [63:0] expected_avl_st_oport_data;
        input [2:0] expected_avl_st_oport_empty;
        input expected_avl_st_oport_eop;
        input [5:0] expected_avl_st_oport_error;
        input expected_avl_st_oport_sop;
        input expected_avl_st_oport_val;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_avl_st_lpmx_iport_0_ready === (expected_avl_st_lpmx_iport_0_ready ^ avl_st_lpmx_iport_0_ready ^ expected_avl_st_lpmx_iport_0_ready) &&
                expected_avl_st_lpmx_iport_1_ready === (expected_avl_st_lpmx_iport_1_ready ^ avl_st_lpmx_iport_1_ready ^ expected_avl_st_lpmx_iport_1_ready) &&
                expected_avl_st_oport_data === (expected_avl_st_oport_data ^ avl_st_oport_data ^ expected_avl_st_oport_data) &&
                expected_avl_st_oport_empty === (expected_avl_st_oport_empty ^ avl_st_oport_empty ^ expected_avl_st_oport_empty) &&
                expected_avl_st_oport_eop === (expected_avl_st_oport_eop ^ avl_st_oport_eop ^ expected_avl_st_oport_eop) &&
                expected_avl_st_oport_error === (expected_avl_st_oport_error ^ avl_st_oport_error ^ expected_avl_st_oport_error) &&
                expected_avl_st_oport_sop === (expected_avl_st_oport_sop ^ avl_st_oport_sop ^ expected_avl_st_oport_sop) &&
                expected_avl_st_oport_val === (expected_avl_st_oport_val ^ avl_st_oport_val ^ expected_avl_st_oport_val)) begin
                $display("PASS");
                $display("  Outputs: avl_st_lpmx_iport_0_ready=%b, avl_st_lpmx_iport_1_ready=%b, avl_st_oport_data=%h, avl_st_oport_empty=%h, avl_st_oport_eop=%b, avl_st_oport_error=%h, avl_st_oport_sop=%b, avl_st_oport_val=%b",
                         avl_st_lpmx_iport_0_ready, avl_st_lpmx_iport_1_ready, avl_st_oport_data, avl_st_oport_empty, avl_st_oport_eop, avl_st_oport_error, avl_st_oport_sop, avl_st_oport_val);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: avl_st_lpmx_iport_0_ready=%b, avl_st_lpmx_iport_1_ready=%b, avl_st_oport_data=%h, avl_st_oport_empty=%h, avl_st_oport_eop=%b, avl_st_oport_error=%h, avl_st_oport_sop=%b, avl_st_oport_val=%b",
                         expected_avl_st_lpmx_iport_0_ready, expected_avl_st_lpmx_iport_1_ready, expected_avl_st_oport_data, expected_avl_st_oport_empty, expected_avl_st_oport_eop, expected_avl_st_oport_error, expected_avl_st_oport_sop, expected_avl_st_oport_val);
                $display("  Got:      avl_st_lpmx_iport_0_ready=%b, avl_st_lpmx_iport_1_ready=%b, avl_st_oport_data=%h, avl_st_oport_empty=%h, avl_st_oport_eop=%b, avl_st_oport_error=%h, avl_st_oport_sop=%b, avl_st_oport_val=%b",
                         avl_st_lpmx_iport_0_ready, avl_st_lpmx_iport_1_ready, avl_st_oport_data, avl_st_oport_empty, avl_st_oport_eop, avl_st_oport_error, avl_st_oport_sop, avl_st_oport_val);
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
