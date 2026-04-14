`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clear;
    reg clock;
    reg gld;
    reg [5:0] xin;
    reg xld;
    reg xselect;
    reg [5:0] yin;
    reg yld;
    reg yselect;
    wire eqflag;
    wire [5:0] gcd;
    wire ltflag;
    wire onezeroflag;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clear(clear),
        .clock(clock),
        .gld(gld),
        .xin(xin),
        .xld(xld),
        .xselect(xselect),
        .yin(yin),
        .yld(yld),
        .yselect(yselect),
        .eqflag(eqflag),
        .gcd(gcd),
        .ltflag(ltflag),
        .onezeroflag(onezeroflag)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            clear = 1;
            xin = 0;
            yin = 0;
            xld = 0;
            yld = 0;
            gld = 0;
            xselect = 0;
            yselect = 0;
            @(posedge clock);
            #1 clear = 0;
            @(posedge clock);
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: GCD(12, 18)");
            reset_dut();

            xin = 12; yin = 18; xselect = 1; yselect = 1; xld = 1; yld = 1;
            @(posedge clock);


            #1 xld = 0; yld = 1; xselect = 0; yselect = 0;
            @(posedge clock);

            #1 xld = 1; yld = 0;
            @(posedge clock);

            #1 xld = 0; yld = 0; gld = 1;
            @(posedge clock);
            #1 gld = 0;
            #1;

            check_outputs(1'b1, 6'd6, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: GCD(15, 5)");
            reset_dut();

            xin = 15; yin = 5; xselect = 1; yselect = 1; xld = 1; yld = 1;
            @(posedge clock);

            #1 xld = 1; yld = 0; xselect = 0; yselect = 0;
            @(posedge clock);

            #1 xld = 1; yld = 0;
            @(posedge clock);

            #1 xld = 0; yld = 0; gld = 1;
            @(posedge clock);
            #1 gld = 0;
            #1;

            check_outputs(1'b1, 6'd5, 1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: GCD(9, 6)");
            reset_dut();

            xin = 9; yin = 6; xselect = 1; yselect = 1; xld = 1; yld = 1;
            @(posedge clock);

            #1 xld = 1; yld = 0; xselect = 0; yselect = 0;
            @(posedge clock);

            #1 xld = 0; yld = 1;
            @(posedge clock);

            #1 xld = 0; yld = 0; gld = 1;
            @(posedge clock);
            #1 gld = 0;
            #1;

            check_outputs(1'b1, 6'd3, 1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: GCD(24, 24)");
            reset_dut();

            xin = 24; yin = 24; xselect = 1; yselect = 1; xld = 1; yld = 1;
            @(posedge clock);

            #1 xld = 0; yld = 0; gld = 1;
            @(posedge clock);
            #1 gld = 0;
            #1;

            check_outputs(1'b1, 6'd24, 1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Zero Flag Check (0, 10)");
            reset_dut();

            xin = 0; yin = 10; xselect = 1; yselect = 1; xld = 1; yld = 1;
            @(posedge clock);

            #1 xld = 0; yld = 0;
            #1;

            check_outputs(1'b0, 6'bxxxxxx, 1'b1, 1'b1);
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
        input expected_eqflag;
        input [5:0] expected_gcd;
        input expected_ltflag;
        input expected_onezeroflag;
        begin
            if (expected_eqflag === (expected_eqflag ^ eqflag ^ expected_eqflag) &&
                expected_gcd === (expected_gcd ^ gcd ^ expected_gcd) &&
                expected_ltflag === (expected_ltflag ^ ltflag ^ expected_ltflag) &&
                expected_onezeroflag === (expected_onezeroflag ^ onezeroflag ^ expected_onezeroflag)) begin
                $display("PASS");
                $display("  Outputs: eqflag=%b, gcd=%h, ltflag=%b, onezeroflag=%b",
                         eqflag, gcd, ltflag, onezeroflag);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: eqflag=%b, gcd=%h, ltflag=%b, onezeroflag=%b",
                         expected_eqflag, expected_gcd, expected_ltflag, expected_onezeroflag);
                $display("  Got:      eqflag=%b, gcd=%h, ltflag=%b, onezeroflag=%b",
                         eqflag, gcd, ltflag, onezeroflag);
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
        $dumpvars(0,clear, clock, gld, xin, xld, xselect, yin, yld, yselect, eqflag, gcd, ltflag, onezeroflag);
    end

endmodule
