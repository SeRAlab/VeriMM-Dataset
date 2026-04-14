`timescale 1ns/1ps

module divider_8bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] dividend;
    reg [7:0] divisor;
    reg reset;
    wire [7:0] quotient;
    wire ready;
    wire [7:0] remainder;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    divider_8bit dut (
        .clk(clk),
        .dividend(dividend),
        .divisor(divisor),
        .reset(reset),
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
            reset = 1;
            dividend = 0;
            divisor = 0;
            @(posedge clk);
            #2 reset = 0;

            @(posedge clk);
        end
        endtask
    task wait_for_ready;

        begin

            fork : timeout_block
                begin
                    wait(ready == 1'b1);
                end
                begin
                    #2000;
                end
            join_any
            disable timeout_block;

            #1;
        end
        endtask

    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Simple Division (10 / 2)", test_num);
            reset_dut();
            dividend = 8'd10;
            divisor = 8'd2;
            wait_for_ready();
            #1;

            check_outputs(8'd5, 1'b1, 8'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Division with Remainder (17 / 3)", test_num);
            reset_dut();
            dividend = 8'd17;
            divisor = 8'd3;
            wait_for_ready();
            #1;

            check_outputs(8'd5, 1'b1, 8'd2);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Division by Zero (100 / 0)", test_num);
            reset_dut();
            dividend = 8'd100;
            divisor = 8'd0;
            wait_for_ready();
            #1;

            check_outputs(8'd255, 1'b1, 8'd255);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Dividend < Divisor (5 / 12)", test_num);
            reset_dut();
            dividend = 8'd5;
            divisor = 8'd12;
            wait_for_ready();
            #1;

            check_outputs(8'd0, 1'b1, 8'd5);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Zero Dividend (0 / 15)", test_num);
            reset_dut();
            dividend = 8'd0;
            divisor = 8'd15;
            wait_for_ready();
            #1;

            check_outputs(8'd0, 1'b1, 8'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Max Dividend (255 / 1)", test_num);
            reset_dut();
            dividend = 8'd255;
            divisor = 8'd1;
            wait_for_ready();
            #1;

            check_outputs(8'd255, 1'b1, 8'd0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Equal Values (42 / 42)", test_num);
            reset_dut();
            dividend = 8'd42;
            divisor = 8'd42;
            wait_for_ready();
            #1;

            check_outputs(8'd1, 1'b1, 8'd0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Large Numbers (200 / 7)", test_num);
            reset_dut();
            dividend = 8'd200;
            divisor = 8'd7;
            wait_for_ready();
            #1;

            check_outputs(8'd28, 1'b1, 8'd4);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("divider_8bit Testbench");
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
        $dumpvars(0,clk, dividend, divisor, reset, quotient, ready, remainder);
    end

endmodule
