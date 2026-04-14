`timescale 1ns/1ps

module restoring_divider_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] dividend;
    reg [15:0] divisor;
    reg reset;
    wire done;
    wire [15:0] quotient;
    wire [15:0] remainder;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    restoring_divider dut (
        .clk(clk),
        .dividend(dividend),
        .divisor(divisor),
        .reset(reset),
        .done(done),
        .quotient(quotient),
        .remainder(remainder)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            dividend = 0;
            divisor = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
        end
        endtask
    task wait_and_check;

        input [15:0] exp_q;
        input [15:0] exp_r;
        begin

            fork
                begin
                    wait(done == 1);
                end
                begin
                    repeat (100) @(posedge clk);
                end
            join_any

            if (done) begin
                #1;

                check_outputs(1'b1, exp_q, exp_r);
            end else begin
                $display("FAIL: Timeout waiting for done signal");
                fail_count = fail_count + 1;
            end
            @(posedge clk);
        end
        endtask

    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Basic Division (100 / 10)", test_num);
            reset_dut();
            dividend = 16'd100;
            divisor = 16'd10;
            wait_and_check(16'd10, 16'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Division with Remainder (100 / 3)", test_num);
            reset_dut();
            dividend = 16'd100;
            divisor = 16'd3;
            wait_and_check(16'd33, 16'd1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Dividend < Divisor (5 / 10)", test_num);
            reset_dut();
            dividend = 16'd5;
            divisor = 16'd10;
            wait_and_check(16'd0, 16'd5);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Dividend is Zero (0 / 50)", test_num);
            reset_dut();
            dividend = 16'd0;
            divisor = 16'd50;
            wait_and_check(16'd0, 16'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Division by One (500 / 1)", test_num);
            reset_dut();
            dividend = 16'd500;
            divisor = 16'd1;
            wait_and_check(16'd500, 16'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Identical Dividend and Divisor (1234 / 1234)", test_num);
            reset_dut();
            dividend = 16'd1234;
            divisor = 16'd1234;
            wait_and_check(16'd1, 16'd0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Large Numbers (65535 / 2)", test_num);
            reset_dut();
            dividend = 16'hFFFF;
            divisor = 16'd2;
            wait_and_check(16'd32767, 16'd1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Complex Division (40000 / 123)", test_num);
            reset_dut();
            dividend = 16'd40000;
            divisor = 16'd123;
            wait_and_check(16'd325, 16'd25);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Max Values (65535 / 65535)", test_num);
            reset_dut();
            dividend = 16'hFFFF;
            divisor = 16'hFFFF;
            wait_and_check(16'd1, 16'd0);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Division resulting in 0xFFFF (65535 / 1)", test_num);
            reset_dut();
            dividend = 16'hFFFF;
            divisor = 16'd1;
            wait_and_check(16'hFFFF, 16'd0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("restoring_divider Testbench");
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
        input expected_done;
        input [15:0] expected_quotient;
        input [15:0] expected_remainder;
        begin
            if (expected_done === (expected_done ^ done ^ expected_done) &&
                expected_quotient === (expected_quotient ^ quotient ^ expected_quotient) &&
                expected_remainder === (expected_remainder ^ remainder ^ expected_remainder)) begin
                $display("PASS");
                $display("  Outputs: done=%b, quotient=%h, remainder=%h",
                         done, quotient, remainder);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: done=%b, quotient=%h, remainder=%h",
                         expected_done, expected_quotient, expected_remainder);
                $display("  Got:      done=%b, quotient=%h, remainder=%h",
                         done, quotient, remainder);
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
        $dumpvars(0,clk, dividend, divisor, reset, done, quotient, remainder);
    end

endmodule
