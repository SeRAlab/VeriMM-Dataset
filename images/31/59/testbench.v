`timescale 1ns/1ps

module FanSpeedController_tb;

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
    FanSpeedController dut (
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
            #1;
            rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Test Case %0d: Temperature = 15 (Below 20)", test_num);
            temperature = 8'd15;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'd0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Test Case %0d: Temperature = 20 (Boundary)", test_num);
            temperature = 8'd20;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'd1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Test Case %0d: Temperature = 25 (Between 20-30)", test_num);
            temperature = 8'd25;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'd1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Test Case %0d: Temperature = 30 (Boundary)", test_num);
            temperature = 8'd30;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'd2);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Test Case %0d: Temperature = 35 (Between 30-40)", test_num);
            temperature = 8'd35;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'd2);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            $display("Test Case %0d: Temperature = 40 (Boundary)", test_num);
            temperature = 8'd40;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'd2);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = 7;
            $display("Test Case %0d: Temperature = 45 (Above 40)", test_num);
            temperature = 8'd45;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'd3);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            test_num = 8;
            $display("Test Case %0d: Temperature = 0 (Extreme Low)", test_num);
            temperature = 8'd0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'd0);
        end
        endtask

    task testcase009;

        begin
            reset_dut();
            test_num = 9;
            $display("Test Case %0d: Temperature = 255 (Extreme High)", test_num);
            temperature = 8'd255;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'd3);
        end
        endtask

    task testcase010;

        begin
            reset_dut();
            test_num = 10;
            $display("Test Case %0d: Rapid Change (255 down to 10)", test_num);

            temperature = 8'd255;
            @(posedge clk);

            temperature = 8'd10;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'd0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("FanSpeedController Testbench");
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
