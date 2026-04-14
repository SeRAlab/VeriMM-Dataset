`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [10:0] BALL_H;
    reg [10:0] BALL_V;
    reg CLOCK;
    reg RESET;
    wire [7:0] POSITION;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .BALL_H(BALL_H),
        .BALL_V(BALL_V),
        .CLOCK(CLOCK),
        .RESET(RESET),
        .POSITION(POSITION)
    );

    // Clock generation (10ns period)
    initial begin
        CLOCK = 0;
        forever #5 CLOCK = ~CLOCK;
    end

        task reset_dut;

        begin
            RESET = 1;
            BALL_H = 0;
            BALL_V = 0;
            @(posedge CLOCK);
            #1;
            RESET = 0;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Reset Logic");
            reset_dut();

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Minimum dynamic range (BALL_V=33)");
            reset_dut();
            BALL_V = 11'd33;
            BALL_H = 11'd100;
            @(posedge CLOCK);
            #1;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Small value (BALL_V=34)");
            reset_dut();
            BALL_V = 11'd34;
            BALL_H = 11'd100;
            @(posedge CLOCK);
            #1;
            #1;

            check_outputs(8'h01);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Mid-range value (BALL_V=132)");
            reset_dut();
            BALL_V = 11'd132;
            BALL_H = 11'd200;
            @(posedge CLOCK);
            #1;
            #1;

            check_outputs(8'h32);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Maximum dynamic range (BALL_V=431)");
            reset_dut();
            BALL_V = 11'd431;
            BALL_H = 11'd300;
            @(posedge CLOCK);
            #1;
            #1;

            check_outputs(8'hC7);
        end
        endtask

    task testcase006;

        begin
            $display("Running testcase006: Outside range low (BALL_V=32)");
            reset_dut();
            BALL_V = 11'd32;
            BALL_H = 11'd50;
            @(posedge CLOCK);
            #1;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase007;

        begin
            $display("Running testcase007: Outside range high (BALL_V=432)");
            reset_dut();

            BALL_V = 11'd132;
            @(posedge CLOCK);
            #1;

            BALL_V = 11'd432;
            @(posedge CLOCK);
            #1;

            #1;


            check_outputs(8'h32);
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
        input [7:0] expected_POSITION;
        begin
            if (expected_POSITION === (expected_POSITION ^ POSITION ^ expected_POSITION)) begin
                $display("PASS");
                $display("  Outputs: POSITION=%h",
                         POSITION);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: POSITION=%h",
                         expected_POSITION);
                $display("  Got:      POSITION=%h",
                         POSITION);
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
        $dumpvars(0,BALL_H, BALL_V, CLOCK, RESET, POSITION);
    end

endmodule
