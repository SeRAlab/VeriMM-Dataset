`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk_1m;
    reg [11:0] pwm_duty0;
    reg [11:0] pwm_duty1;
    wire [1:0] pwm_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk_1m(clk_1m),
        .pwm_duty0(pwm_duty0),
        .pwm_duty1(pwm_duty1),
        .pwm_out(pwm_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk_1m = 0;
        forever #5 clk_1m = ~clk_1m;
    end

        task reset_dut;

    begin
        pwm_duty0 = 0;
        pwm_duty1 = 0;


        if ((global_cnt % 20000) != 0) begin
            repeat (20000 - (global_cnt % 20000)) @(posedge clk_1m);
        end

        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        reset_dut();
        pwm_duty0 = 1000;
        pwm_duty1 = 2000;

        repeat(500) @(posedge clk_1m);
        #1;
        #1;

        check_outputs(2'b11);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        reset_dut();
        pwm_duty0 = 1000;
        pwm_duty1 = 2000;

        repeat(1500) @(posedge clk_1m);
        #1;
        #1;

        check_outputs(2'b10);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        reset_dut();
        pwm_duty0 = 1000;
        pwm_duty1 = 2000;

        repeat(2500) @(posedge clk_1m);
        #1;
        #1;

        check_outputs(2'b00);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        reset_dut();
        pwm_duty0 = 0;
        pwm_duty1 = 100;

        #1;


        check_outputs(2'b10);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        reset_dut();
        pwm_duty0 = 4095;
        pwm_duty1 = 4095;

        repeat(4094) @(posedge clk_1m);
        #1;
        #1;

        check_outputs(2'b11);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        reset_dut();
        pwm_duty0 = 4095;
        pwm_duty1 = 4095;

        repeat(4095) @(posedge clk_1m);
        #1;
        #1;

        check_outputs(2'b00);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        reset_dut();
        pwm_duty0 = 500;
        pwm_duty1 = 0;

        repeat(20000) @(posedge clk_1m);
        repeat(100) @(posedge clk_1m);
        #1;
        #1;

        check_outputs(2'b01);
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
        input [1:0] expected_pwm_out;
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
        $dumpvars(0,clk_1m, pwm_duty0, pwm_duty1, pwm_out);
    end

endmodule
