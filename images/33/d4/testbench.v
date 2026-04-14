`timescale 1ns/1ps

module divider_4bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] dividend;
    reg [3:0] divisor;
    reg rst;
    wire done;
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
        .rst(rst),
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
            dividend = 0;
            divisor = 0;
            @(posedge clk);
            #1 rst = 0;

            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: 10 / 2 (Basic Division, No Remainder)", test_num);
            reset_dut();
            dividend = 4'd10;
            divisor = 4'd2;


            wait(done == 1);
            @(posedge clk);
            #1;

            check_outputs(1'b1, 4'd5, 4'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: 15 / 4 (Division with Remainder)", test_num);
            reset_dut();
            dividend = 4'd15;
            divisor = 4'd4;

            wait(done == 1);
            @(posedge clk);
            #1;

            check_outputs(1'b1, 4'd3, 4'd3);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: 3 / 7 (Dividend < Divisor)", test_num);
            reset_dut();
            dividend = 4'd3;
            divisor = 4'd7;

            wait(done == 1);
            @(posedge clk);
            #1;

            check_outputs(1'b1, 4'd0, 4'd3);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: 9 / 1 (Division by One)", test_num);
            reset_dut();
            dividend = 4'd9;
            divisor = 4'd1;

            wait(done == 1);
            @(posedge clk);
            #1;

            check_outputs(1'b1, 4'd9, 4'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: 12 / 12 (Dividend == Divisor)", test_num);
            reset_dut();
            dividend = 4'd12;
            divisor = 4'd12;

            wait(done == 1);
            @(posedge clk);
            #1;

            check_outputs(1'b1, 4'd1, 4'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: 0 / 5 (Zero Dividend)", test_num);
            reset_dut();
            dividend = 4'd0;
            divisor = 4'd5;

            wait(done == 1);
            @(posedge clk);
            #1;

            check_outputs(1'b1, 4'd0, 4'd0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: 15 / 2 (Max Dividend)", test_num);
            reset_dut();
            dividend = 4'd15;
            divisor = 4'd2;

            wait(done == 1);
            @(posedge clk);
            #1;

            check_outputs(1'b1, 4'd7, 4'd1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: 13 / 3 (Generic Case)", test_num);
            reset_dut();
            dividend = 4'd13;
            divisor = 4'd3;

            wait(done == 1);
            @(posedge clk);
            #1;

            check_outputs(1'b1, 4'd4, 4'd1);
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
        input expected_done;
        input [3:0] expected_quotient;
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
        $dumpvars(0,clk, dividend, divisor, rst, done, quotient, remainder);
    end

endmodule
