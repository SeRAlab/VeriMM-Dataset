`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg bsr_data_to_core;
    reg bsr_mode;
    reg data;
    reg oe;
    reg por_l;
    reg rcvr_data;
    reg se;
    wire bsr_dn_l;
    wire bsr_up;
    wire pad_dn_l;
    wire pad_up;
    wire por;
    wire to_core;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .bsr_data_to_core(bsr_data_to_core),
        .bsr_mode(bsr_mode),
        .data(data),
        .oe(oe),
        .por_l(por_l),
        .rcvr_data(rcvr_data),
        .se(se),
        .bsr_dn_l(bsr_dn_l),
        .bsr_up(bsr_up),
        .pad_dn_l(pad_dn_l),
        .pad_up(pad_up),
        .por(por),
        .to_core(to_core)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("\nTest Case %0d: Power-On Reset Active", test_num);

        por_l = 0;
        bsr_mode = 0; data = 0; oe = 0; rcvr_data = 0; bsr_data_to_core = 0; se = 0;


        #1;



        check_outputs(1'b1, 1'b0, 1'b1, 1'b0, 1'b1, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("\nTest Case %0d: Normal Mode Core Path - RCVD High", test_num);
        por_l = 1;
        bsr_mode = 0;
        rcvr_data = 1;
        bsr_data_to_core = 0;
        oe = 0;


        #1;



        check_outputs(1'b1, 1'b0, 1'b1, 1'b0, 1'b0, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("\nTest Case %0d: Normal Mode Core Path - RCVD Low", test_num);
        por_l = 1;
        bsr_mode = 0;
        rcvr_data = 0;
        bsr_data_to_core = 1;
        oe = 0;


        #1;



        check_outputs(1'b1, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("\nTest Case %0d: BSR Mode Core Path - BSR High", test_num);
        por_l = 1;
        bsr_mode = 1;
        bsr_data_to_core = 1;
        rcvr_data = 0;
        oe = 0;


        #1;



        check_outputs(1'b1, 1'b0, 1'b1, 1'b0, 1'b0, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("\nTest Case %0d: BSR Mode Core Path - BSR Low", test_num);
        por_l = 1;
        bsr_mode = 1;
        bsr_data_to_core = 0;
        rcvr_data = 1;
        oe = 0;


        #1;



        check_outputs(1'b1, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("\nTest Case %0d: Pad Control - Drive High", test_num);
        por_l = 1;
        oe = 1;
        data = 1;


        #1;



        check_outputs(1'b1, 1'b1, 1'b1, 1'b1, 1'b0, to_core);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("\nTest Case %0d: Pad Control - Drive Low", test_num);
        por_l = 1;
        oe = 1;
        data = 0;


        #1;



        check_outputs(1'b0, 1'b0, 1'b0, 1'b0, 1'b0, to_core);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("\nTest Case %0d: Pad Control - High Impedance", test_num);
        por_l = 1;
        oe = 0;
        data = 1;


        #1;



        check_outputs(1'b1, 1'b0, 1'b1, 1'b0, 1'b0, to_core);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("\nTest Case %0d: Combined Mode (BSR + Pad Enable)", test_num);
        por_l = 1;
        bsr_mode = 1;
        bsr_data_to_core = 1;
        oe = 1;
        data = 0;


        #1;



        check_outputs(1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1);
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
        input expected_bsr_dn_l;
        input expected_bsr_up;
        input expected_pad_dn_l;
        input expected_pad_up;
        input expected_por;
        input expected_to_core;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_bsr_dn_l === (expected_bsr_dn_l ^ bsr_dn_l ^ expected_bsr_dn_l) &&
                expected_bsr_up === (expected_bsr_up ^ bsr_up ^ expected_bsr_up) &&
                expected_pad_dn_l === (expected_pad_dn_l ^ pad_dn_l ^ expected_pad_dn_l) &&
                expected_pad_up === (expected_pad_up ^ pad_up ^ expected_pad_up) &&
                expected_por === (expected_por ^ por ^ expected_por) &&
                expected_to_core === (expected_to_core ^ to_core ^ expected_to_core)) begin
                $display("PASS");
                $display("  Outputs: bsr_dn_l=%b, bsr_up=%b, pad_dn_l=%b, pad_up=%b, por=%b, to_core=%b",
                         bsr_dn_l, bsr_up, pad_dn_l, pad_up, por, to_core);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: bsr_dn_l=%b, bsr_up=%b, pad_dn_l=%b, pad_up=%b, por=%b, to_core=%b",
                         expected_bsr_dn_l, expected_bsr_up, expected_pad_dn_l, expected_pad_up, expected_por, expected_to_core);
                $display("  Got:      bsr_dn_l=%b, bsr_up=%b, pad_dn_l=%b, pad_up=%b, por=%b, to_core=%b",
                         bsr_dn_l, bsr_up, pad_dn_l, pad_up, por, to_core);
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
