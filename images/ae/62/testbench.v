`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] dividend;
    reg [15:0] divisor;
    reg reset;
    wire [15:0] quotient;
    wire [15:0] remainder;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
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
            #1;
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: 100 / 7", test_num);
            dividend = 16'd100;
            divisor = 16'd7;
            reset_dut();

            repeat(16) @(posedge clk);
            #1;
            #1;

            check_outputs(16'd14, 16'd2);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: 5 / 12", test_num);
            dividend = 16'd5;
            divisor = 16'd12;
            reset_dut();
            repeat(16) @(posedge clk);
            #1;
            #1;

            check_outputs(16'd0, 16'd5);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: 1024 / 32", test_num);
            dividend = 16'd1024;
            divisor = 16'd32;
            reset_dut();
            repeat(16) @(posedge clk);
            #1;
            #1;

            check_outputs(16'd32, 16'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: 65535 / 1", test_num);
            dividend = 16'hFFFF;
            divisor = 16'd1;
            reset_dut();
            repeat(16) @(posedge clk);
            #1;
            #1;

            check_outputs(16'hFFFF, 16'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: 65535 / 65535", test_num);
            dividend = 16'hFFFF;
            divisor = 16'hFFFF;
            reset_dut();
            repeat(16) @(posedge clk);
            #1;
            #1;

            check_outputs(16'd1, 16'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: 40000 / 123", test_num);
            dividend = 16'd40000;
            divisor = 16'd123;
            reset_dut();
            repeat(16) @(posedge clk);
            #1;
            #1;

            check_outputs(16'd325, 16'd25);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: 0 / 500", test_num);
            dividend = 16'd0;
            divisor = 16'd500;
            reset_dut();
            repeat(16) @(posedge clk);
            #1;
            #1;

            check_outputs(16'd0, 16'd0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: 32768 / 2", test_num);
            dividend = 16'h8000;
            divisor = 16'd2;
            reset_dut();
            repeat(16) @(posedge clk);
            #1;
            #1;

            check_outputs(16'h4000, 16'd0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
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
        input [15:0] expected_quotient;
        input [15:0] expected_remainder;
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
