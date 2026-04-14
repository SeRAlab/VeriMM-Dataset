`timescale 1ns/1ps

module divider_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] dividend;
    reg [7:0] divisor;
    reg reset;
    reg start;
    wire done;
    wire [7:0] quotient;
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
            repeat (2) @(posedge clk);
            reset = 0;
            @(posedge clk);
        end
        endtask
    task start_division;

        input [7:0] in_dividend;
        input [7:0] in_divisor;
        begin
            dividend = in_dividend;
            divisor = in_divisor;
            start = 1;
            @(posedge clk);
            start = 0;
        end
        endtask

    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: 100 / 10", test_num);
            reset_dut();
            start_division(8'd100, 8'd10);
            wait(done);
            @(posedge clk);
            #1;

            check_outputs(1'b1, 8'd10, 8'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: 25 / 4", test_num);
            reset_dut();
            start_division(8'd25, 8'd4);
            wait(done);
            @(posedge clk);
            #1;

            check_outputs(1'b1, 8'd6, 8'd1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Divide by Zero (50 / 0)", test_num);
            reset_dut();
            start_division(8'd50, 8'd0);
            wait(done);
            @(posedge clk);
            #1;

            check_outputs(1'b1, 8'd0, 8'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Dividend < Divisor (5 / 20)", test_num);
            reset_dut();
            start_division(8'd5, 8'd20);
            wait(done);
            @(posedge clk);
            #1;

            check_outputs(1'b1, 8'd0, 8'd5);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Max Dividend (255 / 2)", test_num);
            reset_dut();
            start_division(8'd255, 8'd2);
            wait(done);
            @(posedge clk);
            #1;

            check_outputs(1'b1, 8'd127, 8'd1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Division by 1 (255 / 1)", test_num);
            reset_dut();
            start_division(8'd255, 8'd1);
            wait(done);
            @(posedge clk);
            #1;

            check_outputs(1'b1, 8'd255, 8'd0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Same values (128 / 128)", test_num);
            reset_dut();
            start_division(8'd128, 8'd128);
            wait(done);
            @(posedge clk);
            #1;

            check_outputs(1'b1, 8'd1, 8'd0);
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
        $dumpvars(0,clk, dividend, divisor, reset, start, done, quotient, remainder);
    end

endmodule
