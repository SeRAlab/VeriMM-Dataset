`timescale 1ns/1ps

module non_restoring_divider_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] dividend;
    reg [7:0] divisor;
    reg rst;
    reg start;
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
            repeat (2) @(posedge clk);
            #1 rst = 0;
            repeat (1) @(posedge clk);
        end
        endtask
    task perform_division;

        input [7:0] in_dividend;
        input [7:0] in_divisor;
        input [7:0] exp_q;
        input [7:0] exp_r;
        begin
            @(posedge clk);
            dividend = in_dividend;
            divisor = in_divisor;
            start = 1;
            @(posedge clk);
            start = 0;


            fork: wait_or_timeout
                begin
                    wait(done == 1);
                end
                begin
                    repeat (100) @(posedge clk);
                end
            join_any
            disable wait_or_timeout;

            if (!done) begin
                $display("Error: Timeout waiting for done signal");
            end

            #1;


            check_outputs(1'b1, exp_q, exp_r);
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            $display("\nTest %0d: Standard division (25 / 7)", test_num);
            reset_dut();
            perform_division(8'd25, 8'd7, 8'd3, 8'd4);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTest %0d: Exact division (100 / 10)", test_num);
            reset_dut();
            perform_division(8'd100, 8'd10, 8'd10, 8'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTest %0d: Division by zero (50 / 0)", test_num);
            reset_dut();

            perform_division(8'd50, 8'd0, 8'd0, 8'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTest %0d: Dividend smaller than divisor (5 / 12)", test_num);
            reset_dut();
            perform_division(8'd5, 8'd12, 8'd0, 8'd5);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTest %0d: Dividend is zero (0 / 15)", test_num);
            reset_dut();
            perform_division(8'd0, 8'd15, 8'd0, 8'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTest %0d: Max dividend / 1 (255 / 1)", test_num);
            reset_dut();
            perform_division(8'd255, 8'd1, 8'd255, 8'd0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("\nTest %0d: Max values (255 / 255)", test_num);
            reset_dut();
            perform_division(8'd255, 8'd255, 8'd1, 8'd0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("\nTest %0d: Large values with remainder (200 / 13)", test_num);
            reset_dut();

            perform_division(8'd200, 8'd13, 8'd15, 8'd5);
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
        $dumpvars(0,clk, dividend, divisor, rst, start, done, quotient, remainder);
    end

endmodule
