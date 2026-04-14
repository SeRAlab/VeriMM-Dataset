`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] dividend;
    reg [31:0] divisor;
    reg start;
    wire done;
    wire [31:0] quotient;
    wire [31:0] remainder;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .dividend(dividend),
        .divisor(divisor),
        .start(start),
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
            @(posedge clk);
            start = 0;
            dividend = 0;
            divisor = 0;
            repeat (2) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Positive / Positive (Even division)", test_num);
            reset_dut();
            run_division(32'sd100, 32'sd10);
            #1;

            check_outputs(1'b1, 32'sd10, 32'sd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Positive / Positive (With remainder)", test_num);
            reset_dut();
            run_division(32'sd25, 32'sd7);
            #1;

            check_outputs(1'b1, 32'sd3, 32'sd4);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Negative / Positive", test_num);
            reset_dut();
            run_division(-32'sd25, 32'sd7);
            #1;

            check_outputs(1'b1, -32'sd3, -32'sd4);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Positive / Negative", test_num);
            reset_dut();
            run_division(32'sd25, -32'sd7);
            #1;

            check_outputs(1'b1, -32'sd3, 32'sd4);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Negative / Negative", test_num);
            reset_dut();
            run_division(-32'sd25, -32'sd7);
            #1;

            check_outputs(1'b1, 32'sd3, -32'sd4);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Zero Dividend", test_num);
            reset_dut();
            run_division(32'sd0, 32'sd50);
            #1;

            check_outputs(1'b1, 32'sd0, 32'sd0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Dividend Equals Divisor", test_num);
            reset_dut();
            run_division(32'sd12345, 32'sd12345);
            #1;

            check_outputs(1'b1, 32'sd1, 32'sd0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Divisor Greater Than Dividend", test_num);
            reset_dut();
            run_division(32'sd5, 32'sd10);
            #1;

            check_outputs(1'b1, 32'sd0, 32'sd5);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Large Positive Division", test_num);
            reset_dut();
            run_division(32'sd2147483647, 32'sd2);
            #1;

            check_outputs(1'b1, 32'sd1073741823, 32'sd1);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Large Negative Division (INT_MIN / 2)", test_num);
            reset_dut();
            run_division(-32'sd2147483648, 32'sd2);
            #1;

            check_outputs(1'b1, -32'sd1073741824, 32'sd0);
        end
        endtask

    task testcase011;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Division by 1", test_num);
            reset_dut();
            run_division(32'sd999, 32'sd1);
            #1;

            check_outputs(1'b1, 32'sd999, 32'sd0);
        end
        endtask

    task testcase012;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Division by -1", test_num);
            reset_dut();
            run_division(32'sd999, -32'sd1);
            #1;

            check_outputs(1'b1, -32'sd999, 32'sd0);
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
        testcase011();
        testcase012();
        
        
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
        input [31:0] expected_quotient;
        input [31:0] expected_remainder;
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
        $dumpvars(0,clk, dividend, divisor, start, done, quotient, remainder);
    end

endmodule
