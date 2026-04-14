`timescale 1ns/1ps

module divider_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] dividend;
    reg [7:0] divisor;
    reg start;
    wire [7:0] quotient;
    wire ready;
    wire [7:0] remainder;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    divider dut (
        .clk(clk),
        .dividend(dividend),
        .divisor(divisor),
        .start(start),
        .quotient(quotient),
        .ready(ready),
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
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Simple division (20 / 4)", test_num);
            reset_dut();
            dividend = 8'd20;
            divisor = 8'd4;
            start = 1;
            @(posedge clk);
            #1 start = 0;

            wait(ready === 1'b1);
            #1 #1;
 check_outputs(8'd5, 1'b1, 8'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Division with remainder (15 / 4)", test_num);
            reset_dut();
            dividend = 8'd15;
            divisor = 8'd4;
            start = 1;
            @(posedge clk);
            #1 start = 0;
            wait(ready === 1'b1);
            #1 #1;
 check_outputs(8'd3, 1'b1, 8'd3);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Dividend < Divisor (5 / 10)", test_num);
            reset_dut();
            dividend = 8'd5;
            divisor = 8'd10;
            start = 1;
            @(posedge clk);
            #1 start = 0;
            wait(ready === 1'b1);
            #1 #1;
 check_outputs(8'd0, 1'b1, 8'd5);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Division by 1 (100 / 1)", test_num);
            reset_dut();
            dividend = 8'd100;
            divisor = 8'd1;
            start = 1;
            @(posedge clk);
            #1 start = 0;
            wait(ready === 1'b1);
            #1 #1;
 check_outputs(8'd100, 1'b1, 8'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Maximum Dividend (255 / 2)", test_num);
            reset_dut();
            dividend = 8'd255;
            divisor = 8'd2;
            start = 1;
            @(posedge clk);
            #1 start = 0;
            wait(ready === 1'b1);
            #1 #1;
 check_outputs(8'd127, 1'b1, 8'd1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Equal Dividend and Divisor (128 / 128)", test_num);
            reset_dut();
            dividend = 8'd128;
            divisor = 8'd128;
            start = 1;
            @(posedge clk);
            #1 start = 0;
            wait(ready === 1'b1);
            #1 #1;
 check_outputs(8'd1, 1'b1, 8'd0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Zero Dividend (0 / 50)", test_num);
            reset_dut();
            dividend = 8'd0;
            divisor = 8'd50;
            start = 1;
            @(posedge clk);
            #1 start = 0;
            wait(ready === 1'b1);
            #1 #1;
 check_outputs(8'd0, 1'b1, 8'd0);
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
        input [7:0] expected_quotient;
        input expected_ready;
        input [7:0] expected_remainder;
        begin
            if (expected_quotient === (expected_quotient ^ quotient ^ expected_quotient) &&
                expected_ready === (expected_ready ^ ready ^ expected_ready) &&
                expected_remainder === (expected_remainder ^ remainder ^ expected_remainder)) begin
                $display("PASS");
                $display("  Outputs: quotient=%h, ready=%b, remainder=%h",
                         quotient, ready, remainder);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: quotient=%h, ready=%b, remainder=%h",
                         expected_quotient, expected_ready, expected_remainder);
                $display("  Got:      quotient=%h, ready=%b, remainder=%h",
                         quotient, ready, remainder);
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
        $dumpvars(0,clk, dividend, divisor, start, quotient, ready, remainder);
    end

endmodule
