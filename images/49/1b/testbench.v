`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [5:0] detune_signed;
    reg [3:0] mul;
    reg pg_rst;
    reg [19:0] phase_in;
    reg [16:0] phinc_pure;
    wire [9:0] phase_op;
    wire [19:0] phase_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .detune_signed(detune_signed),
        .mul(mul),
        .pg_rst(pg_rst),
        .phase_in(phase_in),
        .phinc_pure(phinc_pure),
        .phase_op(phase_op),
        .phase_out(phase_out)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: Reset Priority", test_num);
        pg_rst = 1;
        mul = 4'hF;
        phase_in = 20'hFFFFF;
        detune_signed = 6'd31;
        phinc_pure = 17'h1FFFF;
        #10;
        #1;

        check_outputs(10'h000, 20'h00000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: Basic Increment", test_num);
        pg_rst = 1; #5; pg_rst = 0;
        mul = 4'd1;
        phase_in = 20'd0;
        detune_signed = 6'd0;
        phinc_pure = 17'd1000;
        #10;
        #1;

        check_outputs(10'h000, 20'h003E8);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: Multiplier logic", test_num);
        pg_rst = 1; #5; pg_rst = 0;
        mul = 4'd4;
        phase_in = 20'd1000;
        detune_signed = 6'd0;
        phinc_pure = 17'd1000;
        #10;

        #1;


        check_outputs(10'h004, 20'h01388);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: phase_op boundary", test_num);
        pg_rst = 1; #5; pg_rst = 0;
        mul = 4'd1;
        phase_in = 20'd0;
        detune_signed = 6'd24;
        phinc_pure = 17'd1000;
        #10;

        #1;


        check_outputs(10'h001, 20'h00400);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %0d: Positive Detune", test_num);
        pg_rst = 1; #5; pg_rst = 0;
        mul = 4'd2;
        phase_in = 20'd500;
        detune_signed = 6'd10;
        phinc_pure = 17'd100;
        #10;

        #1;


        check_outputs(10'h000, 20'h002D0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case %0d: Negative Detune (Positive step)", test_num);
        pg_rst = 1; #5; pg_rst = 0;
        mul = 4'd2;
        phase_in = 20'd1000;
        detune_signed = -6'd10;
        phinc_pure = 17'd100;
        #10;

        #1;


        check_outputs(10'h001, 20'h0049C);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case %0d: Negative Detune (Negative step/Subtraction)", test_num);
        pg_rst = 1; #5; pg_rst = 0;
        mul = 4'd2;
        phase_in = 20'd1000;
        detune_signed = -6'd20;
        phinc_pure = 17'd10;
        #10;

        #1;


        check_outputs(10'h000, 20'h003D4);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test Case %0d: Accumulator Wrapping", test_num);
        pg_rst = 1; #5; pg_rst = 0;
        mul = 4'd1;
        phase_in = 20'hFFFF0;
        detune_signed = 6'd0;
        phinc_pure = 17'h00020;
        #10;

        #1;


        check_outputs(10'h000, 20'h00010);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test Case %0d: Large step and wrap", test_num);
        pg_rst = 1; #5; pg_rst = 0;
        mul = 4'd15;
        phase_in = 20'h80000;
        detune_signed = 6'd0;
        phinc_pure = 17'h10000;
        #10;



        #1;




        check_outputs(10'h1C0, 20'h70000);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Test Case %0d: Multiplier Zero", test_num);
        pg_rst = 1; #5; pg_rst = 0;
        mul = 4'd0;
        phase_in = 20'hABCDE;
        detune_signed = 6'd31;
        phinc_pure = 17'h1FFFF;
        #10;

        #1;


        check_outputs(10'h2AF, 20'hABCDE);
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
        input [9:0] expected_phase_op;
        input [19:0] expected_phase_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_phase_op === (expected_phase_op ^ phase_op ^ expected_phase_op) &&
                expected_phase_out === (expected_phase_out ^ phase_out ^ expected_phase_out)) begin
                $display("PASS");
                $display("  Outputs: phase_op=%h, phase_out=%h",
                         phase_op, phase_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: phase_op=%h, phase_out=%h",
                         expected_phase_op, expected_phase_out);
                $display("  Got:      phase_op=%h, phase_out=%h",
                         phase_op, phase_out);
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
