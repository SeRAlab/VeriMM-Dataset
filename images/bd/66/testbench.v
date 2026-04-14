`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] cpat_seg_p_2_1_1_V_read;
    reg [11:0] ph_seg_p_2_1_1_V_read;
    reg [6:0] th_seg_p_2_1_0_V_read;
    reg [6:0] th_seg_p_2_1_1_V_read;
    wire [11:0] ap_return_0;
    wire [3:0] ap_return_1;
    wire [6:0] ap_return_2;
    wire [6:0] ap_return_3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .cpat_seg_p_2_1_1_V_read(cpat_seg_p_2_1_1_V_read),
        .ph_seg_p_2_1_1_V_read(ph_seg_p_2_1_1_V_read),
        .th_seg_p_2_1_0_V_read(th_seg_p_2_1_0_V_read),
        .th_seg_p_2_1_1_V_read(th_seg_p_2_1_1_V_read),
        .ap_return_0(ap_return_0),
        .ap_return_1(ap_return_1),
        .ap_return_2(ap_return_2),
        .ap_return_3(ap_return_3)
    );
    task testcase001;

    begin
        $display("Test Case 001: All zeros input");
        test_num = 1;
        ph_seg_p_2_1_1_V_read = 12'h000;
        cpat_seg_p_2_1_1_V_read = 4'h0;
        th_seg_p_2_1_0_V_read = 7'h00;
        th_seg_p_2_1_1_V_read = 7'h00;
        #1;

        check_outputs(12'h000, 4'h0, 7'h00, 7'h00);
    end
        endtask

    task testcase002;

    begin
        $display("Test Case 002: All ones (maximum) input");
        test_num = 2;
        ph_seg_p_2_1_1_V_read = 12'hFFF;
        cpat_seg_p_2_1_1_V_read = 4'hF;
        th_seg_p_2_1_0_V_read = 7'h7F;
        th_seg_p_2_1_1_V_read = 7'h7F;
        #1;

        check_outputs(12'hFFF, 4'hF, 7'h7F, 7'h7F);
    end
        endtask

    task testcase003;

    begin
        $display("Test Case 003: Alternating bit pattern A");
        test_num = 3;
        ph_seg_p_2_1_1_V_read = 12'hAAA;
        cpat_seg_p_2_1_1_V_read = 4'hA;
        th_seg_p_2_1_0_V_read = 7'h55;
        th_seg_p_2_1_1_V_read = 7'h2A;
        #1;

        check_outputs(12'hAAA, 4'hA, 7'h55, 7'h2A);
    end
        endtask

    task testcase004;

    begin
        $display("Test Case 004: Alternating bit pattern B");
        test_num = 4;
        ph_seg_p_2_1_1_V_read = 12'h555;
        cpat_seg_p_2_1_1_V_read = 4'h5;
        th_seg_p_2_1_0_V_read = 7'h2A;
        th_seg_p_2_1_1_V_read = 7'h55;
        #1;

        check_outputs(12'h555, 4'h5, 7'h2A, 7'h55);
    end
        endtask

    task testcase005;

    begin
        $display("Test Case 005: Random distinct values for channel isolation check");
        test_num = 5;
        ph_seg_p_2_1_1_V_read = 12'h123;
        cpat_seg_p_2_1_1_V_read = 4'hE;
        th_seg_p_2_1_0_V_read = 7'h1F;
        th_seg_p_2_1_1_V_read = 7'h60;
        #1;

        check_outputs(12'h123, 4'hE, 7'h1F, 7'h60);
    end
        endtask

    task testcase006;

    begin
        $display("Test Case 006: Boundary values (single bit toggles)");
        test_num = 6;
        ph_seg_p_2_1_1_V_read = 12'h800;
        cpat_seg_p_2_1_1_V_read = 4'h1;
        th_seg_p_2_1_0_V_read = 7'h01;
        th_seg_p_2_1_1_V_read = 7'h40;
        #1;

        check_outputs(12'h800, 4'h1, 7'h01, 7'h40);
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
        input [11:0] expected_ap_return_0;
        input [3:0] expected_ap_return_1;
        input [6:0] expected_ap_return_2;
        input [6:0] expected_ap_return_3;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ap_return_0 === (expected_ap_return_0 ^ ap_return_0 ^ expected_ap_return_0) &&
                expected_ap_return_1 === (expected_ap_return_1 ^ ap_return_1 ^ expected_ap_return_1) &&
                expected_ap_return_2 === (expected_ap_return_2 ^ ap_return_2 ^ expected_ap_return_2) &&
                expected_ap_return_3 === (expected_ap_return_3 ^ ap_return_3 ^ expected_ap_return_3)) begin
                $display("PASS");
                $display("  Outputs: ap_return_0=%h, ap_return_1=%h, ap_return_2=%h, ap_return_3=%h",
                         ap_return_0, ap_return_1, ap_return_2, ap_return_3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ap_return_0=%h, ap_return_1=%h, ap_return_2=%h, ap_return_3=%h",
                         expected_ap_return_0, expected_ap_return_1, expected_ap_return_2, expected_ap_return_3);
                $display("  Got:      ap_return_0=%h, ap_return_1=%h, ap_return_2=%h, ap_return_3=%h",
                         ap_return_0, ap_return_1, ap_return_2, ap_return_3);
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
