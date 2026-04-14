`timescale 1ns/1ps

module divider_4bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] dividend;
    reg [3:0] divisor;
    reg reset;
    wire div_by_zero;
    wire [3:0] quotient;
    wire [3:0] remainder;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    divider_4bit dut (
        .clk(clk),
        .dividend(dividend),
        .divisor(divisor),
        .reset(reset),
        .div_by_zero(div_by_zero),
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
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: 8 / 2", test_num);
            reset_dut();
            dividend = 4'd8;
            divisor = 4'd2;
            repeat(8) @(posedge clk);
            #1;

            check_outputs(1'b0, 4'd4, 4'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: 10 / 3", test_num);
            reset_dut();
            dividend = 4'd10;
            divisor = 4'd3;
            repeat(8) @(posedge clk);
            #1;

            check_outputs(1'b0, 4'd3, 4'd1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Division by Zero (5 / 0)", test_num);
            reset_dut();
            dividend = 4'd5;
            divisor = 4'd0;
            repeat(8) @(posedge clk);
            #1;

            check_outputs(1'b1, quotient, remainder);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: 2 / 5", test_num);
            reset_dut();
            dividend = 4'd2;
            divisor = 4'd5;
            repeat(8) @(posedge clk);
            #1;

            check_outputs(1'b0, 4'd0, 4'd2);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: 0 / 7", test_num);
            reset_dut();
            dividend = 4'd0;
            divisor = 4'd7;
            repeat(8) @(posedge clk);
            #1;

            check_outputs(1'b0, 4'd0, 4'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: 15 / 1", test_num);
            reset_dut();
            dividend = 4'd15;
            divisor = 4'd1;
            repeat(8) @(posedge clk);
            #1;

            check_outputs(1'b0, 4'd15, 4'd0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: 15 / 15", test_num);
            reset_dut();
            dividend = 4'd15;
            divisor = 4'd15;
            repeat(8) @(posedge clk);
            #1;

            check_outputs(1'b0, 4'd1, 4'd0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: 13 / 4", test_num);
            reset_dut();
            dividend = 4'd13;
            divisor = 4'd4;
            repeat(8) @(posedge clk);
            #1;

            check_outputs(1'b0, 4'd3, 4'd1);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: 7 / 2", test_num);
            reset_dut();
            dividend = 4'd7;
            divisor = 4'd2;
            repeat(8) @(posedge clk);
            #1;

            check_outputs(1'b0, 4'd3, 4'd1);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: 14 / 7", test_num);
            reset_dut();
            dividend = 4'd14;
            divisor = 4'd7;
            repeat(8) @(posedge clk);
            #1;

            check_outputs(1'b0, 4'd2, 4'd0);
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
        input expected_div_by_zero;
        input [3:0] expected_quotient;
        input [3:0] expected_remainder;
        begin
            if (expected_div_by_zero === (expected_div_by_zero ^ div_by_zero ^ expected_div_by_zero) &&
                expected_quotient === (expected_quotient ^ quotient ^ expected_quotient) &&
                expected_remainder === (expected_remainder ^ remainder ^ expected_remainder)) begin
                $display("PASS");
                $display("  Outputs: div_by_zero=%b, quotient=%h, remainder=%h",
                         div_by_zero, quotient, remainder);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: div_by_zero=%b, quotient=%h, remainder=%h",
                         expected_div_by_zero, expected_quotient, expected_remainder);
                $display("  Got:      div_by_zero=%b, quotient=%h, remainder=%h",
                         div_by_zero, quotient, remainder);
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
        $dumpvars(0,clk, dividend, divisor, reset, div_by_zero, quotient, remainder);
    end

endmodule
