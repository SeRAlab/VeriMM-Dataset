`timescale 1ns/1ps

module fan_speed_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg [3:0] temperature;
    wire [1:0] fan_speed;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fan_speed_controller dut (
        .clk(clk),
        .reset(reset),
        .temperature(temperature),
        .fan_speed(fan_speed)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        temperature = 0;
        @(posedge clk);
        #1 reset = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        $display("\nRunning Testcase 001: Temp = 0 (Low)");
        reset_dut();
        temperature = 4'd0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(2'b00);
    end
        endtask

    task testcase002;

    begin
        $display("\nRunning Testcase 002: Temp = 5 (Low)");
        reset_dut();
        temperature = 4'd5;
        @(posedge clk);
        #1;
        #1;

        check_outputs(2'b00);
    end
        endtask

    task testcase003;

    begin
        $display("\nRunning Testcase 003: Temp = 6 (Medium)");
        reset_dut();
        temperature = 4'd6;
        @(posedge clk);
        #1;
        #1;

        check_outputs(2'b01);
    end
        endtask

    task testcase004;

    begin
        $display("\nRunning Testcase 004: Temp = 10 (Medium)");
        reset_dut();
        temperature = 4'd10;
        @(posedge clk);
        #1;
        #1;

        check_outputs(2'b01);
    end
        endtask

    task testcase005;

    begin
        $display("\nRunning Testcase 005: Temp = 11 (High)");
        reset_dut();
        temperature = 4'd11;
        @(posedge clk);
        #1;
        #1;

        check_outputs(2'b10);
    end
        endtask

    task testcase006;

    begin
        $display("\nRunning Testcase 006: Temp = 15 (High)");
        reset_dut();
        temperature = 4'd15;
        @(posedge clk);
        #1;
        #1;

        check_outputs(2'b10);
    end
        endtask

    task testcase007;

    begin
        $display("\nRunning Testcase 007: Sequential Update (Low -> Medium)");
        reset_dut();

        temperature = 4'd2;
        @(posedge clk);

        temperature = 4'd8;
        @(posedge clk);
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
        $display("fan_speed_controller Testbench");
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
        input [1:0] expected_fan_speed;
        begin
            if (expected_fan_speed === (expected_fan_speed ^ fan_speed ^ expected_fan_speed)) begin
                $display("PASS");
                $display("  Outputs: fan_speed=%h",
                         fan_speed);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: fan_speed=%h",
                         expected_fan_speed);
                $display("  Got:      fan_speed=%h",
                         fan_speed);
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
        $dumpvars(0,clk, reset, temperature, fan_speed);
    end

endmodule
