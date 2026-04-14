`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg LOCKED;
    reg clk;
    reg [31:0] clk_period_1000;
    reg [31:0] desired_duty_cycle_1000;
    reg reset;
    wire fail;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .LOCKED(LOCKED),
        .clk(clk),
        .clk_period_1000(clk_period_1000),
        .desired_duty_cycle_1000(desired_duty_cycle_1000),
        .reset(reset),
        .fail(fail)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        LOCKED = 0;
        clk_period_1000 = 0;
        desired_duty_cycle_1000 = 0;
        repeat(2) @(posedge clk);
        #1 reset = 0;
        repeat(1) @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = 1;


        clk_period_1000 = 32'd10000;
        desired_duty_cycle_1000 = 32'd500;
        LOCKED = 1;
        repeat(5) @(posedge clk);
        #2 #1;
 check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = 2;


        clk_period_1000 = 32'd10000;
        desired_duty_cycle_1000 = 32'd400;
        LOCKED = 1;
        repeat(5) @(posedge clk);
        #2 #1;
 check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = 3;

        clk_period_1000 = 32'd10000;
        desired_duty_cycle_1000 = 32'd200;
        LOCKED = 0;
        repeat(5) @(posedge clk);
        #2 #1;
 check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = 4;


        clk_period_1000 = 32'd8000;
        desired_duty_cycle_1000 = 32'd500;
        LOCKED = 1;
        repeat(5) @(posedge clk);
        #2 #1;
 check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = 5;

        clk_period_1000 = 32'd10000;
        desired_duty_cycle_1000 = 32'd700;
        LOCKED = 1;
        repeat(3) @(posedge clk);

        reset = 1;
        #15;
        #1;

        check_outputs(1'b0);
        reset = 0;
    end
        endtask

    task testcase006;

    begin
        reset_dut();
        test_num = 6;

        clk_period_1000 = 32'd10000;
        desired_duty_cycle_1000 = 32'd100;
        LOCKED = 1;
        repeat(3) @(posedge clk);

        LOCKED = 0;
        repeat(2) @(posedge clk);
        #2 #1;
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
        input expected_fail;
        begin
            if (expected_fail === (expected_fail ^ fail ^ expected_fail)) begin
                $display("PASS");
                $display("  Outputs: fail=%b",
                         fail);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: fail=%b",
                         expected_fail);
                $display("  Got:      fail=%b",
                         fail);
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
        $dumpvars(0,LOCKED, clk, clk_period_1000, desired_duty_cycle_1000, reset, fail);
    end

endmodule
