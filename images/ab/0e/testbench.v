`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] pwm_in;
    reg rst;
    reg [15:0] set_point;
    wire [15:0] pwm_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .pwm_in(pwm_in),
        .rst(rst),
        .set_point(set_point),
        .pwm_out(pwm_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            pwm_in = 0;
            set_point = 0;
            #20;
            rst = 0;
            #20;
        end
        endtask
    task wait_cycles;

        input integer n;
        begin
            repeat(n) @(posedge clk);
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            pwm_in = 16'sd500;
            set_point = 16'sd500;
            wait_cycles(5);

            #1;


            check_outputs(16'sd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            pwm_in = 16'sd0;
            set_point = 16'sd1000;
            wait_cycles(1);
            #1;

            check_outputs(16'sd3000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            pwm_in = 16'sd0;
            set_point = 16'sd100;
            wait_cycles(3);
            #1;

            check_outputs(16'sd400);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            pwm_in = 16'sd1000;
            set_point = 16'sd500;
            wait_cycles(1);
            #1;

            check_outputs(16'shFA24);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();

            set_point = 16'sd100;
            pwm_in = 16'sd0;
            wait_cycles(1);

            pwm_in = 16'sd50;
            wait_cycles(1);

            #1;


            check_outputs(16'sd150);
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
        input [15:0] expected_pwm_out;
        begin
            if (expected_pwm_out === (expected_pwm_out ^ pwm_out ^ expected_pwm_out)) begin
                $display("PASS");
                $display("  Outputs: pwm_out=%h",
                         pwm_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: pwm_out=%h",
                         expected_pwm_out);
                $display("  Got:      pwm_out=%h",
                         pwm_out);
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
        $dumpvars(0,clk, pwm_in, rst, set_point, pwm_out);
    end

endmodule
