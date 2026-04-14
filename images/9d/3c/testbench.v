`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] in0;
    reg [3:0] in1;
    wire [1:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .in0(in0),
        .in1(in1),
        .result(result)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            in0 = 4'd0;
            in1 = 4'd0;
            repeat(2) @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            in0 = 4'd10;
            in1 = 4'd5;
            repeat(2) @(posedge clk);
            #1;
            $display("Testcase %0d: in0=10, in1=5 (Greater Than)", test_num);
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            in0 = 4'd3;
            in1 = 4'd8;
            repeat(2) @(posedge clk);
            #1;
            $display("Testcase %0d: in0=3, in1=8 (Less Than)", test_num);
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            in0 = 4'd7;
            in1 = 4'd7;
            repeat(2) @(posedge clk);
            #1;
            $display("Testcase %0d: in0=7, in1=7 (Equal)", test_num);
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            in0 = 4'd15;
            in1 = 4'd0;
            repeat(2) @(posedge clk);
            #1;
            $display("Testcase %0d: in0=15, in1=0 (Max vs Min)", test_num);
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            in0 = 4'd0;
            in1 = 4'd15;
            repeat(2) @(posedge clk);
            #1;
            $display("Testcase %0d: in0=0, in1=15 (Min vs Max)", test_num);
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = test_num + 1;
            in0 = 4'd15;
            in1 = 4'd15;
            repeat(2) @(posedge clk);
            #1;
            $display("Testcase %0d: in0=15, in1=15 (Max Equal)", test_num);
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = test_num + 1;
            in0 = 4'd0;
            in1 = 4'd0;
            repeat(2) @(posedge clk);
            #1;
            $display("Testcase %0d: in0=0, in1=0 (Min Equal)", test_num);
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            test_num = test_num + 1;
            in0 = 4'd9;
            in1 = 4'd8;
            repeat(2) @(posedge clk);
            #1;
            $display("Testcase %0d: in0=9, in1=8 (Off-by-one Greater)", test_num);
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase009;

        begin
            reset_dut();
            test_num = test_num + 1;
            in0 = 4'd4;
            in1 = 4'd5;
            repeat(2) @(posedge clk);
            #1;
            $display("Testcase %0d: in0=4, in1=5 (Off-by-one Less)", test_num);
            #1;

            check_outputs(2'b10);
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
        input [1:0] expected_result;
        begin
            if (expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: result=%h",
                         result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: result=%h",
                         expected_result);
                $display("  Got:      result=%h",
                         result);
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
        $dumpvars(0,clk, in0, in1, result);
    end

endmodule
