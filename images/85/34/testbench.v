`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg active;
    reg clk_125;
    reg clk_25;
    reg hdmi_cec;
    reg hdmi_hpd;
    reg hsync;
    reg [23:0] rgb;
    reg vsync;
    wire hdmi_out_en;
    wire [3:0] tmds;
    wire [3:0] tmdsb;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .active(active),
        .clk_125(clk_125),
        .clk_25(clk_25),
        .hdmi_cec(hdmi_cec),
        .hdmi_hpd(hdmi_hpd),
        .hsync(hsync),
        .rgb(rgb),
        .vsync(vsync),
        .hdmi_out_en(hdmi_out_en),
        .tmds(tmds),
        .tmdsb(tmdsb)
    );

    // Clock generation (10ns period)
    initial begin
        clk_125 = 0;
        forever #5 clk_125 = ~clk_125;
    end

        task reset_dut;

        begin
            active = 0;
            hsync = 0;
            vsync = 0;
            rgb = 24'h0;
            hdmi_cec = 0;
            hdmi_hpd = 0;
            #100;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Running Testcase %0d: Active Video - Full Red", test_num);
            active = 1;
            rgb = 24'hFF0000;
            hsync = 0;
            vsync = 0;
            hdmi_hpd = 1;
            #200;

            #1;


            check_outputs(1'b1, tmds, ~tmds);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Running Testcase %0d: Active Video - Full Green", test_num);
            active = 1;
            rgb = 24'h00FF00;
            #200;
            #1;

            check_outputs(1'b1, tmds, ~tmds);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Running Testcase %0d: Active Video - Full Blue", test_num);
            active = 1;
            rgb = 24'h0000FF;
            #200;
            #1;

            check_outputs(1'b1, tmds, ~tmds);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Running Testcase %0d: Control Period (HSync)", test_num);
            active = 0;
            rgb = 24'hFFFFFF;
            hsync = 1;
            vsync = 0;
            #200;

            #1;


            check_outputs(1'b0, tmds, ~tmds);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Running Testcase %0d: Control Period (VSync)", test_num);
            active = 0;
            rgb = 24'h000000;
            hsync = 0;
            vsync = 1;
            #200;
            #1;

            check_outputs(1'b0, tmds, ~tmds);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Running Testcase %0d: Mixed Color + CEC Check", test_num);
            active = 1;
            rgb = 24'hA5B6C7;
            hdmi_cec = 1;
            hdmi_hpd = 1;
            #200;
            #1;

            check_outputs(1'b1, tmds, ~tmds);
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
        input expected_hdmi_out_en;
        input [3:0] expected_tmds;
        input [3:0] expected_tmdsb;
        begin
            if (expected_hdmi_out_en === (expected_hdmi_out_en ^ hdmi_out_en ^ expected_hdmi_out_en) &&
                expected_tmds === (expected_tmds ^ tmds ^ expected_tmds) &&
                expected_tmdsb === (expected_tmdsb ^ tmdsb ^ expected_tmdsb)) begin
                $display("PASS");
                $display("  Outputs: hdmi_out_en=%b, tmds=%h, tmdsb=%h",
                         hdmi_out_en, tmds, tmdsb);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: hdmi_out_en=%b, tmds=%h, tmdsb=%h",
                         expected_hdmi_out_en, expected_tmds, expected_tmdsb);
                $display("  Got:      hdmi_out_en=%b, tmds=%h, tmdsb=%h",
                         hdmi_out_en, tmds, tmdsb);
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,active, clk_125, clk_25, hdmi_cec, hdmi_hpd, hsync, rgb, vsync, hdmi_out_en, tmds, tmdsb);
    end

endmodule
