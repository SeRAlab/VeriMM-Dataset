`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] PWM_in;
    reg clk;
    wire PWM_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .PWM_in(PWM_in),
        .clk(clk),
        .PWM_out(PWM_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            PWM_in = 8'h00;
            repeat(2) @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: PWM_in = 0 (0%% Duty Cycle)", test_num);
            reset_dut();
            PWM_in = 8'd0;
            repeat(10) @(negedge clk);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: PWM_in = 128 (50%% Duty Cycle) - 1st Cycle", test_num);
            reset_dut();
            PWM_in = 8'd128;
            @(posedge clk);
            @(negedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: PWM_in = 128 (50%% Duty Cycle) - 2nd Cycle", test_num);
            reset_dut();
            PWM_in = 8'd128;
            repeat(2) @(posedge clk);
            @(negedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: PWM_in = 255 (High Duty Cycle)", test_num);
            reset_dut();
            PWM_in = 8'd255;
            @(posedge clk);
            @(negedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: PWM_in = 64 (25%% Duty Cycle) - Initial state", test_num);
            reset_dut();
            PWM_in = 8'd64;
            @(posedge clk);
            @(negedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: PWM_in = 64 (25%% Duty Cycle) - Reaching threshold", test_num);
            reset_dut();
            PWM_in = 8'd64;
            repeat(2) @(posedge clk);
            @(negedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %03d: PWM_in = 1 (Very low duty cycle) - 128 cycles to high", test_num);
            reset_dut();
            PWM_in = 8'd1;
            repeat(128) @(posedge clk);
            @(negedge clk);
            #1;
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
        input expected_PWM_out;
        begin
            if (expected_PWM_out === (expected_PWM_out ^ PWM_out ^ expected_PWM_out)) begin
                $display("PASS");
                $display("  Outputs: PWM_out=%b",
                         PWM_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: PWM_out=%b",
                         expected_PWM_out);
                $display("  Got:      PWM_out=%b",
                         PWM_out);
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
        $dumpvars(0,PWM_in, clk, PWM_out);
    end

endmodule
