`timescale 1ns/1ps

module fan_speed_control_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg [2:0] temperature;
    wire [1:0] fan_speed;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fan_speed_control dut (
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
            temperature = 3'b000;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            $display("Test %0d: Reset State", test_num);
            #1;

            check_outputs(OFF);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            temperature = 3'd0;
            @(posedge clk);
            #1;
            $display("Test %0d: Temperature 0 -> OFF", test_num);
            #1;

            check_outputs(OFF);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            temperature = 3'd1;
            @(posedge clk);
            #1;
            $display("Test %0d: Temperature 1 -> OFF", test_num);
            #1;

            check_outputs(OFF);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            temperature = 3'd2;
            @(posedge clk);
            #1;
            $display("Test %0d: Temperature 2 -> LOW", test_num);
            #1;

            check_outputs(LOW);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            temperature = 3'd3;
            @(posedge clk);
            #1;
            $display("Test %0d: Temperature 3 -> LOW", test_num);
            #1;

            check_outputs(LOW);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            temperature = 3'd4;
            @(posedge clk);
            #1;
            $display("Test %0d: Temperature 4 -> MEDIUM", test_num);
            #1;

            check_outputs(MEDIUM);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            temperature = 3'd5;
            @(posedge clk);
            #1;
            $display("Test %0d: Temperature 5 -> MEDIUM", test_num);
            #1;

            check_outputs(MEDIUM);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            reset_dut();
            temperature = 3'd6;
            @(posedge clk);
            #1;
            $display("Test %0d: Temperature 6 -> HIGH", test_num);
            #1;

            check_outputs(HIGH);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            reset_dut();
            temperature = 3'd7;
            @(posedge clk);
            #1;
            $display("Test %0d: Temperature 7 -> HIGH", test_num);
            #1;

            check_outputs(HIGH);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            reset_dut();

            temperature = 3'd7;
            @(posedge clk);

            #1 temperature = 3'd2;
            @(posedge clk);
            #1;
            $display("Test %0d: Transition HIGH to LOW", test_num);
            #1;

            check_outputs(LOW);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("fan_speed_control Testbench");
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
