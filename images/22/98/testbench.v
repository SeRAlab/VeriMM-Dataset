`timescale 1ns/1ps

module fan_speed_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg mode;
    reg reset;
    reg [4:0] temperature;
    wire fan_speed;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fan_speed_controller dut (
        .clk(clk),
        .mode(mode),
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
            mode = 0;
            temperature = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Reset check", test_num);
            reset_dut();
            #1;

            check_outputs(0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Mode 0, Temperature 20 (Should be OFF)", test_num);
            reset_dut();
            mode = 0;
            temperature = 20;
            @(posedge clk);
            #1 #1;
 check_outputs(0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Mode 0, Temperature 21 (Should be ON)", test_num);
            reset_dut();
            mode = 0;
            temperature = 21;
            @(posedge clk);
            #1 #1;
 check_outputs(1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Mode 1, Temperature 15 (Should be OFF)", test_num);
            reset_dut();
            mode = 1;
            temperature = 15;
            @(posedge clk);
            #1 #1;
 check_outputs(0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Mode 1, Temperature 16 (Should be ON)", test_num);
            reset_dut();
            mode = 1;
            temperature = 16;
            @(posedge clk);
            #1 #1;
 check_outputs(1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Mode 0, Max Temperature 31 (Should be ON)", test_num);
            reset_dut();
            mode = 0;
            temperature = 31;
            @(posedge clk);
            #1 #1;
 check_outputs(1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Mode 1, Temperature 5 (Should be OFF)", test_num);
            reset_dut();
            mode = 1;
            temperature = 5;
            @(posedge clk);
            #1 #1;
 check_outputs(0);
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
        input expected_fan_speed;
        begin
            if (expected_fan_speed === (expected_fan_speed ^ fan_speed ^ expected_fan_speed)) begin
                $display("PASS");
                $display("  Outputs: fan_speed=%b",
                         fan_speed);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: fan_speed=%b",
                         expected_fan_speed);
                $display("  Got:      fan_speed=%b",
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
        $dumpvars(0,clk, mode, reset, temperature, fan_speed);
    end

endmodule
