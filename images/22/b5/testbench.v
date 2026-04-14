`timescale 1ns/1ps

module non_restoring_divider_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] dividend;
    reg [3:0] divisor;
    reg start;
    wire done;
    wire [7:0] quotient;
    wire [3:0] remainder;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    non_restoring_divider dut (
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
            dividend = 8'h0;
            divisor = 4'h0;
            start = 1'b0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test %0d: Basic Division (100 / 10)", test_num);
            dividend = 8'd100;
            divisor = 4'd10;
            start = 1'b1;
            @(posedge clk);
            #1 start = 1'b0;

            wait(done);
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 8'd10, 4'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test %0d: Division with Remainder (25 / 4)", test_num);
            dividend = 8'd25;
            divisor = 4'd4;
            start = 1'b1;
            @(posedge clk);
            #1 start = 1'b0;

            wait(done);
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 8'd6, 4'd1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test %0d: Max Dividend / Max Divisor (255 / 15)", test_num);
            dividend = 8'd255;
            divisor = 4'd15;
            start = 1'b1;
            @(posedge clk);
            #1 start = 1'b0;

            wait(done);
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 8'd17, 4'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test %0d: Max Dividend / Min Divisor (255 / 1)", test_num);
            dividend = 8'd255;
            divisor = 4'd1;
            start = 1'b1;
            @(posedge clk);
            #1 start = 1'b0;

            wait(done);
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 8'd255, 4'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test %0d: Dividend < Divisor (5 / 12)", test_num);
            dividend = 8'd5;
            divisor = 4'd12;
            start = 1'b1;
            @(posedge clk);
            #1 start = 1'b0;

            wait(done);
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 8'd0, 4'd5);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test %0d: Large Quotient and Remainder (200 / 13)", test_num);
            dividend = 8'd200;
            divisor = 4'd13;
            start = 1'b1;
            @(posedge clk);
            #1 start = 1'b0;

            wait(done);
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 8'd15, 4'd5);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test %0d: Dividend is Zero (0 / 7)", test_num);
            dividend = 8'd0;
            divisor = 4'd7;
            start = 1'b1;
            @(posedge clk);
            #1 start = 1'b0;

            wait(done);
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 8'd0, 4'd0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test %0d: Division resulting in 1 (15 / 15)", test_num);
            dividend = 8'd15;
            divisor = 4'd15;
            start = 1'b1;
            @(posedge clk);
            #1 start = 1'b0;

            wait(done);
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 8'd1, 4'd0);
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
        input [3:0] expected_remainder;
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
