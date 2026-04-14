`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg CIN;
    reg CLK;
    reg CTRL;
    reg RST;
    wire COUT;
    wire [3:0] DIFF;
    wire [3:0] SUM;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .CIN(CIN),
        .CLK(CLK),
        .CTRL(CTRL),
        .RST(RST),
        .COUT(COUT),
        .DIFF(DIFF),
        .SUM(SUM)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            RST = 1;
            A = 0;
            B = 0;
            CIN = 0;
            CTRL = 0;
            @(posedge CLK);
            #1;
            RST = 0;

            if (SUM !== 4'h0 || DIFF !== 4'h0 || COUT !== 1'b0) begin
                $display("Error: Reset failed. Outputs not zero.");
            end
        end
        endtask
    task testcase001;

        begin
            $display("\nTestcase 001: Simple Add/Sub (Both Mode)");
            reset_dut();
            test_num = 1;
            A = 4'd7; B = 4'd2; CIN = 1'b0; CTRL = 2'b00;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(1'b0, 4'd5, 4'd9);
        end
        endtask

    task testcase002;

        begin
            $display("\nTestcase 002: Addition with Carry Out");
            reset_dut();
            test_num = 2;
            A = 4'd12; B = 4'd5; CIN = 1'b0; CTRL = 2'b00;
            @(posedge CLK);
            #1;

            #1;


            check_outputs(1'b1, 4'd7, 4'd1);
        end
        endtask

    task testcase003;

        begin
            $display("\nTestcase 003: Addition with CIN");
            reset_dut();
            test_num = 3;
            A = 4'd3; B = 4'd3; CIN = 1'b1; CTRL = 2'b00;
            @(posedge CLK);
            #1;

            #1;


            check_outputs(1'b0, 4'd0, 4'd7);
        end
        endtask

    task testcase004;

        begin
            $display("\nTestcase 004: Negative Difference");
            reset_dut();
            test_num = 4;
            A = 4'd4; B = 4'd6; CIN = 1'b0; CTRL = 2'b00;
            @(posedge CLK);
            #1;

            #1;


            check_outputs(1'b0, 4'hE, 4'hA);
        end
        endtask

    task testcase005;

        begin
            $display("\nTestcase 005: Mode Selection - Sum Only");
            reset_dut();
            test_num = 5;
            A = 4'd8; B = 4'd1; CIN = 1'b0; CTRL = 2'b01;
            @(posedge CLK);
            #1;

            #1;


            check_outputs(1'b0, 4'd0, 4'd9);
        end
        endtask

    task testcase006;

        begin
            $display("\nTestcase 006: Mode Selection - Difference Only");
            reset_dut();
            test_num = 6;
            A = 4'd10; B = 4'd5; CIN = 1'b0; CTRL = 2'b10;
            @(posedge CLK);
            #1;

            #1;


            check_outputs(1'b0, 4'd5, 4'd0);
        end
        endtask

    task testcase007;

        begin
            $display("\nTestcase 007: Maximum Values");
            reset_dut();
            test_num = 7;
            A = 4'hF; B = 4'hF; CIN = 1'b1; CTRL = 2'b00;
            @(posedge CLK);
            #1;

            #1;


            check_outputs(1'b1, 4'h0, 4'hF);
        end
        endtask

    task testcase008;

        begin
            $display("\nTestcase 008: Synchronous Reset mid-operation");
            reset_dut();
            test_num = 8;
            A = 4'd5; B = 4'd5; CTRL = 2'b00;
            @(posedge CLK);
            RST = 1;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(1'b0, 4'h0, 4'h0);
            RST = 0;
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
        input expected_COUT;
        input [3:0] expected_DIFF;
        input [3:0] expected_SUM;
        begin
            if (expected_COUT === (expected_COUT ^ COUT ^ expected_COUT) &&
                expected_DIFF === (expected_DIFF ^ DIFF ^ expected_DIFF) &&
                expected_SUM === (expected_SUM ^ SUM ^ expected_SUM)) begin
                $display("PASS");
                $display("  Outputs: COUT=%b, DIFF=%h, SUM=%h",
                         COUT, DIFF, SUM);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: COUT=%b, DIFF=%h, SUM=%h",
                         expected_COUT, expected_DIFF, expected_SUM);
                $display("  Got:      COUT=%b, DIFF=%h, SUM=%h",
                         COUT, DIFF, SUM);
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
        $dumpvars(0,A, B, CIN, CLK, CTRL, RST, COUT, DIFF, SUM);
    end

endmodule
