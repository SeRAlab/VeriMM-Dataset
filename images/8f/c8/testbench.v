`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg [3:0] D;
    reg LD;
    reg SI;
    reg UD;
    wire [3:0] Q;
    wire SO;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .D(D),
        .LD(LD),
        .SI(SI),
        .UD(UD),
        .Q(Q),
        .SO(SO)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            LD = 0;
            D = 0;
            UD = 0;
            SI = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            LD = 1; D = 4'd5; UD = 1;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(4'd6, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            LD = 1; D = 4'd10; UD = 0;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(4'd9, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();

            LD = 1; D = 4'd1; UD = 1;
            @(posedge CLK);

            LD = 0; SI = 1; UD = 1;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(4'd5, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();

            LD = 1; D = 4'd8; UD = 1;
            @(posedge CLK);

            LD = 0; SI = 0; UD = 1;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(4'd2, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            LD = 1; D = 4'd15; UD = 1;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(4'd0, 1'b1);
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
        input [3:0] expected_Q;
        input expected_SO;
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q) &&
                expected_SO === (expected_SO ^ SO ^ expected_SO)) begin
                $display("PASS");
                $display("  Outputs: Q=%h, SO=%b",
                         Q, SO);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%h, SO=%b",
                         expected_Q, expected_SO);
                $display("  Got:      Q=%h, SO=%b",
                         Q, SO);
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
        $dumpvars(0,CLK, D, LD, SI, UD, Q, SO);
    end

endmodule
