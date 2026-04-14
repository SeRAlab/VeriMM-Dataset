`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg c_pad;
    reg clock;
    reg d_pad;
    reg e_pad;
    reg f_pad;
    reg g_pad;
    reg reset;
    wire c_pad_sync;
    wire d_pad_sync;
    wire e_pad_sync;
    wire f_pad_sync;
    wire g_pad_sync;
    wire pad_touched;
    wire reset_sync;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .c_pad(c_pad),
        .clock(clock),
        .d_pad(d_pad),
        .e_pad(e_pad),
        .f_pad(f_pad),
        .g_pad(g_pad),
        .reset(reset),
        .c_pad_sync(c_pad_sync),
        .d_pad_sync(d_pad_sync),
        .e_pad_sync(e_pad_sync),
        .f_pad_sync(f_pad_sync),
        .g_pad_sync(g_pad_sync),
        .pad_touched(pad_touched),
        .reset_sync(reset_sync)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            reset = 1;
            c_pad = 0;
            d_pad = 0;
            e_pad = 0;
            f_pad = 0;
            g_pad = 0;
            @(posedge clock);
            #1;
            reset = 0;
            @(posedge clock);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Post-Reset Idle State", test_num);
            reset_dut();


            #1;



            check_outputs(0, 0, 0, 0, 0, 0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Single Pad Activation (C)", test_num);
            reset_dut();
            c_pad = 1;
            @(posedge clock);
            #1;

            #1;


            check_outputs(1, 0, 0, 0, 0, 1, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Single Pad Activation (G)", test_num);
            reset_dut();
            g_pad = 1;
            @(posedge clock);
            #1;

            #1;


            check_outputs(0, 0, 0, 0, 1, 1, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Multiple Pad Activation (D, E, F)", test_num);
            reset_dut();
            d_pad = 1;
            e_pad = 1;
            f_pad = 1;
            @(posedge clock);
            #1;

            #1;


            check_outputs(0, 1, 1, 1, 0, 1, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: All Pads Activation", test_num);
            reset_dut();
            c_pad = 1; d_pad = 1; e_pad = 1; f_pad = 1; g_pad = 1;
            @(posedge clock);
            #1;
            #1;

            check_outputs(1, 1, 1, 1, 1, 1, 0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Signal Deactivation", test_num);
            reset_dut();

            c_pad = 1;
            @(posedge clock);
            #1;

            c_pad = 0;
            @(posedge clock);
            #1;

            #1;


            check_outputs(0, 0, 0, 0, 0, 0, 0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Reset Sync Verification", test_num);
            reset_dut();
            reset = 1;
            @(posedge clock);
            #1;

            #1;


            check_outputs(0, 0, 0, 0, 0, 0, 1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Complex Toggling", test_num);
            reset_dut();
            c_pad = 1;
            @(posedge clock);
            #1;
            c_pad = 0;
            d_pad = 1;
            @(posedge clock);
            #1;

            #1;


            check_outputs(0, 1, 0, 0, 0, 1, 0);
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
        input expected_c_pad_sync;
        input expected_d_pad_sync;
        input expected_e_pad_sync;
        input expected_f_pad_sync;
        input expected_g_pad_sync;
        input expected_pad_touched;
        input expected_reset_sync;
        begin
            if (expected_c_pad_sync === (expected_c_pad_sync ^ c_pad_sync ^ expected_c_pad_sync) &&
                expected_d_pad_sync === (expected_d_pad_sync ^ d_pad_sync ^ expected_d_pad_sync) &&
                expected_e_pad_sync === (expected_e_pad_sync ^ e_pad_sync ^ expected_e_pad_sync) &&
                expected_f_pad_sync === (expected_f_pad_sync ^ f_pad_sync ^ expected_f_pad_sync) &&
                expected_g_pad_sync === (expected_g_pad_sync ^ g_pad_sync ^ expected_g_pad_sync) &&
                expected_pad_touched === (expected_pad_touched ^ pad_touched ^ expected_pad_touched) &&
                expected_reset_sync === (expected_reset_sync ^ reset_sync ^ expected_reset_sync)) begin
                $display("PASS");
                $display("  Outputs: c_pad_sync=%b, d_pad_sync=%b, e_pad_sync=%b, f_pad_sync=%b, g_pad_sync=%b, pad_touched=%b, reset_sync=%b",
                         c_pad_sync, d_pad_sync, e_pad_sync, f_pad_sync, g_pad_sync, pad_touched, reset_sync);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: c_pad_sync=%b, d_pad_sync=%b, e_pad_sync=%b, f_pad_sync=%b, g_pad_sync=%b, pad_touched=%b, reset_sync=%b",
                         expected_c_pad_sync, expected_d_pad_sync, expected_e_pad_sync, expected_f_pad_sync, expected_g_pad_sync, expected_pad_touched, expected_reset_sync);
                $display("  Got:      c_pad_sync=%b, d_pad_sync=%b, e_pad_sync=%b, f_pad_sync=%b, g_pad_sync=%b, pad_touched=%b, reset_sync=%b",
                         c_pad_sync, d_pad_sync, e_pad_sync, f_pad_sync, g_pad_sync, pad_touched, reset_sync);
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
        $dumpvars(0,c_pad, clock, d_pad, e_pad, f_pad, g_pad, reset, c_pad_sync, d_pad_sync, e_pad_sync, f_pad_sync, g_pad_sync, pad_touched, reset_sync);
    end

endmodule
