`timescale 1ns/1ps

module fan_speed_control_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg [7:0] temperature;
    wire [1:0] fan_speed;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fan_speed_control dut (
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
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            temperature = 8'd15;
            repeat(20) @(posedge clk);
            #1;

            check_outputs(SPEED_LOW);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            temperature = 8'd25;
            repeat(20) @(posedge clk);
            #1;

            check_outputs(SPEED_MEDIUM);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            temperature = 8'd45;
            repeat(20) @(posedge clk);
            #1;

            check_outputs(SPEED_HIGH);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            temperature = 8'd20;
            repeat(20) @(posedge clk);
            #1;

            check_outputs(SPEED_MEDIUM);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            temperature = 8'd30;
            repeat(20) @(posedge clk);
            #1;

            check_outputs(SPEED_MEDIUM);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            temperature = 8'd10;
            repeat(10) @(posedge clk);


            temperature = 8'd50;
            @(posedge clk);

            temperature = 8'd10;
            repeat(20) @(posedge clk);

            #1;


            check_outputs(SPEED_LOW);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            temperature = 8'd255;
            repeat(20) @(posedge clk);
            #1;

            check_outputs(SPEED_HIGH);
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
