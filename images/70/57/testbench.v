`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg LD1;
    reg LD2;
    reg [7:0] LOAD_IN1;
    reg [7:0] LOAD_IN2;
    reg RST;
    reg UD1;
    reg UD2;
    wire [7:0] Q1;
    wire [7:0] Q2;
    wire [7:0] sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .LD1(LD1),
        .LD2(LD2),
        .LOAD_IN1(LOAD_IN1),
        .LOAD_IN2(LOAD_IN2),
        .RST(RST),
        .UD1(UD1),
        .UD2(UD2),
        .Q1(Q1),
        .Q2(Q2),
        .sum(sum)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            RST = 1;
            LD1 = 0;
            LD2 = 0;
            UD1 = 1;
            UD2 = 1;
            LOAD_IN1 = 8'd0;
            LOAD_IN2 = 8'd0;
            @(posedge CLK);
            #1;
            RST = 0;
        end
        endtask
    task testcase001;

        begin
            $display("Running Testcase 001: Reset Check");
            reset_dut();

            #1;


            check_outputs(8'h00, 8'h00, 8'h00);
        end
        endtask

    task testcase002;

        begin
            $display("Running Testcase 002: Count Up Check");
            reset_dut();
            UD1 = 1;
            UD2 = 1;
            LD1 = 0;
            LD2 = 0;
            repeat(10) @(posedge CLK);
            #1;

            #1;


            check_outputs(8'd10, 8'd10, 8'd20);
        end
        endtask

    task testcase003;

        begin
            $display("Running Testcase 003: Count Down / Wraparound Check");
            reset_dut();
            UD1 = 0;
            UD2 = 0;
            repeat(1) @(posedge CLK);
            #1;

            #1;


            check_outputs(8'hFF, 8'hFF, 8'hFE);
        end
        endtask

    task testcase004;

        begin
            $display("Running Testcase 004: Load Value Check");
            reset_dut();
            LD1 = 1; LOAD_IN1 = 8'h55;
            LD2 = 1; LOAD_IN2 = 8'hAA;
            @(posedge CLK);
            #1;

            #1;


            check_outputs(8'h55, 8'hAA, 8'hFF);
        end
        endtask

    task testcase005;

        begin
            $display("Running Testcase 005: Mixed Load and Direction Check");
            reset_dut();

            LD1 = 1; LOAD_IN1 = 8'd100;
            LD2 = 1; LOAD_IN2 = 8'd50;
            @(posedge CLK);
            #1;

            LD1 = 0; LD2 = 0;
            UD1 = 1;
            UD2 = 0;
            repeat(5) @(posedge CLK);
            #1;
            #1;

            check_outputs(8'd105, 8'd45, 8'd150);
        end
        endtask

    task testcase006;

        begin
            $display("Running Testcase 006: Load Priority over Counting Check");
            reset_dut();
            LD1 = 1; LOAD_IN1 = 8'h20;
            UD1 = 1;
            LD2 = 1; LOAD_IN2 = 8'h30;
            UD2 = 0;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(8'h20, 8'h30, 8'h50);
        end
        endtask

    task testcase007;

        begin
            $display("Running Testcase 007: Sum Overflow Check");
            reset_dut();
            LD1 = 1; LOAD_IN1 = 8'h80;
            LD2 = 1; LOAD_IN2 = 8'h81;
            @(posedge CLK);
            #1;

            #1;


            check_outputs(8'h80, 8'h81, 8'h01);
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
        input [7:0] expected_Q1;
        input [7:0] expected_Q2;
        input [7:0] expected_sum;
        begin
            if (expected_Q1 === (expected_Q1 ^ Q1 ^ expected_Q1) &&
                expected_Q2 === (expected_Q2 ^ Q2 ^ expected_Q2) &&
                expected_sum === (expected_sum ^ sum ^ expected_sum)) begin
                $display("PASS");
                $display("  Outputs: Q1=%h, Q2=%h, sum=%h",
                         Q1, Q2, sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q1=%h, Q2=%h, sum=%h",
                         expected_Q1, expected_Q2, expected_sum);
                $display("  Got:      Q1=%h, Q2=%h, sum=%h",
                         Q1, Q2, sum);
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
        $dumpvars(0,CLK, LD1, LD2, LOAD_IN1, LOAD_IN2, RST, UD1, UD2, Q1, Q2, sum);
    end

endmodule
