`timescale 1ns/1ps

module restoring_divider_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] dividend;
    reg [15:0] divisor;
    reg reset;
    reg start;
    wire busy;
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
        .start(start),
        .busy(busy),
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
        start = 0;
        dividend = 0;
        divisor = 0;
        @(posedge clk);
        #1 reset = 0;
        @(posedge clk);
    end
        endtask
    task run_division;

        input [15:0] in_dividend;
        input [15:0] in_divisor;
    begin
        dividend = in_dividend;
        divisor = in_divisor;
        @(posedge clk);
        #1 start = 1;
        @(posedge clk);
        #1 start = 0;


        wait(busy === 1);

        wait(busy === 0);
        @(posedge clk);
    end
        endtask

    task testcase001;

    begin
        $display("\nTest Case 001: Simple Exact Division (20 / 4)");
        reset_dut();
        run_division(16'd20, 16'd4);
        #1;

        check_outputs(1'b0, 16'd5, 16'd0);
    end
        endtask

    task testcase002;

    begin
        $display("\nTest Case 002: Division with Remainder (25 / 7)");
        reset_dut();
        run_division(16'd25, 16'd7);
        #1;

        check_outputs(1'b0, 16'd3, 16'd4);
    end
        endtask

    task testcase003;

    begin
        $display("\nTest Case 003: Dividend Smaller Than Divisor (5 / 10)");
        reset_dut();
        run_division(16'd5, 16'd10);
        #1;

        check_outputs(1'b0, 16'd0, 16'd5);
    end
        endtask

    task testcase004;

    begin
        $display("\nTest Case 004: Division by 1 (1000 / 1)");
        reset_dut();
        run_division(16'd1000, 16'd1);
        #1;

        check_outputs(1'b0, 16'd1000, 16'd0);
    end
        endtask

    task testcase005;

    begin
        $display("\nTest Case 005: Max Dividend / Max Divisor (65535 / 65535)");
        reset_dut();
        run_division(16'hFFFF, 16'hFFFF);
        #1;

        check_outputs(1'b0, 16'd1, 16'd0);
    end
        endtask

    task testcase006;

    begin
        $display("\nTest Case 006: Zero Dividend (0 / 50)");
        reset_dut();
        run_division(16'd0, 16'd50);
        #1;

        check_outputs(1'b0, 16'd0, 16'd0);
    end
        endtask

    task testcase007;

    begin
        $display("\nTest Case 007: Large Values (43981 / 18)");
        reset_dut();
        run_division(16'hABCD, 16'd18);
        #1;

        check_outputs(1'b0, 16'd2443, 16'd7);
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
        input expected_busy;
        input [15:0] expected_quotient;
        input [15:0] expected_remainder;
        begin
            if (expected_busy === (expected_busy ^ busy ^ expected_busy) &&
                expected_quotient === (expected_quotient ^ quotient ^ expected_quotient) &&
                expected_remainder === (expected_remainder ^ remainder ^ expected_remainder)) begin
                $display("PASS");
                $display("  Outputs: busy=%b, quotient=%h, remainder=%h",
                         busy, quotient, remainder);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: busy=%b, quotient=%h, remainder=%h",
                         expected_busy, expected_quotient, expected_remainder);
                $display("  Got:      busy=%b, quotient=%h, remainder=%h",
                         busy, quotient, remainder);
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
        $dumpvars(0,clk, dividend, divisor, reset, start, busy, quotient, remainder);
    end

endmodule
