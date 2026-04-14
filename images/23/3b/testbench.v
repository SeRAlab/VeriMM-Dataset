`timescale 1ns/1ps

module SRT_Divider_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] dividend;
    reg [15:0] divisor;
    reg start;
    wire done;
    wire [15:0] quotient;
    wire [15:0] remainder;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    SRT_Divider dut (
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
            start = 0;
            dividend = 0;
            divisor = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task wait_until_done;

        begin
            @(posedge clk);
            while (!done) begin
                @(posedge clk);
            end
        end
        endtask

    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("\nTestcase %0d: Simple division (20 / 5)", test_num);
            dividend = 16'd20;
            divisor = 16'd5;
            start = 1;
            @(posedge clk);
            start = 0;
            wait_until_done();
            #1;

            check_outputs(1'b1, 16'd4, 16'd0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("\nTestcase %0d: Division with remainder (100 / 7)", test_num);
            dividend = 16'd100;
            divisor = 16'd7;
            start = 1;
            @(posedge clk);
            start = 0;
            wait_until_done();
            #1;

            check_outputs(1'b1, 16'd14, 16'd2);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("\nTestcase %0d: Dividend < Divisor (5 / 10)", test_num);
            dividend = 16'd5;
            divisor = 16'd10;
            start = 1;
            @(posedge clk);
            start = 0;
            wait_until_done();
            #1;

            check_outputs(1'b1, 16'd0, 16'd5);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("\nTestcase %0d: Division by 1 (500 / 1)", test_num);
            dividend = 16'd500;
            divisor = 16'd1;
            start = 1;
            @(posedge clk);
            start = 0;
            wait_until_done();
            #1;

            check_outputs(1'b1, 16'd500, 16'd0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("\nTestcase %0d: Large dividend (65535 / 2)", test_num);
            dividend = 16'hFFFF;
            divisor = 16'd2;
            start = 1;
            @(posedge clk);
            start = 0;
            wait_until_done();
            #1;

            check_outputs(1'b1, 16'd32767, 16'd1);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            $display("\nTestcase %0d: Random values (12345 / 123)", test_num);
            dividend = 16'd12345;
            divisor = 16'd123;
            start = 1;
            @(posedge clk);
            start = 0;
            wait_until_done();
            #1;

            check_outputs(1'b1, 16'd100, 16'd45);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = 7;
            $display("\nTestcase %0d: Zero Dividend (0 / 50)", test_num);
            dividend = 16'd0;
            divisor = 16'd50;
            start = 1;
            @(posedge clk);
            start = 0;
            wait_until_done();
            #1;

            check_outputs(1'b1, 16'd0, 16'd0);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            test_num = 8;
            $display("\nTestcase %0d: Max values (65535 / 65535)", test_num);
            dividend = 16'hFFFF;
            divisor = 16'hFFFF;
            start = 1;
            @(posedge clk);
            start = 0;
            wait_until_done();
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
        $display("SRT_Divider Testbench");
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
        $dumpvars(0,clk, dividend, divisor, start, done, quotient, remainder);
    end

endmodule
