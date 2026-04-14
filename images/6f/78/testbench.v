`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg ctrl;
    reg dir;
    reg [1:0] in;
    reg pwm;
    reg step;
    wire [1:0] out;
    wire pwm_out;
    wire [3:0] stepper_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .ctrl(ctrl),
        .dir(dir),
        .in(in),
        .pwm(pwm),
        .step(step),
        .out(out),
        .pwm_out(pwm_out),
        .stepper_out(stepper_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            pwm = 0;
            ctrl = 0;
            in = 2'b00;
            step = 0;
            dir = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: H-bridge Forward + PWM High");
            reset_dut();
            pwm = 1;
            ctrl = 1;
            in = 2'b01;
            repeat(2) @(posedge clk);
            #1;

            #1;


            check_outputs(2'b01, 1'b1, 4'b0001);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: H-bridge Reverse + PWM Low");
            reset_dut();
            pwm = 0;
            ctrl = 1;
            in = 2'b10;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(2'b10, 1'b0, 4'b0001);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: H-bridge Disabled (ctrl=0)");
            reset_dut();
            pwm = 1;
            ctrl = 0;
            in = 2'b01;
            repeat(2) @(posedge clk);
            #1;

            #1;


            check_outputs(2'b00, 1'b1, 4'b0001);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Stepper single step forward (dir=1)");
            reset_dut();
            dir = 1;

            step = 1;
            @(posedge clk);
            #1;
            step = 0;
            repeat(2) @(posedge clk);
            #1;

            #1;


            check_outputs(2'b00, 1'b0, 4'b0010);
        end
        endtask

    task testcase005;

        integer i;
        begin
            $display("Running testcase005: Stepper 4 steps forward (wrap-around)");
            reset_dut();
            dir = 1;
            for(i=0; i<4; i=i+1) begin
                step = 1;
                @(posedge clk);
                #1;
                step = 0;
                @(posedge clk);
                #1;
            end

            #1;


            check_outputs(2'b00, 1'b0, 4'b0001);
        end
        endtask

    task testcase006;

        begin
            $display("Running testcase006: Stepper single step backward (dir=0)");
            reset_dut();
            dir = 0;

            step = 1;
            @(posedge clk);
            #1;
            step = 0;
            repeat(2) @(posedge clk);
            #1;

            #1;


            check_outputs(2'b00, 1'b0, 4'b1000);
        end
        endtask

    task testcase007;

        begin
            $display("Running testcase007: Combined H-bridge and Stepper operation");
            reset_dut();
            pwm = 1;
            ctrl = 1;
            in = 2'b10;
            dir = 1;

            repeat(2) begin
                step = 1; @(posedge clk); #1;
                step = 0; @(posedge clk); #1;
            end

            #1;


            check_outputs(2'b10, 1'b1, 4'b0100);
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
        input [1:0] expected_out;
        input expected_pwm_out;
        input [3:0] expected_stepper_out;
        begin
            if (expected_out === (expected_out ^ out ^ expected_out) &&
                expected_pwm_out === (expected_pwm_out ^ pwm_out ^ expected_pwm_out) &&
                expected_stepper_out === (expected_stepper_out ^ stepper_out ^ expected_stepper_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h, pwm_out=%b, stepper_out=%h",
                         out, pwm_out, stepper_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h, pwm_out=%b, stepper_out=%h",
                         expected_out, expected_pwm_out, expected_stepper_out);
                $display("  Got:      out=%h, pwm_out=%b, stepper_out=%h",
                         out, pwm_out, stepper_out);
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
        $dumpvars(0,clk, ctrl, dir, in, pwm, step, out, pwm_out, stepper_out);
    end

endmodule
