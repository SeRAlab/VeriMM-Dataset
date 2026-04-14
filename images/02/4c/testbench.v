`timescale 1ns/1ps

module restoring_divider_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] dividend;
    reg [3:0] divisor;
    reg reset;
    wire [7:0] quotient;
    wire [3:0] remainder;

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
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test %03d: Basic division (20 / 4)", test_num);
            dividend = 8'd20;
            divisor = 4'd4;
            reset_dut();
            repeat(15) @(posedge clk);
            #1;

            check_outputs(8'd5, 4'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %03d: Division with remainder (25 / 4)", test_num);
            dividend = 8'd25;
            divisor = 4'd4;
            reset_dut();
            repeat(15) @(posedge clk);
            #1;

            check_outputs(8'd6, 4'd1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %03d: Max values (255 / 15)", test_num);
            dividend = 8'd255;
            divisor = 4'd15;
            reset_dut();
            repeat(15) @(posedge clk);
            #1;

            check_outputs(8'd17, 4'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %03d: Dividend < Divisor (5 / 10)", test_num);
            dividend = 8'd5;
            divisor = 4'd10;
            reset_dut();
            repeat(15) @(posedge clk);
            #1;

            check_outputs(8'd0, 4'd5);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %03d: Zero Dividend (0 / 7)", test_num);
            dividend = 8'd0;
            divisor = 4'd7;
            reset_dut();
            repeat(15) @(posedge clk);
            #1;

            check_outputs(8'd0, 4'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %03d: Divide by 1 (128 / 1)", test_num);
            dividend = 8'd128;
            divisor = 4'd1;
            reset_dut();
            repeat(15) @(posedge clk);
            #1;

            check_outputs(8'd128, 4'd0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %03d: Complex division (123 / 7)", test_num);
            dividend = 8'd123;
            divisor = 4'd7;
            reset_dut();
            repeat(15) @(posedge clk);
            #1;

            check_outputs(8'd17, 4'd4);
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
        input [3:0] expected_remainder;
        begin
            if (expected_quotient === (expected_quotient ^ quotient ^ expected_quotient) &&
                expected_remainder === (expected_remainder ^ remainder ^ expected_remainder)) begin
                $display("PASS");
                $display("  Outputs: quotient=%h, remainder=%h",
                         quotient, remainder);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: quotient=%h, remainder=%h",
                         expected_quotient, expected_remainder);
                $display("  Got:      quotient=%h, remainder=%h",
                         quotient, remainder);
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
        $dumpvars(0,clk, dividend, divisor, reset, quotient, remainder);
    end

endmodule
