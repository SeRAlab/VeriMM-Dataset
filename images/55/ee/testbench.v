`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg dir;
    reg [7:0] duty_cycle;
    reg step;
    wire enable;
    wire step_dir;
    wire [3:0] step_pulse;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .dir(dir),
        .duty_cycle(duty_cycle),
        .step(step),
        .enable(enable),
        .step_dir(step_dir),
        .step_pulse(step_pulse)
    );

    // Clock generation (10ns period)
    initial begin
        step = 0;
        forever #5 step = ~step;
    end

        task reset_dut;

        begin
            dir = 0;
            duty_cycle = 0;

            @(posedge step);
            @(posedge step);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Idle state (duty_cycle = 0)", test_num);
            reset_dut();

            dir = 0;
            duty_cycle = 8'h00;

            repeat(4) @(posedge step);
            #2;

            #1;


            check_outputs(1'b0, 1'b0, 4'b0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Forward movement (dir = 0, duty_cycle = 255)", test_num);
            reset_dut();

            dir = 0;
            duty_cycle = 8'hFF;


            repeat(8) @(posedge step);
            #2;




            #1;





            check_outputs(1'b1, 1'b0, 4'b0001);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Backward movement (dir = 1, duty_cycle = 128)", test_num);
            reset_dut();

            dir = 1;
            duty_cycle = 8'h80;

            repeat(8) @(posedge step);
            #2;
            #1;

            check_outputs(1'b1, 1'b1, 4'b1000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Direction change mid-operation", test_num);
            reset_dut();

            duty_cycle = 8'hFF;
            dir = 0;
            repeat(4) @(posedge step);

            dir = 1;
            repeat(4) @(posedge step);
            #2;

            #1;


            check_outputs(1'b1, 1'b1, 4'b1000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Low non-zero duty cycle", test_num);
            reset_dut();

            dir = 0;
            duty_cycle = 8'h01;

            repeat(2) @(posedge step);
            #2;


            #1;



            check_outputs(1'b1, 1'b0, 4'b0100);
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
        input expected_enable;
        input expected_step_dir;
        input [3:0] expected_step_pulse;
        begin
            if (expected_enable === (expected_enable ^ enable ^ expected_enable) &&
                expected_step_dir === (expected_step_dir ^ step_dir ^ expected_step_dir) &&
                expected_step_pulse === (expected_step_pulse ^ step_pulse ^ expected_step_pulse)) begin
                $display("PASS");
                $display("  Outputs: enable=%b, step_dir=%b, step_pulse=%h",
                         enable, step_dir, step_pulse);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: enable=%b, step_dir=%b, step_pulse=%h",
                         expected_enable, expected_step_dir, expected_step_pulse);
                $display("  Got:      enable=%b, step_dir=%b, step_pulse=%h",
                         enable, step_dir, step_pulse);
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
        $dumpvars(0,dir, duty_cycle, step, enable, step_dir, step_pulse);
    end

endmodule
