`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] control;
    reg display_sel;
    reg [3:0] num_in;
    wire [6:0] seg_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .control(control),
        .display_sel(display_sel),
        .num_in(num_in),
        .seg_out(seg_out)
    );
    task testcase001;

    begin
        $display("Test 001: BCD Mode (00), num_in=0, display_sel=0");
        control = 2'b00;
        display_sel = 1'b0;
        num_in = 4'd0;
        #1;

        check_outputs(7'h3f);
    end
        endtask

    task testcase002;

    begin
        $display("Test 002: BCD Mode (00), num_in=9, display_sel=0");
        control = 2'b00;
        display_sel = 1'b0;
        num_in = 4'd9;
        #1;

        check_outputs(7'h6f);
    end
        endtask

    task testcase003;

    begin
        $display("Test 003: BCD Mode (01), num_in=5, display_sel=0");
        control = 2'b01;
        display_sel = 1'b0;
        num_in = 4'd5;
        #1;

        check_outputs(7'h6d);
    end
        endtask

    task testcase004;

    begin
        $display("Test 004: Hex Mode (10), num_in=10 (A), display_sel=0");
        control = 2'b10;
        display_sel = 1'b0;
        num_in = 4'd10;
        #1;

        check_outputs(7'h77);
    end
        endtask

    task testcase005;

    begin
        $display("Test 005: Hex Mode (10), num_in=15 (F), display_sel=0");
        control = 2'b10;
        display_sel = 1'b0;
        num_in = 4'd15;
        #1;

        check_outputs(7'h71);
    end
        endtask

    task testcase006;

    begin
        $display("Test 006: Hex Mode (10), num_in=3, display_sel=0");
        control = 2'b10;
        display_sel = 1'b0;
        num_in = 4'd3;
        #1;

        check_outputs(7'h4f);
    end
        endtask

    task testcase007;

    begin
        $display("Test 007: BCD Mode (00), num_in=12 (Invalid), display_sel=0");
        control = 2'b00;
        display_sel = 1'b0;
        num_in = 4'd12;
        #1;

        check_outputs(7'h00);
    end
        endtask

    task testcase008;

    begin
        $display("Test 008: Hex Mode (10), num_in=11 (b), display_sel=0");
        control = 2'b10;
        display_sel = 1'b0;
        num_in = 4'd11;
        #1;

        check_outputs(7'h7c);
    end
        endtask

    task testcase009;

    begin
        $display("Test 009: Hex Mode (10), num_in=8, display_sel=1");
        control = 2'b10;
        display_sel = 1'b1;
        num_in = 4'd8;


        #1;



        check_outputs(7'h7f);
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
        input [6:0] expected_seg_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_seg_out === (expected_seg_out ^ seg_out ^ expected_seg_out)) begin
                $display("PASS");
                $display("  Outputs: seg_out=%h",
                         seg_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: seg_out=%h",
                         expected_seg_out);
                $display("  Got:      seg_out=%h",
                         seg_out);
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
