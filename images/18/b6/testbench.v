`timescale 1ns/1ps

module switching_regulator_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] actual_voltage;
    reg clk;
    reg [7:0] desired_voltage;
    reg rst;
    wire pwm_signal;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    switching_regulator dut (
        .actual_voltage(actual_voltage),
        .clk(clk),
        .desired_voltage(desired_voltage),
        .rst(rst),
        .pwm_signal(pwm_signal)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            actual_voltage = 0;
            desired_voltage = 0;
            #20;
            rst = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Undervoltage (High Duty Cycle Demand)", test_num);
            reset_dut();
            desired_voltage = 8'd200;
            actual_voltage = 8'd50;

            repeat (2000) @(posedge clk);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Overvoltage (Low Duty Cycle Demand)", test_num);
            reset_dut();
            desired_voltage = 8'd50;
            actual_voltage = 8'd200;

            repeat (2000) @(posedge clk);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Reset State Verification", test_num);
            rst = 1;
            actual_voltage = 8'd255;
            desired_voltage = 8'd255;
            #40;
            #1;

            check_outputs(1'b0);
            rst = 0;
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Max Positive Error", test_num);
            reset_dut();
            desired_voltage = 8'hFF;
            actual_voltage = 8'h00;
            repeat (3000) @(posedge clk);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Zero Error Initial State", test_num);
            reset_dut();
            desired_voltage = 8'd128;
            actual_voltage = 8'd128;
            repeat (500) @(posedge clk);
            #1;

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
        $display("switching_regulator Testbench");
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
        $dumpvars(0,actual_voltage, clk, desired_voltage, rst, pwm_signal);
    end

endmodule
