`timescale 1ns/1ps

module divider_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] dividend;
    reg [3:0] divisor;
    reg reset;
    reg valid;
    wire [3:0] quotient;
    wire [3:0] remainder;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    divider dut (
        .clk(clk),
        .dividend(dividend),
        .divisor(divisor),
        .reset(reset),
        .valid(valid),
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
            reset = 1;
            valid = 0;
            dividend = 0;
            divisor = 0;
            @(posedge clk);
            reset = 0;
            @(posedge clk);
        end
        endtask
    task run_division;

        input [3:0] in_dividend;
        input [3:0] in_divisor;
        begin
            @(posedge clk);
            dividend = in_dividend;
            divisor = in_divisor;
            valid = 1;
            @(posedge clk);
            valid = 0;

            repeat(8) @(posedge clk);
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Division by Zero (10 / 0)", test_num);
            reset_dut();
            run_division(4'd10, 4'd0);
            #1;

            check_outputs(4'd0, 4'd10);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Exact Division (12 / 3)", test_num);
            reset_dut();
            run_division(4'd12, 4'd3);
            #1;

            check_outputs(4'd4, 4'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Division with Remainder (13 / 4)", test_num);
            reset_dut();
            run_division(4'd13, 4'd4);
            #1;

            check_outputs(4'd3, 4'd1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Dividend < Divisor (5 / 8)", test_num);
            reset_dut();
            run_division(4'd5, 4'd8);
            #1;

            check_outputs(4'd0, 4'd5);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Dividend = Divisor (7 / 7)", test_num);
            reset_dut();
            run_division(4'd7, 4'd7);
            #1;

            check_outputs(4'd1, 4'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Max values (15 / 1)", test_num);
            reset_dut();
            run_division(4'd15, 4'd1);
            #1;

            check_outputs(4'd15, 4'd0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Zero Dividend (0 / 5)", test_num);
            reset_dut();
            run_division(4'd0, 4'd5);
            #1;

            check_outputs(4'd0, 4'd0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: Large Remainder (15 / 8)", test_num);
            reset_dut();
            run_division(4'd15, 4'd8);
            #1;

            check_outputs(4'd1, 4'd7);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("divider Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        
        
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
        input [3:0] expected_quotient;
        input [3:0] expected_remainder;
        begin
            if (expected_quotient === (expected_quotient ^ quotient ^ expected_quotient) &&
                expected_remainder === (expected_remainder ^ remainder ^ expected_remainder)) begin
                $display("PASS");
                $display("  Outputs: quotient=%h, remainder=%h",
                         quotient, remainder);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: quotient=%h, remainder=%h",
                         expected_quotient, expected_remainder);
                $display("  Got:      quotient=%h, remainder=%h",
                         quotient, remainder);
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
        $dumpvars(0,clk, dividend, divisor, reset, valid, quotient, remainder);
    end

endmodule
