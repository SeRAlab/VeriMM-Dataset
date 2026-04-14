`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [8:0] incre;
    reg res;
    reg [27:0] shift;
    wire [7:0] exp_result;
    wire [27:0] fra_result;
    wire overflow;
    wire [31:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .incre(incre),
        .res(res),
        .shift(shift),
        .exp_result(exp_result),
        .fra_result(fra_result),
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
            res = 1;
            incre = 0;
            shift = 0;
            @(posedge clk);
            #2 res = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Reset Behavior", test_num);
            reset_dut();

            #1;


            check_outputs(8'h00, 28'h0000000, 1'b0, 32'h00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Normal Operation (No Rounding)", test_num);
            reset_dut();
            incre = 9'h07F;
            shift = 28'hA000000;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h7F, 28'hA000000, 1'b0, 32'h3FA00000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Rounding Up Fraction", test_num);
            reset_dut();
            incre = 9'h040;
            shift = 28'h0000007;
            @(posedge clk);
            #1;


            $display("Checking for fraction increment...");
            if (fra_result > 28'h0000007 && overflow == 0) begin
                 pass_count = pass_count + 1;
                 $display("PASS: Fraction adjusted upward.");
            end else begin
                 $display("FAIL: Fraction did not adjust as expected.");
                 fail_count = fail_count + 1;
            end
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Fraction Overflow to Exponent", test_num);
            reset_dut();
            incre = 9'h010;
            shift = 28'hFFFFFFF;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h11, 28'h0000000, 1'b0, 32'h08800000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Exponent Overflow Check", test_num);
            reset_dut();
            incre = 9'h0FF;
            shift = 28'hFFFFFFF;
            @(posedge clk);
            #1;

            if (overflow == 1'b1) begin
                $display("PASS: Overflow detected.");
                pass_count = pass_count + 1;
            } else begin
                $display("FAIL: Overflow not detected.");
                fail_count = fail_count + 1;
            end
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Zero Fraction with Exponent", test_num);
            reset_dut();
            incre = 9'h0A5;
            shift = 28'h0000000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hA5, 28'h0000000, 1'b0, 32'h52800000);
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
        input [7:0] expected_exp_result;
        input [27:0] expected_fra_result;
        input expected_overflow;
        input [31:0] expected_result;
        begin
            if (expected_exp_result === (expected_exp_result ^ exp_result ^ expected_exp_result) &&
                expected_fra_result === (expected_fra_result ^ fra_result ^ expected_fra_result) &&
                expected_overflow === (expected_overflow ^ overflow ^ expected_overflow) &&
                expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: exp_result=%h, fra_result=%h, overflow=%b, result=%h",
                         exp_result, fra_result, overflow, result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: exp_result=%h, fra_result=%h, overflow=%b, result=%h",
                         expected_exp_result, expected_fra_result, expected_overflow, expected_result);
                $display("  Got:      exp_result=%h, fra_result=%h, overflow=%b, result=%h",
                         exp_result, fra_result, overflow, result);
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
        $dumpvars(0,clk, incre, res, shift, exp_result, fra_result, overflow, result);
    end

endmodule
