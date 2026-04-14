`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg direction;
    reg enable;
    reg [3:0] speed;
    wire pwm;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .direction(direction),
        .enable(enable),
        .speed(speed),
        .pwm(pwm)
    );

        task reset_dut;

    begin
        enable = 0;
        direction = 0;
        speed = 0;
        #10;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        reset_dut();
        enable = 0;
        direction = 0;
        speed = 50;
        #20;
        $display("Testcase %0d: PWM should be 0 when Enable is low", test_num);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        reset_dut();
        enable = 1;
        direction = 0;
        speed = 5;
        #20;
        $display("Testcase %0d: PWM should be 0 when speed is below range (<10)", test_num);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        reset_dut();
        enable = 1;
        direction = 0;
        speed = 50;
        #1;
        $display("Testcase %0d: PWM should be active (1) for valid speed/enable", test_num);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        reset_dut();
        enable = 1;
        direction = 1;
        speed = 50;
        #1;
        $display("Testcase %0d: PWM should be inverted (0) when direction is high", test_num);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        reset_dut();
        enable = 1;
        direction = 0;
        speed = 10;
        #1;
        $display("Testcase %0d: PWM should be active at boundary speed 10", test_num);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        reset_dut();
        enable = 1;
        direction = 0;
        speed = 120;
        #1;
        $display("Testcase %0d: PWM should be active for speed >= 100", test_num);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        reset_dut();
        enable = 0;
        direction = 1;
        speed = 50;
        #20;
        $display("Testcase %0d: Inactive PWM should be high (1) when direction is inverted", test_num);
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
        $dumpvars(0,direction, enable, speed, pwm);
    end

endmodule
