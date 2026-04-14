`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clkvga;
    wire active;
    wire [10:0] hc;
    wire hs;
    wire [10:0] vc;
    wire vs;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clkvga(clkvga),
        .active(active),
        .hc(hc),
        .hs(hs),
        .vc(vc),
        .vs(vs)
    );

    // Clock generation (10ns period)
    initial begin
        clkvga = 0;
        forever #5 clkvga = ~clkvga;
    end

        task reset_dut;

        begin
            force dut.hc = 0;
            force dut.vc = 0;
            force dut.hs = 0;
            force dut.vs = 0;
            force dut.active = 1;
            #12;
            release dut.hc;
            release dut.vc;
            release dut.hs;
            release dut.vs;
            release dut.active;
            #8;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Initial Active State");
            reset_dut();
            @(posedge clkvga);

            #1;


            check_outputs(1'b1, 11'd1, 1'b0, 11'd0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Transition to Horizontal Blanking");
            reset_dut();
            repeat(640) @(posedge clkvga);

            #1;


            check_outputs(1'b0, 11'd640, 1'b0, 11'd0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Horizontal Sync Pulse Start");
            reset_dut();
            repeat(656) @(posedge clkvga);

            #1;


            check_outputs(1'b0, 11'd656, 1'b1, 11'd0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Line Wrap and Vertical Increment");
            reset_dut();
            repeat(800) @(posedge clkvga);

            #1;


            check_outputs(1'b1, 11'd0, 1'b0, 11'd1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Vertical Blanking Boundary");
            reset_dut();
            repeat(800 * 480) @(posedge clkvga);

            #1;


            check_outputs(1'b0, 11'd0, 1'b0, 11'd480, 1'b0);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Vertical Sync Pulse Start");
            reset_dut();
            repeat(800 * 490) @(posedge clkvga);

            #1;


            check_outputs(1'b0, 11'd0, 1'b0, 11'd490, 1'b1);
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
        input expected_active;
        input [10:0] expected_hc;
        input expected_hs;
        input [10:0] expected_vc;
        input expected_vs;
        begin
            if (expected_active === (expected_active ^ active ^ expected_active) &&
                expected_hc === (expected_hc ^ hc ^ expected_hc) &&
                expected_hs === (expected_hs ^ hs ^ expected_hs) &&
                expected_vc === (expected_vc ^ vc ^ expected_vc) &&
                expected_vs === (expected_vs ^ vs ^ expected_vs)) begin
                $display("PASS");
                $display("  Outputs: active=%b, hc=%h, hs=%b, vc=%h, vs=%b",
                         active, hc, hs, vc, vs);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: active=%b, hc=%h, hs=%b, vc=%h, vs=%b",
                         expected_active, expected_hc, expected_hs, expected_vc, expected_vs);
                $display("  Got:      active=%b, hc=%h, hs=%b, vc=%h, vs=%b",
                         active, hc, hs, vc, vs);
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
        $dumpvars(0,clkvga, active, hc, hs, vc, vs);
    end

endmodule
