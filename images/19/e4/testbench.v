`timescale 1ns/1ps

module non_restoring_divider_tb;

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
            repeat(2) @(posedge clk);
            #1 rst = 0;
            repeat(1) @(posedge clk);
        end
        endtask
    task run_division;

        input [15:0] den;
        input [15:0] dsr;
        begin
            dividend = den;
            divisor = dsr;
            @(posedge clk);
            #1 start = 1;
            @(posedge clk);
            #1 start = 0;


            wait(done);
            @(posedge clk);
            #1;
        end
        endtask

    task testcase001;

        begin
            $display("Testcase 001: 100 / 10");
            test_num = 1;
            reset_dut();
            run_division(16'd100, 16'd10);
            #1;

            check_outputs(1'b1, 16'd10, 16'd0);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: 1234 / 7");
            test_num = 2;
            reset_dut();
            run_division(16'd1234, 16'd7);
            #1;

            check_outputs(1'b1, 16'd176, 16'd2);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: 5 / 20");
            test_num = 3;
            reset_dut();
            run_division(16'd5, 16'd20);
            #1;

            check_outputs(1'b1, 16'd0, 16'd5);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: 500 / 1");
            test_num = 4;
            reset_dut();
            run_division(16'd500, 16'd1);
            #1;

            check_outputs(1'b1, 16'd500, 16'd0);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: 0 / 50");
            test_num = 5;
            reset_dut();
            run_division(16'd0, 16'd50);
            #1;

            check_outputs(1'b1, 16'd0, 16'd0);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: 65535 / 65535");
            test_num = 6;
            reset_dut();
            run_division(16'hFFFF, 16'hFFFF);
            #1;

            check_outputs(1'b1, 16'd1, 16'd0);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: 65535 / 2");
            test_num = 7;
            reset_dut();
            run_division(16'hFFFF, 16'd2);
            #1;

            check_outputs(1'b1, 16'd32767, 16'd1);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: 40000 / 13");
            test_num = 8;
            reset_dut();
            run_division(16'd40000, 16'd13);
            #1;

            check_outputs(1'b1, 16'd3076, 16'd12);
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
