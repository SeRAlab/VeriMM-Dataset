`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] a;
    reg [7:0] b;
    reg clk;
    reg reset;
    wire overflow;
    wire [7:0] sum;

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
        .overflow(overflow),
        .sum(sum)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            a = 0;
            b = 0;
            @(posedge clk);
            #1;
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Positive Addition (10 + 20)", test_num);
            reset_dut();
            a = 8'sd10;
            b = 8'sd20;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 8'sd30);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Negative Addition (-10 + -20)", test_num);
            reset_dut();
            a = 8'sd-10;
            b = 8'sd-20;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 8'sd-30);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Positive Overflow (127 + 1)", test_num);
            reset_dut();
            a = 8'sd127;
            b = 8'sd1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 8'h80);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Negative Overflow (-128 + -1)", test_num);
            reset_dut();
            a = 8'sd-128;
            b = 8'sd-1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 8'h7F);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Positive Overflow (64 + 64)", test_num);
            reset_dut();
            a = 8'sd64;
            b = 8'sd64;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 8'h80);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Negative Overflow (-65 + -65)", test_num);
            reset_dut();
            a = 8'sd-65;
            b = 8'sd-65;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 8'h7E);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Complementary Addition (-50 + 50)", test_num);
            reset_dut();
            a = 8'sd-50;
            b = 8'sd50;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 8'sd0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: Boundary Case (-128 + 127)", test_num);
            reset_dut();
            a = 8'sd-128;
            b = 8'sd127;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 8'sd-1);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test %0d: Max Negative Overflow (-128 + -128)", test_num);
            reset_dut();
            a = 8'sd-128;
            b = 8'sd-128;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 8'h00);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Test %0d: Adding Zero (-128 + 0)", test_num);
            reset_dut();
            a = 8'sd-128;
            b = 8'sd0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 8'h80);
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
        input [7:0] expected_sum;
        begin
            if (expected_overflow === (expected_overflow ^ overflow ^ expected_overflow) &&
                expected_sum === (expected_sum ^ sum ^ expected_sum)) begin
                $display("PASS");
                $display("  Outputs: overflow=%b, sum=%h",
                         overflow, sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: overflow=%b, sum=%h",
                         expected_overflow, expected_sum);
                $display("  Got:      overflow=%b, sum=%h",
                         overflow, sum);
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
        $dumpvars(0,a, b, clk, reset, overflow, sum);
    end

endmodule
