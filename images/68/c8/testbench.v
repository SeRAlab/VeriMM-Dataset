`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] a;
    reg [3:0] b;
    reg clk;
    reg rst;
    reg sub;
    wire overflow;
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
        .rst(rst),
        .sub(sub),
        .overflow(overflow),
        .result(result)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            a = 0;
            b = 0;
            sub = 0;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Simple addition (3 + 2)", test_num);
            a = 4'd3;
            b = 4'd2;
            sub = 1'b0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 4'd5);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Addition overflow (5 + 4)", test_num);
            a = 4'd5;
            b = 4'd4;
            sub = 1'b0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 4'b1001);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Simple subtraction (7 - 3)", test_num);
            a = 4'd7;
            b = 4'd3;
            sub = 1'b1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 4'd4);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Subtraction overflow (-5 - 4)", test_num);
            a = 4'b1011;
            b = 4'b0100;
            sub = 1'b1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 4'b0111);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Negative addition (-2 + -3)", test_num);
            a = 4'b1110;
            b = 4'b1101;
            sub = 1'b0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 4'b1011);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Subtraction (2 - (-3))", test_num);
            a = 4'b0010;
            b = 4'b1101;
            sub = 1'b1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 4'b0101);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Addition overflow (-7 + -2)", test_num);
            a = 4'b1001;
            b = 4'b1110;
            sub = 1'b0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 4'b0111);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Subtraction overflow (7 - (-2))", test_num);
            a = 4'b0111;
            b = 4'b1110;
            sub = 1'b1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 4'b1001);
        end
        endtask

    task testcase009;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Zero addition (0 + 0)", test_num);
            a = 4'b0000;
            b = 4'b0000;
            sub = 1'b0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 4'b0000);
        end
        endtask

    task testcase010;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Minimum value subtraction (-8 - 1)", test_num);
            a = 4'b1000;
            b = 4'b0001;
            sub = 1'b1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 4'b0111);
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
        input expected_overflow;
        input [3:0] expected_result;
        begin
            if (expected_overflow === (expected_overflow ^ overflow ^ expected_overflow) &&
                expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: overflow=%b, result=%h",
                         overflow, result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: overflow=%b, result=%h",
                         expected_overflow, expected_result);
                $display("  Got:      overflow=%b, result=%h",
                         overflow, result);
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
        $dumpvars(0,a, b, clk, rst, sub, overflow, result);
    end

endmodule
