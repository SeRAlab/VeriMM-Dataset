`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data;
    reg [15:0] duty_cycle;
    wire pwm;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data(data),
        .duty_cycle(duty_cycle),
        .pwm(pwm)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            data = 8'h00;
            duty_cycle = 16'h0000;
            repeat(2) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Pulse disabled via data input", test_num);
            reset_dut();
            data = 8'h00;
            duty_cycle = 16'hFFFF;
            repeat(10) @(posedge clk);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Zero duty cycle", test_num);
            reset_dut();
            data = 8'hFF;
            duty_cycle = 16'h0000;
            repeat(10) @(posedge clk);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Maximum duty cycle", test_num);
            reset_dut();
            data = 8'hFF;
            duty_cycle = 16'hFFFF;

            repeat(5) @(posedge clk);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Mid-range duty cycle (High Phase)", test_num);
            reset_dut();
            data = 8'h01;
            duty_cycle = 16'd1000;
            repeat(10) @(posedge clk);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Data mask during active cycle", test_num);
            reset_dut();
            data = 8'hFF;
            duty_cycle = 16'hF000;
            repeat(10) @(posedge clk);
            data = 8'h00;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(1'b0);
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
        input expected_pwm;
        begin
            if (expected_pwm === (expected_pwm ^ pwm ^ expected_pwm)) begin
                $display("PASS");
                $display("  Outputs: pwm=%b",
                         pwm);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: pwm=%b",
                         expected_pwm);
                $display("  Got:      pwm=%b",
                         pwm);
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
        $dumpvars(0,clk, data, duty_cycle, pwm);
    end

endmodule
