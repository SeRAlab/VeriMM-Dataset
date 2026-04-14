`timescale 1ns/1ps

module restoring_divider_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] dividend;
    reg [15:0] divisor;
    reg rst;
    reg start;
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
        .rst(rst),
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
            rst = 1;
            start = 0;
            dividend = 0;
            divisor = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task run_division;

        input [15:0] in_dividend;
        input [15:0] in_divisor;
        begin
            dividend = in_dividend;
            divisor = in_divisor;
            start = 1;
            @(posedge clk);
            #1 start = 0;


            fork : wait_or_timeout
                begin
                    wait(done == 1);
                end
                begin
                    repeat (100) @(posedge clk);
                end
            join_any
            disable wait_or_timeout;


            @(posedge clk);
        end
        endtask

    task testcase001;

        begin
            $display("Test Case 001: 100 / 10");
            reset_dut();
            run_division(16'd100, 16'd10);
            #1;

            check_outputs(1'b1, 16'd10, 16'd0);
        end
        endtask

    task testcase002;

        begin
            $display("Test Case 002: 25 / 7");
            reset_dut();
            run_division(16'd25, 16'd7);
            #1;

            check_outputs(1'b1, 16'd3, 16'd4);
        end
        endtask

    task testcase003;

        begin
            $display("Test Case 003: 5 / 20");
            reset_dut();
            run_division(16'd5, 16'd20);
            #1;

            check_outputs(1'b1, 16'd0, 16'd5);
        end
        endtask

    task testcase004;

        begin
            $display("Test Case 004: 500 / 1");
            reset_dut();
            run_division(16'd500, 16'd1);
            #1;

            check_outputs(1'b1, 16'd500, 16'd0);
        end
        endtask

    task testcase005;

        begin
            $display("Test Case 005: 10 / 0 (Division by Zero)");
            reset_dut();
            run_division(16'd10, 16'd0);


            if (done === 1) begin
                $display("  PASS: System handled division by zero without hanging.");
                pass_count = pass_count + 1;
            end else begin
                $display("  FAIL: System hung or did not assert done for division by zero.");
                fail_count = fail_count + 1;
            end
        end
        endtask

    task testcase006;

        begin
            $display("Test Case 006: 65535 / 255");
            reset_dut();
            run_division(16'hFFFF, 16'd255);
            #1;

            check_outputs(1'b1, 16'd257, 16'd0);
        end
        endtask

    task testcase007;

        begin
            $display("Test Case 007: 0 / 100");
            reset_dut();
            run_division(16'd0, 16'd100);
            #1;

            check_outputs(1'b1, 16'd0, 16'd0);
        end
        endtask

    task testcase008;

        begin
            $display("Test Case 008: 65535 / 65535");
            reset_dut();
            run_division(16'hFFFF, 16'hFFFF);
            #1;

            check_outputs(1'b1, 16'd1, 16'd0);
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
        $dumpvars(0,clk, dividend, divisor, rst, start, done, quotient, remainder);
    end

endmodule
