`timescale 1ns/1ps

module restoring_divider_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] dividend;
    reg [15:0] divisor;
    reg reset;
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
        .reset(reset),
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
            reset = 1;
            start = 0;
            dividend = 0;
            divisor = 0;
            repeat(2) @(posedge clk);
            reset = 0;
            repeat(1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %03d: Basic Division (100 / 10)", test_num);
            dividend = 16'd100;
            divisor  = 16'd10;
            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;
            wait(done);
            #1;

            check_outputs(1'b1, 16'd10, 16'd0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %03d: Division with Remainder (50 / 7)", test_num);
            dividend = 16'd50;
            divisor  = 16'd7;
            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;
            wait(done);
            #1;

            check_outputs(1'b1, 16'd7, 16'd1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %03d: Dividend < Divisor (5 / 12)", test_num);
            dividend = 16'd5;
            divisor  = 16'd12;
            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;
            wait(done);
            #1;

            check_outputs(1'b1, 16'd0, 16'd5);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %03d: Max Dividend (65535 / 2)", test_num);
            dividend = 16'hFFFF;
            divisor  = 16'd2;
            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;
            wait(done);
            #1;

            check_outputs(1'b1, 16'h7FFF, 16'd1);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %03d: Identity Division (1234 / 1234)", test_num);
            dividend = 16'd1234;
            divisor  = 16'd1234;
            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;
            wait(done);
            #1;

            check_outputs(1'b1, 16'd1, 16'd0);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %03d: Large Quotient (60000 / 3)", test_num);
            dividend = 16'd60000;
            divisor  = 16'd3;
            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;
            wait(done);
            #1;

            check_outputs(1'b1, 16'd20000, 16'd0);
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
        $dumpvars(0,clk, dividend, divisor, reset, start, done, quotient, remainder);
    end

endmodule
