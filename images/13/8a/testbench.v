`timescale 1ns/1ps

module restoring_divider_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] dividend;
    reg [3:0] divisor;
    reg reset;
    reg start;
    wire [3:0] quotient;
    wire [3:0] remainder;
    wire valid;

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
        .quotient(quotient),
        .remainder(remainder),
        .valid(valid)
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
        @(posedge clk);
        #1 reset = 0;
        @(posedge clk);
    end
        endtask
    task run_division;

        input [3:0] in_dividend;
        input [3:0] in_divisor;
        input [3:0] exp_q;
        input [3:0] exp_r;
        begin
            test_num = test_num + 1;
            $display("Test Case %0d: %d / %d", test_num, in_dividend, in_divisor);
            dividend = in_dividend;
            divisor = in_divisor;
            start = 1;
            @(posedge clk);
            start = 0;


            fork
                begin
                    wait(valid === 1);
                end
                begin
                    repeat(20) @(posedge clk);
                    $display("Error: Timeout waiting for valid signal");
                end
            join_any
            disable fork;

            #1;
            #1;

            check_outputs(exp_q, exp_r, 1);
        end
        endtask

    task testcase001;

    begin
        reset_dut();
        run_division(4'd8, 4'd2, 4'd4, 4'd0);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        run_division(4'd7, 4'd3, 4'd2, 4'd1);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        run_division(4'd2, 4'd5, 4'd0, 4'd2);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        run_division(4'd13, 4'd1, 4'd13, 4'd0);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        run_division(4'd0, 4'd5, 4'd0, 4'd0);
    end
        endtask

    task testcase006;

    begin
        reset_dut();
        run_division(4'd15, 4'd4, 4'd3, 4'd3);
    end
        endtask

    task testcase007;

    begin
        reset_dut();
        run_division(4'd9, 4'd9, 4'd1, 4'd0);
    end
        endtask

    task testcase008;

    begin
        reset_dut();
        run_division(4'd11, 4'd6, 4'd1, 4'd5);
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
        input [3:0] expected_quotient;
        input [3:0] expected_remainder;
        input expected_valid;
        begin
            if (expected_quotient === (expected_quotient ^ quotient ^ expected_quotient) &&
                expected_remainder === (expected_remainder ^ remainder ^ expected_remainder) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: quotient=%h, remainder=%h, valid=%b",
                         quotient, remainder, valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: quotient=%h, remainder=%h, valid=%b",
                         expected_quotient, expected_remainder, expected_valid);
                $display("  Got:      quotient=%h, remainder=%h, valid=%b",
                         quotient, remainder, valid);
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
        $dumpvars(0,clk, dividend, divisor, reset, start, quotient, remainder, valid);
    end

endmodule
