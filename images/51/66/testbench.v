`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg [7:0] dutyCycle;
    reg reset;
    wire done;
    wire pwm;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .dutyCycle(dutyCycle),
        .reset(reset),
        .done(done),
        .pwm(pwm)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            reset = 1;
            dutyCycle = 0;
            @(posedge clock);
            #1 reset = 0;
            @(posedge clock);
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: 0%% Duty Cycle");
            test_num = 1;
            reset = 1;
            dutyCycle = 8'd0;
            @(posedge clock);
            #1 reset = 0;
            repeat(10) @(posedge clock);

            #1;


            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Max (255/256) Duty Cycle");
            test_num = 2;
            reset = 1;
            dutyCycle = 8'hFF;
            @(posedge clock);
            #1 reset = 0;
            repeat(10) @(posedge clock);

            #1;


            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: 50%% Duty Cycle");
            test_num = 3;
            reset = 1;
            dutyCycle = 8'd128;
            @(posedge clock);
            #1 reset = 0;
            repeat(20) @(posedge clock);

            #1;


            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Minimum Non-Zero Duty Cycle (1/256)");
            test_num = 4;
            reset = 1;
            dutyCycle = 8'd1;
            @(posedge clock);
            #1 reset = 0;
            repeat(5) @(posedge clock);

            #1;


            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Reset Recovery with High Duty Cycle");
            test_num = 5;

            reset = 1;
            dutyCycle = 8'd200;
            @(posedge clock);
            #1 reset = 0;
            repeat(50) @(posedge clock);


            reset = 1;
            @(posedge clock);
            #1 reset = 0;
            repeat(5) @(posedge clock);


            #1;



            check_outputs(1'b0, 1'b1);
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
        input expected_done;
        input expected_pwm;
        begin
            if (expected_done === (expected_done ^ done ^ expected_done) &&
                expected_pwm === (expected_pwm ^ pwm ^ expected_pwm)) begin
                $display("PASS");
                $display("  Outputs: done=%b, pwm=%b",
                         done, pwm);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: done=%b, pwm=%b",
                         expected_done, expected_pwm);
                $display("  Got:      done=%b, pwm=%b",
                         done, pwm);
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
        $dumpvars(0,clock, dutyCycle, reset, done, pwm);
    end

endmodule
