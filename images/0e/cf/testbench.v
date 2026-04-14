`timescale 1ns/1ps

module non_restoring_divider_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] dividend;
    reg [7:0] divisor;
    reg reset;
    wire done;
    wire [7:0] quotient;
    wire [7:0] remainder;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    non_restoring_divider dut (
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
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task wait_and_check;

        input [7:0] exp_q;
        input [7:0] exp_r;
        begin

            wait(done == 1);
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, exp_q, exp_r);
        end
        endtask

    task testcase001;

        begin
            $display("Test Case 001: 20 / 4");
            reset_dut();
            dividend = 8'd20;
            divisor  = 8'd4;
            wait_and_check(8'd5, 8'd0);
        end
        endtask

    task testcase002;

        begin
            $display("Test Case 002: 100 / 7");
            reset_dut();
            dividend = 8'd100;
            divisor  = 8'd7;
            wait_and_check(8'd14, 8'd2);
        end
        endtask

    task testcase003;

        begin
            $display("Test Case 003: 5 / 10");
            reset_dut();
            dividend = 8'd5;
            divisor  = 8'd10;
            wait_and_check(8'd0, 8'd5);
        end
        endtask

    task testcase004;

        begin
            $display("Test Case 004: 255 / 5");
            reset_dut();
            dividend = 8'd255;
            divisor  = 8'd5;
            wait_and_check(8'd51, 8'd0);
        end
        endtask

    task testcase005;

        begin
            $display("Test Case 005: 0 / 50");
            reset_dut();
            dividend = 8'd0;
            divisor  = 8'd50;
            wait_and_check(8'd0, 8'd0);
        end
        endtask

    task testcase006;

        begin
            $display("Test Case 006: 123 / 1");
            reset_dut();
            dividend = 8'd123;
            divisor  = 8'd1;
            wait_and_check(8'd123, 8'd0);
        end
        endtask

    task testcase007;

        begin
            $display("Test Case 007: 85 / 85");
            reset_dut();
            dividend = 8'd85;
            divisor  = 8'd85;
            wait_and_check(8'd1, 8'd0);
        end
        endtask

    task testcase008;

        begin
            $display("Test Case 008: 200 / 13");
            reset_dut();
            dividend = 8'd200;
            divisor  = 8'd13;
            wait_and_check(8'd15, 8'd5);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("non_restoring_divider Testbench");
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
        input expected_done;
        input [7:0] expected_quotient;
        input [7:0] expected_remainder;
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
