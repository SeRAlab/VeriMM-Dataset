`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg clock;
    reg [31:0] i_datain;
    reg i_datain_valid;
    reg i_dataout_stall;
    reg [31:0] i_register_settings;
    reg i_settings;
    reg resetn;
    wire o_datain_stall;
    wire [31:0] o_dataout;
    wire o_dataout_valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .i_datain(i_datain),
        .i_datain_valid(i_datain_valid),
        .i_dataout_stall(i_dataout_stall),
        .i_register_settings(i_register_settings),
        .i_settings(i_settings),
        .resetn(resetn),
        .o_datain_stall(o_datain_stall),
        .o_dataout(o_dataout),
        .o_dataout_valid(o_dataout_valid)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Bypass Mode (Data pass-through)", test_num);
            resetn = 0;
            i_settings = 0;
            i_datain = 32'h0;
            i_datain_valid = 0;
            i_dataout_stall = 0;
            i_register_settings = 32'hCAFE_BABE;
            #20 resetn = 1;

            @(posedge clock);
            i_settings = 0;
            i_datain = 32'hA5A5_B6B6;
            i_datain_valid = 1;

            @(posedge clock);
            #1;

            check_outputs(0, 32'hA5A5_B6B6, 1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Register Settings Mode", test_num);
            resetn = 0;
            #20 resetn = 1;

            @(posedge clock);
            i_settings = 1;
            i_register_settings = 32'h1234_5678;
            i_datain = 32'hFFFF_FFFF;
            i_datain_valid = 1;
            i_dataout_stall = 0;

            @(posedge clock);
            #1;

            check_outputs(0, 32'h1234_5678, 1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Validity Gating", test_num);
            resetn = 0;
            #20 resetn = 1;

            @(posedge clock);
            i_settings = 0;
            i_datain = 32'h1122_3344;
            i_datain_valid = 0;
            i_dataout_stall = 0;

            @(posedge clock);
            #1;

            check_outputs(0, 32'h1122_3344, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Stall Signal Flow Control", test_num);
            resetn = 0;
            #20 resetn = 1;

            @(posedge clock);
            i_dataout_stall = 1;
            i_datain_valid = 1;
            i_settings = 0;
            i_datain = 32'hDEAD_BEEF;

            @(posedge clock);
            #1;

            check_outputs(1, 32'hDEAD_BEEF, 1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Settings Mode with Stall and Invalid Valid", test_num);
            resetn = 0;
            #20 resetn = 1;

            @(posedge clock);
            i_settings = 1;
            i_register_settings = 32'h0000_9999;
            i_datain_valid = 0;
            i_dataout_stall = 1;

            @(posedge clock);
            #1;

            check_outputs(1, 32'h0000_9999, 0);
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
        input expected_o_datain_stall;
        input [31:0] expected_o_dataout;
        input expected_o_dataout_valid;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_o_datain_stall === (expected_o_datain_stall ^ o_datain_stall ^ expected_o_datain_stall) &&
                expected_o_dataout === (expected_o_dataout ^ o_dataout ^ expected_o_dataout) &&
                expected_o_dataout_valid === (expected_o_dataout_valid ^ o_dataout_valid ^ expected_o_dataout_valid)) begin
                $display("PASS");
                $display("  Outputs: o_datain_stall=%b, o_dataout=%h, o_dataout_valid=%b",
                         o_datain_stall, o_dataout, o_dataout_valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o_datain_stall=%b, o_dataout=%h, o_dataout_valid=%b",
                         expected_o_datain_stall, expected_o_dataout, expected_o_dataout_valid);
                $display("  Got:      o_datain_stall=%b, o_dataout=%h, o_dataout_valid=%b",
                         o_datain_stall, o_dataout, o_dataout_valid);
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
