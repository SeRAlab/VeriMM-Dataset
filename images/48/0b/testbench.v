`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg CLR;
    reg [3:0] DATA;
    reg LD;
    wire [7:0] Q;
    wire [3:0] Q0;
    wire [3:0] Q1;
    wire [3:0] Q2;
    wire [3:0] Q3;
    wire [3:0] Q4;
    wire [3:0] Q5;
    wire [3:0] Q6;
    wire [3:0] Q7;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .CLR(CLR),
        .DATA(DATA),
        .LD(LD),
        .Q(Q),
        .Q0(Q0),
        .Q1(Q1),
        .Q2(Q2),
        .Q3(Q3),
        .Q4(Q4),
        .Q5(Q5),
        .Q6(Q6),
        .Q7(Q7)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            CLR = 1;
            LD = 0;
            DATA = 4'b0;
            #15;
            CLR = 0;
            #5;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Basic Increment...");
            reset_dut();
            @(posedge CLK);
            @(posedge CLK);
            @(posedge CLK);
            #2;

            #1;


            check_outputs(8'd6, 4'd1, 4'd1, 4'd0, 4'd0, 4'd1, 4'd1, 4'd0, 4'd0);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Asynchronous Load...");
            reset_dut();
            DATA = 4'hA;
            LD = 1;
            #2;


            #1;



            check_outputs(8'd10, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd1, 4'd0, 4'd1);
            LD = 0;
            #2;
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Increment after Load...");
            reset_dut();
            DATA = 4'd12;
            LD = 1;
            #2 LD = 0;
            @(posedge CLK);
            #2;

            #1;


            check_outputs(8'd14, 4'd1, 4'd0, 4'd0, 4'd0, 4'd1, 4'd0, 4'd1, 4'd1);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Counter Wraparound...");
            reset_dut();
            DATA = 4'hF;
            LD = 1;
            #2 LD = 0;
            @(posedge CLK);
            #2;

            #1;


            check_outputs(8'd1, 4'd1, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: CLR vs LD Priority...");
            reset_dut();
            DATA = 4'hF;
            LD = 1;
            CLR = 1;
            #2;

            #1;


            check_outputs(8'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0);
            CLR = 0;
            LD = 0;
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
        input [7:0] expected_Q;
        input [3:0] expected_Q0;
        input [3:0] expected_Q1;
        input [3:0] expected_Q2;
        input [3:0] expected_Q3;
        input [3:0] expected_Q4;
        input [3:0] expected_Q5;
        input [3:0] expected_Q6;
        input [3:0] expected_Q7;
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q) &&
                expected_Q0 === (expected_Q0 ^ Q0 ^ expected_Q0) &&
                expected_Q1 === (expected_Q1 ^ Q1 ^ expected_Q1) &&
                expected_Q2 === (expected_Q2 ^ Q2 ^ expected_Q2) &&
                expected_Q3 === (expected_Q3 ^ Q3 ^ expected_Q3) &&
                expected_Q4 === (expected_Q4 ^ Q4 ^ expected_Q4) &&
                expected_Q5 === (expected_Q5 ^ Q5 ^ expected_Q5) &&
                expected_Q6 === (expected_Q6 ^ Q6 ^ expected_Q6) &&
                expected_Q7 === (expected_Q7 ^ Q7 ^ expected_Q7)) begin
                $display("PASS");
                $display("  Outputs: Q=%h, Q0=%h, Q1=%h, Q2=%h, Q3=%h, Q4=%h, Q5=%h, Q6=%h, Q7=%h",
                         Q, Q0, Q1, Q2, Q3, Q4, Q5, Q6, Q7);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%h, Q0=%h, Q1=%h, Q2=%h, Q3=%h, Q4=%h, Q5=%h, Q6=%h, Q7=%h",
                         expected_Q, expected_Q0, expected_Q1, expected_Q2, expected_Q3, expected_Q4, expected_Q5, expected_Q6, expected_Q7);
                $display("  Got:      Q=%h, Q0=%h, Q1=%h, Q2=%h, Q3=%h, Q4=%h, Q5=%h, Q6=%h, Q7=%h",
                         Q, Q0, Q1, Q2, Q3, Q4, Q5, Q6, Q7);
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
        $dumpvars(0,CLK, CLR, DATA, LD, Q, Q0, Q1, Q2, Q3, Q4, Q5, Q6, Q7);
    end

endmodule
