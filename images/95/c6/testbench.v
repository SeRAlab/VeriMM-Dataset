`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] dividend;
    reg [7:0] divisor;
    wire [7:0] quotient;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .dividend(dividend),
        .divisor(divisor),
        .quotient(quotient)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            dividend = 0;
            divisor = 0;
            repeat (2) @(posedge clk);
        end
        endtask
    task run_test;

        input signed [7:0] in_dividend;
        input signed [7:0] in_divisor;
        input signed [7:0] expected_q;
        begin
            test_num = test_num + 1;
            $display("Test case %0d: %d / %d", test_num, in_dividend, in_divisor);
            dividend = in_dividend;
            divisor = in_divisor;


            repeat (20) @(posedge clk);

            #1;


            check_outputs(expected_q);
        end
        endtask

    task testcase001;

        begin
            reset_dut();
            run_test(8'sd20, 8'sd4, 8'sd5);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            run_test(-8'sd20, 8'sd4, -8'sd5);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            run_test(8'sd50, -8'sd5, -8'sd10);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            run_test(-8'sd100, -8'sd10, 8'sd10);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            run_test(8'sd0, 8'sd7, 8'sd0);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            run_test(8'sd127, 8'sd1, 8'sd127);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            run_test(8'sd64, -8'sd1, -8'sd64);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            run_test(8'sd3, 8'sd10, 8'sd0);
        end
        endtask

    task testcase009;

        begin
            reset_dut();
            run_test(-8'sd128, 8'sd2, -8'sd64);
        end
        endtask

    task testcase010;

        begin
            reset_dut();
            run_test(-8'sd45, -8'sd45, 8'sd1);
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
        testcase009();
        testcase010();
        
        
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
        begin
            if (expected_quotient === (expected_quotient ^ quotient ^ expected_quotient)) begin
                $display("PASS");
                $display("  Outputs: quotient=%h",
                         quotient);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: quotient=%h",
                         expected_quotient);
                $display("  Got:      quotient=%h",
                         quotient);
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
        $dumpvars(0,clk, dividend, divisor, quotient);
    end

endmodule
