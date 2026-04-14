`timescale 1ns/1ps

module divider_4bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] denominator;
    reg [3:0] numerator;
    reg rst;
    wire error;
    wire [3:0] quotient;
    wire [3:0] remainder;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    divider_4bit dut (
        .clk(clk),
        .denominator(denominator),
        .numerator(numerator),
        .rst(rst),
        .error(error),
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
            rst = 1;
            numerator = 0;
            denominator = 0;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: Basic Exact Division (10 / 2)", test_num);
            numerator = 4'd10;
            denominator = 4'd2;

            repeat(10) @(posedge clk);
            #1;

            check_outputs(1'b0, 4'd5, 4'd0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: Division with Remainder (15 / 4)", test_num);
            numerator = 4'd15;
            denominator = 4'd4;
            repeat(10) @(posedge clk);
            #1;

            check_outputs(1'b0, 4'd3, 4'd3);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: Division by Zero (8 / 0)", test_num);
            numerator = 4'd8;
            denominator = 4'd0;
            repeat(10) @(posedge clk);
            #1;

            check_outputs(1'b1, quotient, remainder);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: Numerator < Denominator (3 / 7)", test_num);
            numerator = 4'd3;
            denominator = 4'd7;
            repeat(10) @(posedge clk);
            #1;

            check_outputs(1'b0, 4'd0, 4'd3);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: Zero Numerator (0 / 5)", test_num);
            numerator = 4'd0;
            denominator = 4'd5;
            repeat(10) @(posedge clk);
            #1;

            check_outputs(1'b0, 4'd0, 4'd0);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: Divide by One (15 / 1)", test_num);
            numerator = 4'd15;
            denominator = 4'd1;
            repeat(10) @(posedge clk);
            #1;

            check_outputs(1'b0, 4'd15, 4'd0);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: Divide by Self (12 / 12)", test_num);
            numerator = 4'd12;
            denominator = 4'd12;
            repeat(10) @(posedge clk);
            #1;

            check_outputs(1'b0, 4'd1, 4'd0);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: Large Remainder (11 / 6)", test_num);
            numerator = 4'd11;
            denominator = 4'd6;
            repeat(10) @(posedge clk);
            #1;

            check_outputs(1'b0, 4'd1, 4'd5);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("divider_4bit Testbench");
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
        input expected_error;
        input [3:0] expected_quotient;
        input [3:0] expected_remainder;
        begin
            if (expected_error === (expected_error ^ error ^ expected_error) &&
                expected_quotient === (expected_quotient ^ quotient ^ expected_quotient) &&
                expected_remainder === (expected_remainder ^ remainder ^ expected_remainder)) begin
                $display("PASS");
                $display("  Outputs: error=%b, quotient=%h, remainder=%h",
                         error, quotient, remainder);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: error=%b, quotient=%h, remainder=%h",
                         expected_error, expected_quotient, expected_remainder);
                $display("  Got:      error=%b, quotient=%h, remainder=%h",
                         error, quotient, remainder);
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
        $dumpvars(0,clk, denominator, numerator, rst, error, quotient, remainder);
    end

endmodule
