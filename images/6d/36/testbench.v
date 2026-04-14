`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] dividend;
    reg [31:0] divisor;
    wire [31:0] quotient;

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
            divisor = 1;
            repeat(2) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test %0d: 100 / 5", test_num);
            dividend = 32'sd100;
            divisor = 32'sd5;
            repeat(32) @(posedge clk);
            #1;

            check_outputs(32'sd20);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test %0d: 50 / -2", test_num);
            dividend = 32'sd50;
            divisor = -32'sd2;
            repeat(32) @(posedge clk);
            #1;

            check_outputs(-32'sd25);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test %0d: -81 / 9", test_num);
            dividend = -32'sd81;
            divisor = 32'sd9;
            repeat(32) @(posedge clk);
            #1;

            check_outputs(-32'sd9);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test %0d: -144 / -12", test_num);
            dividend = -32'sd144;
            divisor = -32'sd12;
            repeat(32) @(posedge clk);
            #1;

            check_outputs(32'sd12);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test %0d: 0 / 10", test_num);
            dividend = 32'sd0;
            divisor = 32'sd10;
            repeat(32) @(posedge clk);
            #1;

            check_outputs(32'sd0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test %0d: 1000000 / 1000", test_num);
            dividend = 32'sd1000000;
            divisor = 32'sd1000;
            repeat(32) @(posedge clk);
            #1;

            check_outputs(32'sd1000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test %0d: 5 / 10", test_num);
            dividend = 32'sd5;
            divisor = 32'sd10;
            repeat(32) @(posedge clk);
            #1;

            check_outputs(32'sd0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test %0d: -555 / 1", test_num);
            dividend = -32'sd555;
            divisor = 32'sd1;
            repeat(32) @(posedge clk);
            #1;

            check_outputs(-32'sd555);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test %0d: 7 / 3 (Expect 2)", test_num);
            dividend = 32'sd7;
            divisor = 32'sd3;
            repeat(32) @(posedge clk);
            #1;

            check_outputs(32'sd2);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test %0d: -7 / 3 (Expect -2)", test_num);
            dividend = -32'sd7;
            divisor = 32'sd3;
            repeat(32) @(posedge clk);
            #1;

            check_outputs(-32'sd2);
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
        input [31:0] expected_quotient;
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
