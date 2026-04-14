`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg B2;
    reg B3;
    reg B4;
    reg S1;
    reg S2;
    reg S3;
    reg clk;
    reg piso1;
    reg piso2;
    reg piso3;
    reg piso4;
    wire [3:0] boton_pres;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .B2(B2),
        .B3(B3),
        .B4(B4),
        .S1(S1),
        .S2(S2),
        .S3(S3),
        .clk(clk),
        .piso1(piso1),
        .piso2(piso2),
        .piso3(piso3),
        .piso4(piso4),
        .boton_pres(boton_pres)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            piso1 = 0; piso2 = 0; piso3 = 0; piso4 = 0;
            S1 = 0; B2 = 0; S2 = 0; B3 = 0; S3 = 0; B4 = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            piso1 = 1;
            @(posedge clk);
            #1;
            $display("Test Case 001: Floor 1 Button");
            #1;

            check_outputs(4'd1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            piso2 = 1;
            @(posedge clk);
            #1;
            $display("Test Case 002: Floor 2 Button");
            #1;

            check_outputs(4'd2);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            piso3 = 1;
            @(posedge clk);
            #1;
            $display("Test Case 003: Floor 3 Button");
            #1;

            check_outputs(4'd3);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            piso4 = 1;
            @(posedge clk);
            #1;
            $display("Test Case 004: Floor 4 Button");
            #1;

            check_outputs(4'd4);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            S1 = 1;
            @(posedge clk);
            #1;
            $display("Test Case 005: Control S1");
            #1;

            check_outputs(4'd5);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            B2 = 1;
            @(posedge clk);
            #1;
            $display("Test Case 006: Control B2");
            #1;

            check_outputs(4'd6);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = 7;
            S2 = 1;
            @(posedge clk);
            #1;
            $display("Test Case 007: Control S2");
            #1;

            check_outputs(4'd7);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            test_num = 8;
            B3 = 1;
            @(posedge clk);
            #1;
            $display("Test Case 008: Control B3");
            #1;

            check_outputs(4'd8);
        end
        endtask

    task testcase009;

        begin
            reset_dut();
            test_num = 9;
            S3 = 1;
            @(posedge clk);
            #1;
            $display("Test Case 009: Control S3");
            #1;

            check_outputs(4'd9);
        end
        endtask

    task testcase010;

        begin
            reset_dut();
            test_num = 10;
            B4 = 1;
            @(posedge clk);
            #1;
            $display("Test Case 010: Control B4");
            #1;

            check_outputs(4'd10);
        end
        endtask

    task testcase011;

        begin
            reset_dut();
            test_num = 11;

            @(posedge clk);
            #1;
            $display("Test Case 011: No Buttons Pressed (Idle)");
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase012;

        begin
            reset_dut();
            test_num = 12;
            piso1 = 1;
            S1 = 1;
            @(posedge clk);
            #1;
            $display("Test Case 012: Multiple Buttons (Verify unique mapping/priority)");


            if (boton_pres != 4'd0) begin
                $display("PASS: Non-zero output on multiple inputs");
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: Zero output on active inputs");
                fail_count = fail_count + 1;
            end
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
        testcase011();
        testcase012();
        
        
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
        input [3:0] expected_boton_pres;
        begin
            if (expected_boton_pres === (expected_boton_pres ^ boton_pres ^ expected_boton_pres)) begin
                $display("PASS");
                $display("  Outputs: boton_pres=%h",
                         boton_pres);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: boton_pres=%h",
                         expected_boton_pres);
                $display("  Got:      boton_pres=%h",
                         boton_pres);
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
        $dumpvars(0,B2, B3, B4, S1, S2, S3, clk, piso1, piso2, piso3, piso4, boton_pres);
    end

endmodule
