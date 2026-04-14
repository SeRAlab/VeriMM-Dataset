`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] RGB_VB_o;
    reg [7:0] RGB_VG_o;
    reg [7:0] RGB_VR_o;
    reg VGA_BLANK;
    reg VGA_SYNC;
    wire [7:0] AD_B_o;
    wire [7:0] AD_G_o;
    wire [7:0] AD_R_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .RGB_VB_o(RGB_VB_o),
        .RGB_VG_o(RGB_VG_o),
        .RGB_VR_o(RGB_VR_o),
        .VGA_BLANK(VGA_BLANK),
        .VGA_SYNC(VGA_SYNC),
        .AD_B_o(AD_B_o),
        .AD_G_o(AD_G_o),
        .AD_R_o(AD_R_o)
    );
    task testcase001;

        begin
            $display("Testcase 001: Active display - RGB signals should pass through.");
            test_num = 1;
            VGA_SYNC = 1'b1;
            VGA_BLANK = 1'b1;
            RGB_VR_o = 8'hA5;
            RGB_VG_o = 8'h5A;
            RGB_VB_o = 8'hFF;

            #1;


            check_outputs(8'hFF, 8'h5A, 8'hA5);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Blanking active - Outputs should be zero.");
            test_num = 2;
            VGA_SYNC = 1'b1;
            VGA_BLANK = 1'b0;
            RGB_VR_o = 8'hA5;
            RGB_VG_o = 8'h5A;
            RGB_VB_o = 8'hFF;
            #1;

            check_outputs(8'h00, 8'h00, 8'h00);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Sync inactive - Outputs should be zero.");
            test_num = 3;
            VGA_SYNC = 1'b0;
            VGA_BLANK = 1'b1;
            RGB_VR_o = 8'h12;
            RGB_VG_o = 8'h34;
            RGB_VB_o = 8'h56;
            #1;

            check_outputs(8'h00, 8'h00, 8'h00);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Both Blank and Sync inactive - Outputs should be zero.");
            test_num = 4;
            VGA_SYNC = 1'b0;
            VGA_BLANK = 1'b0;
            RGB_VR_o = 8'hFF;
            RGB_VG_o = 8'hFF;
            RGB_VB_o = 8'hFF;
            #1;

            check_outputs(8'h00, 8'h00, 8'h00);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Active display with zero inputs.");
            test_num = 5;
            VGA_SYNC = 1'b1;
            VGA_BLANK = 1'b1;
            RGB_VR_o = 8'h00;
            RGB_VG_o = 8'h00;
            RGB_VB_o = 8'h00;
            #1;

            check_outputs(8'h00, 8'h00, 8'h00);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Transition from active to blanking.");
            test_num = 6;

            VGA_SYNC = 1'b1; VGA_BLANK = 1'b1;
            RGB_VR_o = 8'hDE; RGB_VG_o = 8'hAD; RGB_VB_o = 8'hBE;
            #5;

            VGA_BLANK = 1'b0;
            #1;

            check_outputs(8'h00, 8'h00, 8'h00);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Maximum RGB values in active region.");
            test_num = 7;
            VGA_SYNC = 1'b1;
            VGA_BLANK = 1'b1;
            RGB_VR_o = 8'hFF;
            RGB_VG_o = 8'hFF;
            RGB_VB_o = 8'hFF;
            #1;

            check_outputs(8'hFF, 8'hFF, 8'hFF);
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
        input [7:0] expected_AD_B_o;
        input [7:0] expected_AD_G_o;
        input [7:0] expected_AD_R_o;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_AD_B_o === (expected_AD_B_o ^ AD_B_o ^ expected_AD_B_o) &&
                expected_AD_G_o === (expected_AD_G_o ^ AD_G_o ^ expected_AD_G_o) &&
                expected_AD_R_o === (expected_AD_R_o ^ AD_R_o ^ expected_AD_R_o)) begin
                $display("PASS");
                $display("  Outputs: AD_B_o=%h, AD_G_o=%h, AD_R_o=%h",
                         AD_B_o, AD_G_o, AD_R_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: AD_B_o=%h, AD_G_o=%h, AD_R_o=%h",
                         expected_AD_B_o, expected_AD_G_o, expected_AD_R_o);
                $display("  Got:      AD_B_o=%h, AD_G_o=%h, AD_R_o=%h",
                         AD_B_o, AD_G_o, AD_R_o);
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
