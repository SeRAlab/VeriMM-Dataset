`timescale 1ns/1ps

module switching_regulator_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] feedback_voltage;
    reg [7:0] reference_voltage;
    reg reset;
    wire pwm_signal;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    switching_regulator dut (
        .clk(clk),
        .feedback_voltage(feedback_voltage),
        .reference_voltage(reference_voltage),
        .reset(reset),
        .pwm_signal(pwm_signal)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            feedback_voltage = 0;
            reference_voltage = 0;
            repeat(2) @(posedge clk);
            #1 reset = 0;
            repeat(1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Reference > Feedback (PWM should be ON)", test_num);
            reset_dut();
            reference_voltage = 8'd150;
            feedback_voltage = 8'd100;


            repeat(5) @(posedge clk);


            #1;



            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Reference < Feedback (PWM should be OFF)", test_num);
            reset_dut();
            reference_voltage = 8'd100;
            feedback_voltage = 8'd200;

            repeat(5) @(posedge clk);


            #1;



            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Reference == Feedback (PWM should be OFF/Idle)", test_num);
            reset_dut();
            reference_voltage = 8'd128;
            feedback_voltage = 8'd128;

            repeat(5) @(posedge clk);

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Max Reference, Min Feedback (PWM should be ON)", test_num);
            reset_dut();
            reference_voltage = 8'hFF;
            feedback_voltage = 8'h00;

            repeat(5) @(posedge clk);

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: Min Reference, Max Feedback (PWM should be OFF)", test_num);
            reset_dut();
            reference_voltage = 8'h00;
            feedback_voltage = 8'hFF;

            repeat(5) @(posedge clk);

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTestcase %0d: Small Error (Ref slightly higher than FB)", test_num);
            reset_dut();
            reference_voltage = 8'd75;
            feedback_voltage = 8'd70;

            repeat(5) @(posedge clk);

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
        $display("switching_regulator Testbench");
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
        input expected_pwm_signal;
        begin
            if (expected_pwm_signal === (expected_pwm_signal ^ pwm_signal ^ expected_pwm_signal)) begin
                $display("PASS");
                $display("  Outputs: pwm_signal=%b",
                         pwm_signal);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: pwm_signal=%b",
                         expected_pwm_signal);
                $display("  Got:      pwm_signal=%b",
                         pwm_signal);
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
        $dumpvars(0,clk, feedback_voltage, reference_voltage, reset, pwm_signal);
    end

endmodule
