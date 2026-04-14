`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] n;
    reg reset;
    wire ready;
    wire [15:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .n(n),
        .reset(reset),
        .ready(ready),
        .result(result)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        input [7:0] target_n;
        begin
            reset = 1;
            n = target_n;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Testing n=1 (F1=1)", test_num);
            reset_dut(8'd1);
            while (!ready) @(posedge clk);
            #1;

            check_outputs(1'b1, 16'd1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Testing n=2 (F2=1)", test_num);
            reset_dut(8'd2);
            while (!ready) @(posedge clk);
            #1;

            check_outputs(1'b1, 16'd1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Testing n=3 (F3=2)", test_num);
            reset_dut(8'd3);
            while (!ready) @(posedge clk);
            #1;

            check_outputs(1'b1, 16'd2);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Testing n=6 (F6=8)", test_num);
            reset_dut(8'd6);
            while (!ready) @(posedge clk);
            #1;

            check_outputs(1'b1, 16'd8);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Testing n=10 (F10=55)", test_num);
            reset_dut(8'd10);
            while (!ready) @(posedge clk);
            #1;

            check_outputs(1'b1, 16'd55);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Testing n=15 (F15=610)", test_num);
            reset_dut(8'd15);
            while (!ready) @(posedge clk);
            #1;

            check_outputs(1'b1, 16'd610);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Testing n=24 (F24=46368)", test_num);
            reset_dut(8'd24);
            while (!ready) @(posedge clk);
            #1;

            check_outputs(1'b1, 16'd46368);
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
        input expected_ready;
        input [15:0] expected_result;
        begin
            if (expected_ready === (expected_ready ^ ready ^ expected_ready) &&
                expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: ready=%b, result=%h",
                         ready, result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ready=%b, result=%h",
                         expected_ready, expected_result);
                $display("  Got:      ready=%b, result=%h",
                         ready, result);
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
        $dumpvars(0,clk, n, reset, ready, result);
    end

endmodule
