`timescale 1ns/1ps

module non_restoring_divider_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] dividend;
    reg [7:0] divisor;
    reg reset;
    reg start;
    wire [7:0] quotient;
    wire remainder;

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
        .start(start),
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
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            $display("Testcase 001: 10 / 2");
            dividend = 8'd10;
            divisor = 8'd2;
            start = 1;
            @(posedge clk);
            start = 0;
            repeat(12) @(posedge clk);
            #1;

            check_outputs(8'd5, 1'b0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            $display("Testcase 002: 11 / 2");
            dividend = 8'd11;
            divisor = 8'd2;
            start = 1;
            @(posedge clk);
            start = 0;
            repeat(12) @(posedge clk);
            #1;

            check_outputs(8'd5, 1'b1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            $display("Testcase 003: 100 / 10");
            dividend = 8'd100;
            divisor = 8'd10;
            start = 1;
            @(posedge clk);
            start = 0;
            repeat(12) @(posedge clk);
            #1;

            check_outputs(8'd10, 1'b0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            $display("Testcase 004: 101 / 10");
            dividend = 8'd101;
            divisor = 8'd10;
            start = 1;
            @(posedge clk);
            start = 0;
            repeat(12) @(posedge clk);
            #1;

            check_outputs(8'd10, 1'b1);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            $display("Testcase 005: 255 / 255");
            dividend = 8'd255;
            divisor = 8'd255;
            start = 1;
            @(posedge clk);
            start = 0;
            repeat(12) @(posedge clk);
            #1;

            check_outputs(8'd1, 1'b0);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            $display("Testcase 006: 255 / 1");
            dividend = 8'd255;
            divisor = 8'd1;
            start = 1;
            @(posedge clk);
            start = 0;
            repeat(12) @(posedge clk);
            #1;

            check_outputs(8'd255, 1'b0);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            $display("Testcase 007: 0 / 50");
            dividend = 8'd0;
            divisor = 8'd50;
            start = 1;
            @(posedge clk);
            start = 0;
            repeat(12) @(posedge clk);
            #1;

            check_outputs(8'd0, 1'b0);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            $display("Testcase 008: 1 / 2");
            dividend = 8'd1;
            divisor = 8'd2;
            start = 1;
            @(posedge clk);
            start = 0;
            repeat(12) @(posedge clk);
            #1;

            check_outputs(8'd0, 1'b1);
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
        input [7:0] expected_quotient;
        input expected_remainder;
        begin
            if (expected_quotient === (expected_quotient ^ quotient ^ expected_quotient) &&
                expected_remainder === (expected_remainder ^ remainder ^ expected_remainder)) begin
                $display("PASS");
                $display("  Outputs: quotient=%h, remainder=%b",
                         quotient, remainder);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: quotient=%h, remainder=%b",
                         expected_quotient, expected_remainder);
                $display("  Got:      quotient=%h, remainder=%b",
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
        $dumpvars(0,clk, dividend, divisor, reset, start, quotient, remainder);
    end

endmodule
