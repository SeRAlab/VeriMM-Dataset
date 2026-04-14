`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [11:0] A0;
    reg [11:0] X0;
    reg [11:0] Y0;
    reg [11:0] aRom;
    reg clock;
    reg ngreset;
    reg reset;
    reg strobeData;
    wire [11:0] AN;
    wire [11:0] XN;
    wire [11:0] YN;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A0(A0),
        .X0(X0),
        .Y0(Y0),
        .aRom(aRom),
        .clock(clock),
        .ngreset(ngreset),
        .reset(reset),
        .strobeData(strobeData),
        .AN(AN),
        .XN(XN),
        .YN(YN)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            reset = 1;
            ngreset = 1;
            strobeData = 0;
            A0 = 0;
            X0 = 0;
            Y0 = 0;
            aRom = 0;
            @(posedge clock);
            #1;
            reset = 0;
            ngreset = 0;
            @(posedge clock);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Test Case 001: Positive Angle Rotation");
            reset_dut();
            X0 = 12'h100;
            Y0 = 12'h000;
            A0 = 12'h050;
            aRom = 12'h030;
            strobeData = 1;
            @(posedge clock);
            strobeData = 0;
            repeat (5) @(posedge clock);


            #1;



            check_outputs(12'h020, 12'h100, 12'h100);
        end
        endtask

    task testcase002;

        begin
            $display("Test Case 002: Negative Angle Rotation");
            reset_dut();
            X0 = 12'h0C8;
            Y0 = 12'h032;
            A0 = 12'hFEC;
            aRom = 12'h032;
            strobeData = 1;
            @(posedge clock);
            strobeData = 0;
            repeat (5) @(posedge clock);


            #1;



            check_outputs(12'h01E, 12'h0FA, 12'hF6A);
        end
        endtask

    task testcase003;

        begin
            $display("Test Case 003: Zero Inputs");
            reset_dut();
            X0 = 12'h064;
            Y0 = 12'h000;
            A0 = 12'h000;
            aRom = 12'h010;
            strobeData = 1;
            @(posedge clock);
            strobeData = 0;
            repeat (5) @(posedge clock);


            #1;



            check_outputs(12'hFF0, 12'h064, 12'h064);
        end
        endtask

    task testcase004;

        begin
            $display("Test Case 004: Reset Verification");
            reset_dut();
            X0 = 12'hFFF;
            Y0 = 12'hFFF;
            strobeData = 1;
            @(posedge clock);
            reset = 1;
            @(posedge clock);
            reset = 0;
            repeat (2) @(posedge clock);


            #1;



            check_outputs(12'h000, 12'h000, 12'h000);
        end
        endtask

    task testcase005;

        begin
            $display("Test Case 005: Max Bit Adjustment");
            reset_dut();
            X0 = 12'h400;
            Y0 = 12'h000;
            A0 = 12'h200;
            aRom = 12'h400;
            strobeData = 1;
            @(posedge clock);
            strobeData = 0;
            repeat (5) @(posedge clock);


            #1;



            check_outputs(12'hE00, 12'h400, 12'h400);
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
        input [11:0] expected_AN;
        input [11:0] expected_XN;
        input [11:0] expected_YN;
        begin
            if (expected_AN === (expected_AN ^ AN ^ expected_AN) &&
                expected_XN === (expected_XN ^ XN ^ expected_XN) &&
                expected_YN === (expected_YN ^ YN ^ expected_YN)) begin
                $display("PASS");
                $display("  Outputs: AN=%h, XN=%h, YN=%h",
                         AN, XN, YN);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: AN=%h, XN=%h, YN=%h",
                         expected_AN, expected_XN, expected_YN);
                $display("  Got:      AN=%h, XN=%h, YN=%h",
                         AN, XN, YN);
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
        $dumpvars(0,A0, X0, Y0, aRom, clock, ngreset, reset, strobeData, AN, XN, YN);
    end

endmodule
