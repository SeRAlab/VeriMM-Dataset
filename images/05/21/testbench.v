`timescale 1ns/1ps

module SLAM_Module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg [4:0] sensor_reading;
    wire [4:0] position_estimate;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    SLAM_Module dut (
        .clk(clk),
        .reset(reset),
        .sensor_reading(sensor_reading),
        .position_estimate(position_estimate)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        sensor_reading = 0;
        @(posedge clk);
        #1;
        reset = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %03d: Simple addition of a single sensor reading", test_num);
        reset_dut();
        sensor_reading = 5'd10;
        @(posedge clk);
        sensor_reading = 5'd0;
        #1;

        check_outputs(5'd10);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %03d: Cumulative addition of multiple readings", test_num);
        reset_dut();
        sensor_reading = 5'd5;
        @(posedge clk);
        sensor_reading = 5'd7;
        @(posedge clk);
        sensor_reading = 5'd2;
        @(posedge clk);
        sensor_reading = 5'd0;
        #1;

        check_outputs(5'd14);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %03d: Check 5-bit overflow/wrap-around logic", test_num);
        reset_dut();
        sensor_reading = 5'd20;
        @(posedge clk);
        sensor_reading = 5'd15;
        @(posedge clk);
        sensor_reading = 5'd0;
        #1;

        check_outputs(5'd3);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %03d: Adding zero sensor reading", test_num);
        reset_dut();
        sensor_reading = 5'd0;
        @(posedge clk);
        @(posedge clk);
        #1;

        check_outputs(5'd0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %03d: Multiple maximum value additions", test_num);
        reset_dut();
        sensor_reading = 5'h1F;
        @(posedge clk);
        sensor_reading = 5'h1F;
        @(posedge clk);
        sensor_reading = 5'd0;
        #1;

        check_outputs(5'd30);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %03d: Reset mid-operation", test_num);
        reset_dut();
        sensor_reading = 5'd10;
        @(posedge clk);
        reset = 1;
        @(posedge clk);
        reset = 0;
        sensor_reading = 5'd2;
        @(posedge clk);
        sensor_reading = 5'd0;
        #1;

        check_outputs(5'd2);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("SLAM_Module Testbench");
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
        input [4:0] expected_position_estimate;
        begin
            if (expected_position_estimate === (expected_position_estimate ^ position_estimate ^ expected_position_estimate)) begin
                $display("PASS");
                $display("  Outputs: position_estimate=%h",
                         position_estimate);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: position_estimate=%h",
                         expected_position_estimate);
                $display("  Got:      position_estimate=%h",
                         position_estimate);
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
        $dumpvars(0,clk, reset, sensor_reading, position_estimate);
    end

endmodule
