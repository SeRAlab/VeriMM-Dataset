`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg clk;
    wire EQ;
    wire GT;
    wire LT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .clk(clk),
        .EQ(EQ),
        .GT(GT),
        .LT(LT)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            A = 0;
            B = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Equality Check (A=5, B=5)", test_num);
            A = 4'd5;
            B = 4'd5;
            repeat(2) @(posedge clk);
            #1 #1;
 check_outputs(1, 0, 0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Greater Than Check (A=10, B=4)", test_num);
            A = 4'd10;
            B = 4'd4;
            repeat(2) @(posedge clk);
            #1 #1;
 check_outputs(0, 1, 0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Less Than Check (A=3, B=7)", test_num);
            A = 4'd3;
            B = 4'd7;
            repeat(2) @(posedge clk);
            #1 #1;
 check_outputs(0, 0, 1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Edge Case - Minimum Values (A=0, B=0)", test_num);
            A = 4'd0;
            B = 4'd0;
            repeat(2) @(posedge clk);
            #1 #1;
 check_outputs(1, 0, 0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Edge Case - Maximum Values (A=15, B=15)", test_num);
            A = 4'd15;
            B = 4'd15;
            repeat(2) @(posedge clk);
            #1 #1;
 check_outputs(1, 0, 0);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Edge Case - Max A, Min B (A=15, B=0)", test_num);
            A = 4'd15;
            B = 4'd0;
            repeat(2) @(posedge clk);
            #1 #1;
 check_outputs(0, 1, 0);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Edge Case - Min A, Max B (A=0, B=15)", test_num);
            A = 4'd0;
            B = 4'd15;
            repeat(2) @(posedge clk);
            #1 #1;
 check_outputs(0, 0, 1);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Single Bit Difference (A=8, B=9)", test_num);
            A = 4'd8;
            B = 4'd9;
            repeat(2) @(posedge clk);
            #1 #1;
 check_outputs(0, 0, 1);
        end
        endtask

    task testcase009;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Single Bit Difference (A=1, B=0)", test_num);
            A = 4'd1;
            B = 4'd0;
            repeat(2) @(posedge clk);
            #1 #1;
 check_outputs(0, 1, 0);
        end
        endtask

    task testcase010;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Middle Range Comparison (A=7, B=6)", test_num);
            A = 4'd7;
            B = 4'd6;
            repeat(2) @(posedge clk);
            #1 #1;
 check_outputs(0, 1, 0);
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
        input expected_EQ;
        input expected_GT;
        input expected_LT;
        begin
            if (expected_EQ === (expected_EQ ^ EQ ^ expected_EQ) &&
                expected_GT === (expected_GT ^ GT ^ expected_GT) &&
                expected_LT === (expected_LT ^ LT ^ expected_LT)) begin
                $display("PASS");
                $display("  Outputs: EQ=%b, GT=%b, LT=%b",
                         EQ, GT, LT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: EQ=%b, GT=%b, LT=%b",
                         expected_EQ, expected_GT, expected_LT);
                $display("  Got:      EQ=%b, GT=%b, LT=%b",
                         EQ, GT, LT);
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
        $dumpvars(0,A, B, clk, EQ, GT, LT);
    end

endmodule
