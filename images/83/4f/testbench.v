`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [13:0] hactive_regist;
    reg [13:0] hblank_regist;
    reg [13:0] hfporch_regist;
    reg [13:0] hswidth_regist;
    reg [11:0] vactive_regist;
    reg [11:0] vblank_regist;
    reg [11:0] vfporch_regist;
    reg [11:0] vswidth_regist;
    wire [13:0] endequal_add;
    wire [13:0] endequalsec_add;
    wire [13:0] halfline_add;
    wire [13:0] hendsync_add;
    wire hfpbhs;
    wire [13:0] htotal_add;
    wire [13:0] serr_substr;
    wire [13:0] serrlongfp_substr;
    wire [13:0] serrsec_substr;
    wire [11:0] vendequal_add;
    wire [11:0] vendsync_add;
    wire [11:0] vtotal_add;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .hactive_regist(hactive_regist),
        .hblank_regist(hblank_regist),
        .hfporch_regist(hfporch_regist),
        .hswidth_regist(hswidth_regist),
        .vactive_regist(vactive_regist),
        .vblank_regist(vblank_regist),
        .vfporch_regist(vfporch_regist),
        .vswidth_regist(vswidth_regist),
        .endequal_add(endequal_add),
        .endequalsec_add(endequalsec_add),
        .halfline_add(halfline_add),
        .hendsync_add(hendsync_add),
        .hfpbhs(hfpbhs),
        .htotal_add(htotal_add),
        .serr_substr(serr_substr),
        .serrlongfp_substr(serrlongfp_substr),
        .serrsec_substr(serrsec_substr),
        .vendequal_add(vendequal_add),
        .vendsync_add(vendsync_add),
        .vtotal_add(vtotal_add)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: VGA 640x480 Standard Timing", test_num);

            hactive_regist = 14'd640;
            hblank_regist = 14'd160;
            hfporch_regist = 14'd16;
            hswidth_regist = 14'd96;
            vactive_regist = 12'd480;
            vblank_regist = 12'd45;
            vfporch_regist = 12'd10;
            vswidth_regist = 12'd2;














            #1;















            check_outputs(
                14'd64,
                14'd464,
                14'd400,
                14'd112,
                1'b0,
                14'd800,
                14'd304,
                14'd384,
                14'd704,
                12'd11,
                12'd12,
                12'd525
            );
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: HD 1080p Standard Timing", test_num);

            hactive_regist = 14'd1920;
            hblank_regist = 14'd280;
            hfporch_regist = 14'd88;
            hswidth_regist = 14'd44;
            vactive_regist = 12'd1080;
            vblank_regist = 12'd45;
            vfporch_regist = 12'd4;
            vswidth_regist = 12'd5;














            #1;















            check_outputs(
                14'd110,
                14'd1210,
                14'd1100,
                14'd132,
                1'b0,
                14'd2200,
                14'd1056,
                14'd1012,
                14'd2156,
                12'd6,
                12'd9,
                12'd1125
            );
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: 720p Timing", test_num);

            hactive_regist = 14'd1280;
            hblank_regist = 14'd370;
            hfporch_regist = 14'd110;
            hswidth_regist = 14'd40;
            vactive_regist = 12'd720;
            vblank_regist = 12'd30;
            vfporch_regist = 12'd5;
            vswidth_regist = 12'd5;












            #1;













            check_outputs(
                14'd130,
                14'd955,
                14'd825,
                14'd150,
                1'b0,
                14'd1650,
                14'd785,
                14'd715,
                14'd1610,
                12'd7,
                12'd10,
                12'd750
            );
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: XGA 1024x768 Timing", test_num);

            hactive_regist = 14'd1024;
            hblank_regist = 14'd320;
            hfporch_regist = 14'd24;
            hswidth_regist = 14'd136;
            vactive_regist = 12'd768;
            vblank_regist = 12'd38;
            vfporch_regist = 12'd3;
            vswidth_regist = 12'd6;












            #1;













            check_outputs(
                14'd92,
                14'd764,
                14'd672,
                14'd160,
                1'b0,
                14'd1344,
                14'd536,
                14'd648,
                14'd1208,
                12'd6,
                12'd9,
                12'd806
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
        input [13:0] expected_endequal_add;
        input [13:0] expected_endequalsec_add;
        input [13:0] expected_halfline_add;
        input [13:0] expected_hendsync_add;
        input expected_hfpbhs;
        input [13:0] expected_htotal_add;
        input [13:0] expected_serr_substr;
        input [13:0] expected_serrlongfp_substr;
        input [13:0] expected_serrsec_substr;
        input [11:0] expected_vendequal_add;
        input [11:0] expected_vendsync_add;
        input [11:0] expected_vtotal_add;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_endequal_add === (expected_endequal_add ^ endequal_add ^ expected_endequal_add) &&
                expected_endequalsec_add === (expected_endequalsec_add ^ endequalsec_add ^ expected_endequalsec_add) &&
                expected_halfline_add === (expected_halfline_add ^ halfline_add ^ expected_halfline_add) &&
                expected_hendsync_add === (expected_hendsync_add ^ hendsync_add ^ expected_hendsync_add) &&
                expected_hfpbhs === (expected_hfpbhs ^ hfpbhs ^ expected_hfpbhs) &&
                expected_htotal_add === (expected_htotal_add ^ htotal_add ^ expected_htotal_add) &&
                expected_serr_substr === (expected_serr_substr ^ serr_substr ^ expected_serr_substr) &&
                expected_serrlongfp_substr === (expected_serrlongfp_substr ^ serrlongfp_substr ^ expected_serrlongfp_substr) &&
                expected_serrsec_substr === (expected_serrsec_substr ^ serrsec_substr ^ expected_serrsec_substr) &&
                expected_vendequal_add === (expected_vendequal_add ^ vendequal_add ^ expected_vendequal_add) &&
                expected_vendsync_add === (expected_vendsync_add ^ vendsync_add ^ expected_vendsync_add) &&
                expected_vtotal_add === (expected_vtotal_add ^ vtotal_add ^ expected_vtotal_add)) begin
                $display("PASS");
                $display("  Outputs: endequal_add=%h, endequalsec_add=%h, halfline_add=%h, hendsync_add=%h, hfpbhs=%b, htotal_add=%h, serr_substr=%h, serrlongfp_substr=%h, serrsec_substr=%h, vendequal_add=%h, vendsync_add=%h, vtotal_add=%h",
                         endequal_add, endequalsec_add, halfline_add, hendsync_add, hfpbhs, htotal_add, serr_substr, serrlongfp_substr, serrsec_substr, vendequal_add, vendsync_add, vtotal_add);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: endequal_add=%h, endequalsec_add=%h, halfline_add=%h, hendsync_add=%h, hfpbhs=%b, htotal_add=%h, serr_substr=%h, serrlongfp_substr=%h, serrsec_substr=%h, vendequal_add=%h, vendsync_add=%h, vtotal_add=%h",
                         expected_endequal_add, expected_endequalsec_add, expected_halfline_add, expected_hendsync_add, expected_hfpbhs, expected_htotal_add, expected_serr_substr, expected_serrlongfp_substr, expected_serrsec_substr, expected_vendequal_add, expected_vendsync_add, expected_vtotal_add);
                $display("  Got:      endequal_add=%h, endequalsec_add=%h, halfline_add=%h, hendsync_add=%h, hfpbhs=%b, htotal_add=%h, serr_substr=%h, serrlongfp_substr=%h, serrsec_substr=%h, vendequal_add=%h, vendsync_add=%h, vtotal_add=%h",
                         endequal_add, endequalsec_add, halfline_add, hendsync_add, hfpbhs, htotal_add, serr_substr, serrlongfp_substr, serrsec_substr, vendequal_add, vendsync_add, vtotal_add);
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
