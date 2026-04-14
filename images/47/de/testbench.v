`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg addr;
    reg clk;
    reg [19:0] i_data;
    reg wr_n;
    wire o_pwm;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr(addr),
        .clk(clk),
        .i_data(i_data),
        .wr_n(wr_n),
        .o_pwm(o_pwm)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            wr_n = 1;
            addr = 0;
            i_data = 0;
            repeat(2) @(posedge clk);
        end
        endtask
    task write_reg;

        input a;
        input [19:0] d;
        begin
            @(posedge clk);
            addr = a;
            i_data = d;
            wr_n = 0;
            @(posedge clk);
            wr_n = 1;
            i_data = 0;
        end
        endtask

    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Standard PWM - High Phase Check", test_num);
            reset_dut();
            write_reg(0, 20'd100);
            write_reg(1, 20'd40);
            repeat(10) @(posedge clk);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Standard PWM - Low Phase Check", test_num);
            reset_dut();
            write_reg(0, 20'd100);
            write_reg(1, 20'd40);
            repeat(60) @(posedge clk);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: 0%% Duty Cycle Check", test_num);
            reset_dut();
            write_reg(0, 20'd50);
            write_reg(1, 20'd0);
            repeat(20) @(posedge clk);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: 100%% Duty Cycle Check", test_num);
            reset_dut();
            write_reg(0, 20'd50);
            write_reg(1, 20'd50);
            repeat(20) @(posedge clk);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Large Value Check", test_num);
            reset_dut();
            write_reg(0, 20'hFFFFF);
            write_reg(1, 20'h80000);
            repeat(100) @(posedge clk);
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
        input expected_o_pwm;
        begin
            if (expected_o_pwm === (expected_o_pwm ^ o_pwm ^ expected_o_pwm)) begin
                $display("PASS");
                $display("  Outputs: o_pwm=%b",
                         o_pwm);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o_pwm=%b",
                         expected_o_pwm);
                $display("  Got:      o_pwm=%b",
                         o_pwm);
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
        $dumpvars(0,addr, clk, i_data, wr_n, o_pwm);
    end

endmodule
