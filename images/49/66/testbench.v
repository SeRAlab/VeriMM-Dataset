`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk_vga;
    wire [9:0] hc_visible;
    wire hs;
    wire [9:0] vc_visible;
    wire vs;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk_vga(clk_vga),
        .hc_visible(hc_visible),
        .hs(hs),
        .vc_visible(vc_visible),
        .vs(vs)
    );

    // Clock generation (10ns period)
    initial begin
        clk_vga = 0;
        forever #5 clk_vga = ~clk_vga;
    end

        task reset_dut;

        begin


            $display("--- Reset/Syncing Testcase %0d ---", test_num);
        end
        endtask
    task advance_to_abs_cycle;

        input integer target;
        begin
            while (total_clk_count < target) begin
                @(posedge clk_vga);
                total_clk_count = total_clk_count + 1;
            end
            #1;
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            advance_to_abs_cycle(1);
            #1;

            check_outputs(10'd0, 1'b1, 10'd0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            advance_to_abs_cycle(640);
            #1;

            check_outputs(10'd639, 1'b1, 10'd0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            advance_to_abs_cycle(657);
            #1;

            check_outputs(10'd0, 1'b0, 10'd0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            advance_to_abs_cycle(752);
            #1;

            check_outputs(10'd0, 1'b0, 10'd0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            advance_to_abs_cycle(801);
            #1;

            check_outputs(10'd0, 1'b1, 10'd1, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            advance_to_abs_cycle(383840);
            #1;

            check_outputs(10'd639, 1'b1, 10'd479, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            advance_to_abs_cycle(392001);
            #1;

            check_outputs(10'd0, 1'b1, 10'd0, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            reset_dut();
            advance_to_abs_cycle(392657);
            #1;

            check_outputs(10'd0, 1'b0, 10'd0, 1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            reset_dut();
            advance_to_abs_cycle(420000);
            #1;

            check_outputs(10'd0, 1'b1, 10'd0, 1'b1);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            reset_dut();
            advance_to_abs_cycle(420001);
            #1;

            check_outputs(10'd0, 1'b1, 10'd0, 1'b1);
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
        input [9:0] expected_hc_visible;
        input expected_hs;
        input [9:0] expected_vc_visible;
        input expected_vs;
        begin
            if (expected_hc_visible === (expected_hc_visible ^ hc_visible ^ expected_hc_visible) &&
                expected_hs === (expected_hs ^ hs ^ expected_hs) &&
                expected_vc_visible === (expected_vc_visible ^ vc_visible ^ expected_vc_visible) &&
                expected_vs === (expected_vs ^ vs ^ expected_vs)) begin
                $display("PASS");
                $display("  Outputs: hc_visible=%h, hs=%b, vc_visible=%h, vs=%b",
                         hc_visible, hs, vc_visible, vs);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: hc_visible=%h, hs=%b, vc_visible=%h, vs=%b",
                         expected_hc_visible, expected_hs, expected_vc_visible, expected_vs);
                $display("  Got:      hc_visible=%h, hs=%b, vc_visible=%h, vs=%b",
                         hc_visible, hs, vc_visible, vs);
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
        $dumpvars(0,clk_vga, hc_visible, hs, vc_visible, vs);
    end

endmodule
