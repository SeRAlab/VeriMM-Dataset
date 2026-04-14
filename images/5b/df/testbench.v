`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] num;
    wire [4:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .num(num),
        .result(result)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            num = 0;
            @(posedge clk);
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            num = 4'd0;
            $display("Test %0d: Input num=%d", test_num, num);
            repeat(2) @(posedge clk);
            #1;

            check_outputs(5'd1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            num = 4'd1;
            $display("Test %0d: Input num=%d", test_num, num);
            repeat(2) @(posedge clk);
            #1;

            check_outputs(5'd1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            num = 4'd2;
            $display("Test %0d: Input num=%d", test_num, num);
            repeat(2) @(posedge clk);
            #1;

            check_outputs(5'd2);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            num = 4'd3;
            $display("Test %0d: Input num=%d", test_num, num);
            repeat(2) @(posedge clk);
            #1;

            check_outputs(5'd4);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            num = 4'd4;
            $display("Test %0d: Input num=%d", test_num, num);
            repeat(2) @(posedge clk);
            #1;

            check_outputs(5'd4);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            num = 4'd7;
            $display("Test %0d: Input num=%d", test_num, num);
            repeat(2) @(posedge clk);
            #1;

            check_outputs(5'd8);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = 7;
            num = 4'd8;
            $display("Test %0d: Input num=%d", test_num, num);
            repeat(2) @(posedge clk);
            #1;

            check_outputs(5'd8);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            test_num = 8;
            num = 4'd12;
            $display("Test %0d: Input num=%d", test_num, num);
            repeat(2) @(posedge clk);
            #1;

            check_outputs(5'd16);
        end
        endtask

    task testcase009;

        begin
            reset_dut();
            test_num = 9;
            num = 4'd15;
            $display("Test %0d: Input num=%d", test_num, num);
            repeat(2) @(posedge clk);
            #1;

            check_outputs(5'd16);
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
        input [4:0] expected_result;
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
        $dumpvars(0,clk, num, result);
    end

endmodule
