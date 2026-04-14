`timescale 1ns/1ps

module temperature_sensor_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg [7:0] temperature;
    wire active;
    wire alarm;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    temperature_sensor_controller dut (
        .clk(clk),
        .rst(rst),
        .temperature(temperature),
        .active(active),
        .alarm(alarm)
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
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %03d: Temperature = 25 (Below Threshold)", test_num);
        reset_dut();
        temperature = 8'd25;
        repeat(2) @(posedge clk);
        #1 #1;
 check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %03d: Temperature = 75 (At Threshold boundary)", test_num);
        reset_dut();
        temperature = 8'd75;
        repeat(2) @(posedge clk);
        #1 #1;
 check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %03d: Temperature = 76 (Just Above Threshold)", test_num);
        reset_dut();
        temperature = 8'd76;
        repeat(2) @(posedge clk);
        #1 #1;
 check_outputs(1'b1, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %03d: Temperature = 255 (Max Value)", test_num);
        reset_dut();
        temperature = 8'd255;
        repeat(2) @(posedge clk);
        #1 #1;
 check_outputs(1'b1, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %03d: System Inactive During Reset", test_num);

        rst = 1;
        temperature = 8'd100;
        repeat(1) @(posedge clk);
        #1 #1;
 check_outputs(1'b0, 1'b0);

        #1 rst = 0;
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %03d: Transition from Safe to Alarm", test_num);
        reset_dut();
        temperature = 8'd50;
        @(posedge clk);
        temperature = 8'd80;
        repeat(2) @(posedge clk);
        #1 #1;
 check_outputs(1'b1, 1'b1);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("temperature_sensor_controller Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        
        
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
        input expected_active;
        input expected_alarm;
        begin
            if (expected_active === (expected_active ^ active ^ expected_active) &&
                expected_alarm === (expected_alarm ^ alarm ^ expected_alarm)) begin
                $display("PASS");
                $display("  Outputs: active=%b, alarm=%b",
                         active, alarm);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: active=%b, alarm=%b",
                         expected_active, expected_alarm);
                $display("  Got:      active=%b, alarm=%b",
                         active, alarm);
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
        $dumpvars(0,clk, rst, temperature, active, alarm);
    end

endmodule
