`timescale 1ns/1ps

module fan_speed_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg [7:0] temperature;
    wire [1:0] fan_speed;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fan_speed_controller dut (
        .clk(clk),
        .rst(rst),
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
            rst = 1;
            temperature = 0;
            @(posedge clk);
            #1 rst = 0;
        end
        endtask
    task testcase001;

        begin
            $display("Running Testcase 001: Temp < 20 (Off)");
            reset_dut();
            temperature = 15;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase002;

        begin
            $display("Running Testcase 002: Temp = 20 (Low)");
            reset_dut();
            temperature = 20;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase003;

        begin
            $display("Running Testcase 003: Temp = 22 (Low)");
            reset_dut();
            temperature = 22;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase004;

        begin
            $display("Running Testcase 004: Temp = 25 (Medium)");
            reset_dut();
            temperature = 25;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase005;

        begin
            $display("Running Testcase 005: Temp = 28 (Medium)");
            reset_dut();
            temperature = 28;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase006;

        begin
            $display("Running Testcase 006: Temp = 30 (High)");
            reset_dut();
            temperature = 30;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'b11);
        end
        endtask

    task testcase007;

        begin
            $display("Running Testcase 007: Temp = 50 (High)");
            reset_dut();
            temperature = 50;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'b11);
        end
        endtask

    task testcase008;

        begin
            $display("Running Testcase 008: Transition High -> Medium");
            reset_dut();

            temperature = 40;
            @(posedge clk);

            temperature = 27;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase009;

        begin
            $display("Running Testcase 009: Reset effect");
            reset_dut();
            temperature = 45;
            @(posedge clk);
            #1;
            rst = 1;
            #10;
            rst = 0;


            #1;



            check_outputs(2'b00);
        end
        endtask

    task testcase010;

        begin
            $display("Running Testcase 010: Temp = 19 (Off)");
            reset_dut();
            temperature = 19;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'b00);
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
        testcase008();
        testcase009();
        testcase010();
        
        
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
        $dumpvars(0,clk, rst, temperature, fan_speed);
    end

endmodule
