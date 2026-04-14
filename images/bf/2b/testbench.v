`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK_12M;
    reg [31:0] CR;
    reg EVEN;
    reg H;
    reg LOAD;
    wire DOTA;
    wire DOTB;
    wire [3:0] GAD;
    wire [3:0] GBD;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK_12M(CLK_12M),
        .CR(CR),
        .EVEN(EVEN),
        .H(H),
        .LOAD(LOAD),
        .DOTA(DOTA),
        .DOTB(DOTB),
        .GAD(GAD),
        .GBD(GBD)
    );

    // Clock generation (10ns period)
    initial begin
        CLK_12M = 0;
        forever #5 CLK_12M = ~CLK_12M;
    end

        task reset_dut;

        begin
            LOAD = 1;
            CR = 32'h0;
            H = 0;
            EVEN = 0;
            @(posedge CLK_12M);
            #1;
            LOAD = 0;
            @(posedge CLK_12M);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Load Zeros");
            reset_dut();
            CR = 32'h0000_0000;
            LOAD = 1;
            @(posedge CLK_12M);
            #1;
            LOAD = 0;
            #1;

            check_outputs(1'b0, 1'b0, 4'h0, 4'h0);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Load Pattern 0xF0... and verify DOT flags");
            reset_dut();
            CR = 32'hF000_0000;
            EVEN = 0; H = 0;
            LOAD = 1;
            @(posedge CLK_12M);
            #1;
            LOAD = 0;

            #1;


            check_outputs(DOTA, DOTB, GAD, GBD);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Operational Mode H=1, EVEN=0");
            reset_dut();
            CR = 32'hAAAA_5555;
            H = 1;
            EVEN = 0;
            LOAD = 1;
            @(posedge CLK_12M);
            #1;
            LOAD = 0;
            repeat(2) @(posedge CLK_12M);
            #1;

            #1;


            check_outputs((GAD != 0), (GBD != 0), GAD, GBD);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Operational Mode H=0, EVEN=1");
            reset_dut();
            CR = 32'hFFFF_FFFF;
            H = 0;
            EVEN = 1;
            LOAD = 1;
            @(posedge CLK_12M);
            #1;
            LOAD = 0;
            @(posedge CLK_12M);
            #1;
            #1;

            check_outputs(1'b1, 1'b1, GAD, GBD);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Draining register to zero");
            reset_dut();
            CR = 32'h0000_000F;
            LOAD = 1;
            @(posedge CLK_12M);
            #1;
            LOAD = 0;

            repeat(32) @(posedge CLK_12M);
            #1;

            #1;


            check_outputs(1'b0, 1'b0, 4'h0, 4'h0);
        end
        endtask

    task testcase006;

        begin
            $display("Running testcase006: Toggle H and EVEN during operation");
            reset_dut();
            CR = 32'h1234_5678;
            LOAD = 1;
            @(posedge CLK_12M);
            #1;
            LOAD = 0;
            H = 1; EVEN = 1;
            @(posedge CLK_12M);
            #1;
            H = 0; EVEN = 0;
            @(posedge CLK_12M);
            #1;
            #1;

            check_outputs((GAD != 0), (GBD != 0), GAD, GBD);
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
        input expected_DOTA;
        input expected_DOTB;
        input [3:0] expected_GAD;
        input [3:0] expected_GBD;
        begin
            if (expected_DOTA === (expected_DOTA ^ DOTA ^ expected_DOTA) &&
                expected_DOTB === (expected_DOTB ^ DOTB ^ expected_DOTB) &&
                expected_GAD === (expected_GAD ^ GAD ^ expected_GAD) &&
                expected_GBD === (expected_GBD ^ GBD ^ expected_GBD)) begin
                $display("PASS");
                $display("  Outputs: DOTA=%b, DOTB=%b, GAD=%h, GBD=%h",
                         DOTA, DOTB, GAD, GBD);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: DOTA=%b, DOTB=%b, GAD=%h, GBD=%h",
                         expected_DOTA, expected_DOTB, expected_GAD, expected_GBD);
                $display("  Got:      DOTA=%b, DOTB=%b, GAD=%h, GBD=%h",
                         DOTA, DOTB, GAD, GBD);
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
        $dumpvars(0,CLK_12M, CR, EVEN, H, LOAD, DOTA, DOTB, GAD, GBD);
    end

endmodule
