`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg cs;
    reg [9:0] divisor;
    reg in_clock;
    wire i2cclk;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .cs(cs),
        .divisor(divisor),
        .in_clock(in_clock),
        .i2cclk(i2cclk)
    );

    // Clock generation (10ns period)
    initial begin
        in_clock = 0;
        forever #5 in_clock = ~in_clock;
    end

        task reset_dut;

        begin
            cs = 0;
            divisor = 0;
            #20;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Divisor=1, check after 4 cycles", test_num);
            divisor = 10'd1;
            cs = 1;
            #40;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Divisor=2, check after 3 cycles (half period)", test_num);
            divisor = 10'd2;
            cs = 1;
            #30;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: CS=0, divisor=1, clock should not toggle", test_num);
            divisor = 10'd1;
            cs = 0;
            #100;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Divisor=4, check after 10 cycles (full period)", test_num);
            divisor = 10'd4;
            cs = 1;
            #100;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Divisor=0, fast toggle check", test_num);
            divisor = 10'd0;
            cs = 1;
            #20;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Divisor=9, check half period (10 cycles)", test_num);
            divisor = 10'd9;
            cs = 1;
            #100;
            #1;

            check_outputs(1'b1);
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
        input expected_i2cclk;
        begin
            if (expected_i2cclk === (expected_i2cclk ^ i2cclk ^ expected_i2cclk)) begin
                $display("PASS");
                $display("  Outputs: i2cclk=%b",
                         i2cclk);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: i2cclk=%b",
                         expected_i2cclk);
                $display("  Got:      i2cclk=%b",
                         i2cclk);
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
        $dumpvars(0,cs, divisor, in_clock, i2cclk);
    end

endmodule
