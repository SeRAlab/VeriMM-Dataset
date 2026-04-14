`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg Clr_CR;
    reg [15:0] Data_AR;
    reg [15:0] Data_BR;
    reg Div_AR_x2_CR;
    reg Ld_AR_BR;
    reg Mul_BR_x2_CR;
    reg clk;
    wire AR_gt_0;
    wire AR_lt_0;
    wire [15:0] CR;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Clr_CR(Clr_CR),
        .Data_AR(Data_AR),
        .Data_BR(Data_BR),
        .Div_AR_x2_CR(Div_AR_x2_CR),
        .Ld_AR_BR(Ld_AR_BR),
        .Mul_BR_x2_CR(Mul_BR_x2_CR),
        .clk(clk),
        .AR_gt_0(AR_gt_0),
        .AR_lt_0(AR_lt_0),
        .CR(CR)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            Clr_CR = 1;
            Ld_AR_BR = 0;
            Div_AR_x2_CR = 0;
            Mul_BR_x2_CR = 0;
            Data_AR = 0;
            Data_BR = 0;
            @(posedge clk);
            #1;
            Clr_CR = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Load positive values and check AR flags", test_num);
            reset_dut();
            Data_AR = 16'sd100;
            Data_BR = 16'sd50;
            Ld_AR_BR = 1;
            @(posedge clk);
            #1;
            Ld_AR_BR = 0;

            #1;


            check_outputs(1, 0, 16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Division of AR by 2 (Positive)", test_num);
            reset_dut();

            Data_AR = 16'sd40;
            Data_BR = 16'sd0;
            Ld_AR_BR = 1;
            @(posedge clk);
            #1;
            Ld_AR_BR = 0;

            Div_AR_x2_CR = 1;
            @(posedge clk);
            #1;
            Div_AR_x2_CR = 0;

            #1;


            check_outputs(1, 0, 16'sd20);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Multiplication of BR by 2 (Positive)", test_num);
            reset_dut();

            Data_AR = 16'sd5;
            Data_BR = 16'sd25;
            Ld_AR_BR = 1;
            @(posedge clk);
            #1;
            Ld_AR_BR = 0;

            Mul_BR_x2_CR = 1;
            @(posedge clk);
            #1;
            Mul_BR_x2_CR = 0;

            #1;


            check_outputs(1, 0, 16'sd50);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Clear CR register", test_num);
            reset_dut();

            Data_BR = 16'sd100;
            Ld_AR_BR = 1;
            @(posedge clk);
            #1;
            Ld_AR_BR = 0;
            Mul_BR_x2_CR = 1;
            @(posedge clk);
            #1;
            Mul_BR_x2_CR = 0;


            Clr_CR = 1;
            @(posedge clk);
            #1;
            Clr_CR = 0;
            #1;

            check_outputs(0, 0, 16'h0000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Load negative values and check AR flags", test_num);
            reset_dut();
            Data_AR = -16'sd10;
            Data_BR = 16'sd0;
            Ld_AR_BR = 1;
            @(posedge clk);
            #1;
            Ld_AR_BR = 0;

            #1;


            check_outputs(0, 1, 16'h0000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Division of AR by 2 (Negative/Signed)", test_num);
            reset_dut();
            Data_AR = -16'sd20;
            Ld_AR_BR = 1;
            @(posedge clk);
            #1;
            Ld_AR_BR = 0;
            Div_AR_x2_CR = 1;
            @(posedge clk);
            #1;
            Div_AR_x2_CR = 0;

            #1;


            check_outputs(0, 1, -16'sd10);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Multiplication of BR by 2 (Negative/Signed)", test_num);
            reset_dut();
            Data_AR = 16'sd0;
            Data_BR = -16'sd15;
            Ld_AR_BR = 1;
            @(posedge clk);
            #1;
            Ld_AR_BR = 0;
            Mul_BR_x2_CR = 1;
            @(posedge clk);
            #1;
            Mul_BR_x2_CR = 0;

            #1;


            check_outputs(0, 0, -16'sd30);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: AR boundary check (Zero)", test_num);
            reset_dut();
            Data_AR = 16'sd0;
            Ld_AR_BR = 1;
            @(posedge clk);
            #1;
            Ld_AR_BR = 0;

            #1;


            check_outputs(0, 0, 16'h0000);
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
        input expected_AR_gt_0;
        input expected_AR_lt_0;
        input [15:0] expected_CR;
        begin
            if (expected_AR_gt_0 === (expected_AR_gt_0 ^ AR_gt_0 ^ expected_AR_gt_0) &&
                expected_AR_lt_0 === (expected_AR_lt_0 ^ AR_lt_0 ^ expected_AR_lt_0) &&
                expected_CR === (expected_CR ^ CR ^ expected_CR)) begin
                $display("PASS");
                $display("  Outputs: AR_gt_0=%b, AR_lt_0=%b, CR=%h",
                         AR_gt_0, AR_lt_0, CR);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: AR_gt_0=%b, AR_lt_0=%b, CR=%h",
                         expected_AR_gt_0, expected_AR_lt_0, expected_CR);
                $display("  Got:      AR_gt_0=%b, AR_lt_0=%b, CR=%h",
                         AR_gt_0, AR_lt_0, CR);
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
        $dumpvars(0,Clr_CR, Data_AR, Data_BR, Div_AR_x2_CR, Ld_AR_BR, Mul_BR_x2_CR, clk, AR_gt_0, AR_lt_0, CR);
    end

endmodule
