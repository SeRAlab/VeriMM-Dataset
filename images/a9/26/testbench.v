`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg CLR;
    reg [3:0] DATA;
    reg LD;
    wire [3:0] Q0;
    wire [3:0] Q1;
    wire [3:0] Q2;
    wire [3:0] Q3;

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
        .Q0(Q0),
        .Q1(Q1),
        .Q2(Q2),
        .Q3(Q3)
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
            @(posedge CLK);
            #2;
            CLR = 0;
            @(posedge CLK);
            #2;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            #1;

            check_outputs(4'h0, 4'h0, 4'h0, 4'h0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            DATA = 4'hA;
            LD = 1;
            @(posedge CLK);
            #2;
            LD = 0;

            #1;


            check_outputs(4'hA, 4'hA, 4'hA, 4'hA);
        end
        endtask

    task testcase003;

        integer i;
        begin
            reset_dut();
            for(i = 0; i < 5; i = i + 1) begin
                @(posedge CLK);
            end
            #2;
            #1;

            check_outputs(4'h5, 4'h0, 4'h0, 4'h0);
        end
        endtask

    task testcase004;

        integer i;
        begin
            reset_dut();

            for(i = 0; i < 16; i = i + 1) begin
                @(posedge CLK);
            end
            #2;
            #1;

            check_outputs(4'h0, 4'h1, 4'h0, 4'h0);
        end
        endtask

    task testcase005;

        integer i;
        begin
            reset_dut();

            for(i = 0; i < 256; i = i + 1) begin
                @(posedge CLK);
            end
            #2;
            #1;

            check_outputs(4'h0, 4'h0, 4'h1, 4'h0);
        end
        endtask

    task testcase006;

        begin
            reset_dut();

            DATA = 4'hF;
            LD = 1;
            @(posedge CLK);
            #2;

            CLR = 1;
            @(posedge CLK);
            #2;
            #1;

            check_outputs(4'h0, 4'h0, 4'h0, 4'h0);
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
        input [3:0] expected_Q0;
        input [3:0] expected_Q1;
        input [3:0] expected_Q2;
        input [3:0] expected_Q3;
        begin
            if (expected_Q0 === (expected_Q0 ^ Q0 ^ expected_Q0) &&
                expected_Q1 === (expected_Q1 ^ Q1 ^ expected_Q1) &&
                expected_Q2 === (expected_Q2 ^ Q2 ^ expected_Q2) &&
                expected_Q3 === (expected_Q3 ^ Q3 ^ expected_Q3)) begin
                $display("PASS");
                $display("  Outputs: Q0=%h, Q1=%h, Q2=%h, Q3=%h",
                         Q0, Q1, Q2, Q3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q0=%h, Q1=%h, Q2=%h, Q3=%h",
                         expected_Q0, expected_Q1, expected_Q2, expected_Q3);
                $display("  Got:      Q0=%h, Q1=%h, Q2=%h, Q3=%h",
                         Q0, Q1, Q2, Q3);
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
        $dumpvars(0,CLK, CLR, DATA, LD, Q0, Q1, Q2, Q3);
    end

endmodule
