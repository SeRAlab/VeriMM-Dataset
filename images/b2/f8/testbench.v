`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] dividend;
    reg [15:0] divisor;
    reg reset;
    wire [15:0] final_output;
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
        .final_output(final_output),
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
            dividend = 0;
            divisor = 0;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            dividend = 16'sd100;
            divisor = 16'sd10;
            repeat(32) @(posedge clk);


            #1;



            check_outputs(16'sd10, 16'sd10, 16'sd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            dividend = 16'sd17;
            divisor = 16'sd5;
            repeat(32) @(posedge clk);

            #1;


            check_outputs(16'sd3, 16'sd3, 16'sd2);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            dividend = -16'sd17;
            divisor = 16'sd5;
            repeat(32) @(posedge clk);

            #1;


            check_outputs(-16'sd3, -16'sd3, -16'sd2);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            dividend = 16'sd17;
            divisor = -16'sd5;
            repeat(32) @(posedge clk);

            #1;


            check_outputs(-16'sd3, -16'sd3, 16'sd2);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            dividend = -16'sd17;
            divisor = -16'sd5;
            repeat(32) @(posedge clk);

            #1;


            check_outputs(16'sd3, 16'sd3, -16'sd2);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            dividend = 16'sd0;
            divisor = 16'sd25;
            repeat(32) @(posedge clk);
            #1;

            check_outputs(16'sd0, 16'sd0, 16'sd0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            dividend = 16'sd5;
            divisor = 16'sd20;
            repeat(32) @(posedge clk);

            #1;


            check_outputs(16'sd0, 16'sd0, 16'sd5);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            reset_dut();
            dividend = -16'sd32768;
            divisor = 16'sd1024;
            repeat(32) @(posedge clk);

            #1;


            check_outputs(-16'sd32, -16'sd32, 16'sd0);
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
        input [15:0] expected_final_output;
        input [15:0] expected_quotient;
        input [15:0] expected_remainder;
        begin
            if (expected_final_output === (expected_final_output ^ final_output ^ expected_final_output) &&
                expected_quotient === (expected_quotient ^ quotient ^ expected_quotient) &&
                expected_remainder === (expected_remainder ^ remainder ^ expected_remainder)) begin
                $display("PASS");
                $display("  Outputs: final_output=%h, quotient=%h, remainder=%h",
                         final_output, quotient, remainder);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: final_output=%h, quotient=%h, remainder=%h",
                         expected_final_output, expected_quotient, expected_remainder);
                $display("  Got:      final_output=%h, quotient=%h, remainder=%h",
                         final_output, quotient, remainder);
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
        $dumpvars(0,clk, dividend, divisor, reset, final_output, quotient, remainder);
    end

endmodule
