`timescale 1ns/1ps

module fan_speed_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] temperature;
    wire high_speed;
    wire low_speed;
    wire medium_speed;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fan_speed_controller dut (
        .clk(clk),
        .temperature(temperature),
        .high_speed(high_speed),
        .low_speed(low_speed),
        .medium_speed(medium_speed)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            temperature = 8'd0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            $display("Testcase %03d: Temperature = 15 (Expected: Low Speed)", test_num);
            temperature = 8'd15;
            @(posedge clk);
            #1;
            #1;

            check_outputs(0, 1, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            $display("Testcase %03d: Temperature = 20 (Expected: Medium Speed)", test_num);
            temperature = 8'd20;
            @(posedge clk);
            #1;
            #1;

            check_outputs(0, 0, 1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            $display("Testcase %03d: Temperature = 25 (Expected: Medium Speed)", test_num);
            temperature = 8'd25;
            @(posedge clk);
            #1;
            #1;

            check_outputs(0, 0, 1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            $display("Testcase %03d: Temperature = 30 (Expected: Medium Speed)", test_num);
            temperature = 8'd30;
            @(posedge clk);
            #1;
            #1;

            check_outputs(0, 0, 1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            $display("Testcase %03d: Temperature = 31 (Expected: High Speed)", test_num);
            temperature = 8'd31;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1, 0, 0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            $display("Testcase %03d: Temperature = 19 (Expected: Low Speed)", test_num);
            temperature = 8'd19;
            @(posedge clk);
            #1;
            #1;

            check_outputs(0, 1, 0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            $display("Testcase %03d: Temperature = 255 (Expected: High Speed)", test_num);
            temperature = 8'd255;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1, 0, 0);
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
        input expected_high_speed;
        input expected_low_speed;
        input expected_medium_speed;
        begin
            if (expected_high_speed === (expected_high_speed ^ high_speed ^ expected_high_speed) &&
                expected_low_speed === (expected_low_speed ^ low_speed ^ expected_low_speed) &&
                expected_medium_speed === (expected_medium_speed ^ medium_speed ^ expected_medium_speed)) begin
                $display("PASS");
                $display("  Outputs: high_speed=%b, low_speed=%b, medium_speed=%b",
                         high_speed, low_speed, medium_speed);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: high_speed=%b, low_speed=%b, medium_speed=%b",
                         expected_high_speed, expected_low_speed, expected_medium_speed);
                $display("  Got:      high_speed=%b, low_speed=%b, medium_speed=%b",
                         high_speed, low_speed, medium_speed);
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
        $dumpvars(0,clk, temperature, high_speed, low_speed, medium_speed);
    end

endmodule
