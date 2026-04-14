`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] a;
    reg [3:0] b;
    reg clk;
    reg mode;
    wire [3:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .clk(clk),
        .mode(mode),
        .result(result)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            a = 0;
            b = 0;
            mode = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            mode = 1; a = 4'd5; b = 4'd3;
            @(posedge clk);
            #1;
            $display("Test %0d: Addition 5 + 3", test_num);
            #1;

            check_outputs(4'd8);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            mode = 1; a = 4'd15; b = 4'd1;
            @(posedge clk);
            #1;
            $display("Test %0d: Addition 15 + 1 (Wrap)", test_num);
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            mode = 0; a = 4'd10; b = 4'd4;
            @(posedge clk);
            #1;
            $display("Test %0d: Subtraction 10 - 4", test_num);
            #1;

            check_outputs(4'd6);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            mode = 0; a = 4'd2; b = 4'd5;
            @(posedge clk);
            #1;
            $display("Test %0d: Subtraction 2 - 5 (Negative)", test_num);
            #1;

            check_outputs(4'd13);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            mode = 0; a = 4'd0; b = 4'd1;
            @(posedge clk);
            #1;
            $display("Test %0d: Subtraction 0 - 1", test_num);
            #1;

            check_outputs(4'd15);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            mode = 1; a = 4'd8; b = 4'd8;
            @(posedge clk);
            #1;
            $display("Test %0d: Addition 8 + 8", test_num);
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = 7;
            mode = 0; a = 4'd7; b = 4'd7;
            @(posedge clk);
            #1;
            $display("Test %0d: Subtraction 7 - 7", test_num);
            #1;

            check_outputs(4'd0);
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
        input [3:0] expected_result;
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
        $dumpvars(0,a, b, clk, mode, result);
    end

endmodule
