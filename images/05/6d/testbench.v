`timescale 1ns/1ps

module srt_divider_tb;

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
    srt_divider dut (
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
            start = 0;
            dividend = 0;
            divisor = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task execute_division;

        input [31:0] in_dividend;
        input [31:0] in_divisor;
        input [31:0] expected_q;
        input [31:0] expected_r;
        begin
            dividend = in_dividend;
            divisor = in_divisor;
            @(posedge clk);
            #1 start = 1;
            @(posedge clk);
            #1 start = 0;


            while (!done) @(posedge clk);


            #1;
            #1;

            check_outputs(1, expected_q, expected_r);
        end
        endtask

    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Positive Division (20 / 4)", test_num);
            reset_dut();
            execute_division(32'd20, 32'd4, 32'd5, 32'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Positive Division with Remainder (17 / 3)", test_num);
            reset_dut();
            execute_division(32'd17, 32'd3, 32'd5, 32'd2);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Negative Dividend (-17 / 3)", test_num);
            reset_dut();
            execute_division(-32'sd17, 32'sd3, -32'sd5, -32'sd2);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Negative Divisor (17 / -3)", test_num);
            reset_dut();
            execute_division(32'sd17, -32'sd3, -32'sd5, 32'sd2);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Both Negative (-17 / -3)", test_num);
            reset_dut();
            execute_division(-32'sd17, -32'sd3, 32'sd5, -32'sd2);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Zero Dividend (0 / 10)", test_num);
            reset_dut();
            execute_division(32'd0, 32'd10, 32'd0, 32'd0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Dividend < Divisor (5 / 10)", test_num);
            reset_dut();
            execute_division(32'd5, 32'd10, 32'd0, 32'd5);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Large Values (1000000 / 1000)", test_num);
            reset_dut();
            execute_division(32'd1000000, 32'd1000, 32'd1000, 32'd0);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Max Positive Integer (2147483647 / 1)", test_num);
            reset_dut();
            execute_division(32'h7FFFFFFF, 32'd1, 32'h7FFFFFFF, 32'd0);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Power of 2 Division (-1024 / 32)", test_num);
            reset_dut();
            execute_division(-32'sd1024, 32'sd32, -32'sd32, 32'd0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("srt_divider Testbench");
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
