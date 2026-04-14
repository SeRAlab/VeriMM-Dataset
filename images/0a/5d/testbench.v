`timescale 1ns/1ps

module fan_speed_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg [1:0] speed;
    wire fan_status;
    wire [2:0] pwm_signal;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fan_speed_controller dut (
        .clk(clk),
        .reset(reset),
        .speed(speed),
        .fan_status(fan_status),
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
            speed = 2'b00;
            @(posedge clk);
            #2;
            reset = 0;
            @(posedge clk);
            #2;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Speed 00 (Off)", test_num);
            reset_dut();
            speed = 2'b00;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, 3'b000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Speed 01 (Low)", test_num);
            reset_dut();
            speed = 2'b01;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 3'b010);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Speed 10 (Medium)", test_num);
            reset_dut();
            speed = 2'b10;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 3'b100);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Speed 11 (High)", test_num);
            reset_dut();
            speed = 2'b11;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 3'b111);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Transition High to Off", test_num);
            reset_dut();

            speed = 2'b11;
            @(posedge clk);
            #1;

            speed = 2'b00;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, 3'b000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("fan_speed_controller Testbench");
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
        input expected_fan_status;
        input [2:0] expected_pwm_signal;
        begin
            if (expected_fan_status === (expected_fan_status ^ fan_status ^ expected_fan_status) &&
                expected_pwm_signal === (expected_pwm_signal ^ pwm_signal ^ expected_pwm_signal)) begin
                $display("PASS");
                $display("  Outputs: fan_status=%b, pwm_signal=%h",
                         fan_status, pwm_signal);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: fan_status=%b, pwm_signal=%h",
                         expected_fan_status, expected_pwm_signal);
                $display("  Got:      fan_status=%b, pwm_signal=%h",
                         fan_status, pwm_signal);
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
        $dumpvars(0,clk, reset, speed, fan_status, pwm_signal);
    end

endmodule
