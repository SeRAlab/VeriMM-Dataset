`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg Clock;
    reg [3:0] iBits_a_correr;
    reg [7:0] iRegistro;
    wire [7:0] oRegistro_corrido;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Clock(Clock),
        .iBits_a_correr(iBits_a_correr),
        .iRegistro(iRegistro),
        .oRegistro_corrido(oRegistro_corrido)
    );

    // Clock generation (10ns period)
    initial begin
        Clock = 0;
        forever #5 Clock = ~Clock;
    end

        task reset_dut;

        begin
            iBits_a_correr = 4'd0;
            iRegistro = 8'd0;
            @(posedge Clock);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            iRegistro = 8'hAA;
            iBits_a_correr = 4'd0;
            @(posedge Clock);
            #1;
            $display("Test Case 001: Shift 0 bits");
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            iRegistro = 8'h01;
            iBits_a_correr = 4'd1;
            @(posedge Clock);
            #1;
            $display("Test Case 002: Shift 1 bit");
            #1;

            check_outputs(8'h02);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            iRegistro = 8'h0F;
            iBits_a_correr = 4'd4;
            @(posedge Clock);
            #1;
            $display("Test Case 003: Shift 4 bits");
            #1;

            check_outputs(8'hF0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            iRegistro = 8'h01;
            iBits_a_correr = 4'd7;
            @(posedge Clock);
            #1;
            $display("Test Case 004: Shift 7 bits");
            #1;

            check_outputs(8'h80);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            iRegistro = 8'hC3;
            iBits_a_correr = 4'd2;
            @(posedge Clock);
            #1;
            $display("Test Case 005: Shift 2 bits with overflow");
            #1;

            check_outputs(8'h0C);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = test_num + 1;
            iRegistro = 8'hFF;
            iBits_a_correr = 4'd8;
            @(posedge Clock);
            #1;
            $display("Test Case 006: Shift 8 bits (clear)");
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = test_num + 1;
            iRegistro = 8'hFF;
            iBits_a_correr = 4'd15;
            @(posedge Clock);
            #1;
            $display("Test Case 007: Shift 15 bits");
            #1;

            check_outputs(8'h00);
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
        input [7:0] expected_oRegistro_corrido;
        begin
            if (expected_oRegistro_corrido === (expected_oRegistro_corrido ^ oRegistro_corrido ^ expected_oRegistro_corrido)) begin
                $display("PASS");
                $display("  Outputs: oRegistro_corrido=%h",
                         oRegistro_corrido);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: oRegistro_corrido=%h",
                         expected_oRegistro_corrido);
                $display("  Got:      oRegistro_corrido=%h",
                         oRegistro_corrido);
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
        $dumpvars(0,Clock, iBits_a_correr, iRegistro, oRegistro_corrido);
    end

endmodule
