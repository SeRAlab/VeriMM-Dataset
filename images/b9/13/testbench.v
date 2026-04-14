`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] a;
    reg [7:0] b;
    reg clk;
    reg reset;
    wire [7:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .clk(clk),
        .reset(reset),
        .result(result)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset <= 1;
            a <= 8'd0;
            b <= 8'd0;
            @(posedge clk);
            #1;
            reset <= 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: 10 * 2 / 2 = 10", test_num);
            reset_dut();
            a <= 8'd10;
            b <= 8'd2;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(8'd10);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: 0 * 255 / 2 = 0", test_num);
            reset_dut();
            a <= 8'd0;
            b <= 8'd255;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: 15 * 3 / 2 = 22", test_num);
            reset_dut();
            a <= 8'd15;
            b <= 8'd3;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(8'd22);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: 255 * 1 / 2 = 127", test_num);
            reset_dut();
            a <= 8'd255;
            b <= 8'd1;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(8'd127);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: 128 * 2 / 2 = 128", test_num);
            reset_dut();
            a <= 8'd128;
            b <= 8'd2;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(8'd128);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: 255 * 2 / 2 = 255", test_num);
            reset_dut();
            a <= 8'd255;
            b <= 8'd2;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(8'd255);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: 255 * 255 / 2 = 0 (truncated)", test_num);
            reset_dut();
            a <= 8'd255;
            b <= 8'd255;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: 100 * 4 / 2 = 200", test_num);
            reset_dut();
            a <= 8'd100;
            b <= 8'd4;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(8'd200);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: 100 * 6 / 2 = 44 (truncated)", test_num);
            reset_dut();
            a <= 8'd100;
            b <= 8'd6;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(8'd44);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: 20 * 11 / 2 = 110", test_num);
            reset_dut();
            a <= 8'd20;
            b <= 8'd11;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(8'd110);
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
        input [7:0] expected_result;
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
        $dumpvars(0,a, b, clk, reset, result);
    end

endmodule
