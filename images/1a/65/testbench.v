`timescale 1ns/1ps

module kalman_filter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] measurement;
    reg [15:0] position_estimate;
    reg reset;
    reg [15:0] velocity_estimate;
    wire [15:0] new_position_estimate;
    wire [15:0] new_velocity_estimate;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    kalman_filter dut (
        .clk(clk),
        .measurement(measurement),
        .position_estimate(position_estimate),
        .reset(reset),
        .velocity_estimate(velocity_estimate),
        .new_position_estimate(new_position_estimate),
        .new_velocity_estimate(new_velocity_estimate)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            measurement = 16'h0000;
            position_estimate = 16'h0000;
            velocity_estimate = 16'h0000;
            @(posedge clk);
            #2;
            reset = 0;
            @(posedge clk);
            #2;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Reset and Zero Inputs", test_num);
            reset_dut();
            measurement = 16'h0000;
            position_estimate = 16'h0000;
            velocity_estimate = 16'h0000;
            @(posedge clk);
            #2;
            #1;

            check_outputs(16'h0000, 16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Steady State Tracking", test_num);
            reset_dut();
            position_estimate = 16'd100;
            velocity_estimate = 16'd0;
            measurement = 16'd100;
            @(posedge clk);
            #2;

            #1;


            check_outputs(16'd100, 16'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Constant Velocity Movement", test_num);
            reset_dut();
            position_estimate = 16'd100;
            velocity_estimate = 16'd10;
            measurement = 16'd110;
            @(posedge clk);
            #2;
            #1;

            check_outputs(16'd110, 16'd10);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Positive Correction", test_num);
            reset_dut();
            position_estimate = 16'd100;
            velocity_estimate = 16'd0;
            measurement = 16'd120;
            @(posedge clk);
            #2;

            #1;


            check_outputs(16'd110, 16'd2);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Negative Correction", test_num);
            reset_dut();
            position_estimate = 16'd200;
            velocity_estimate = 16'd10;
            measurement = 16'd190;
            @(posedge clk);
            #2;
            #1;

            check_outputs(16'd200, 16'd8);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Large Values", test_num);
            reset_dut();
            position_estimate = 16'h4000;
            velocity_estimate = 16'h0100;
            measurement = 16'h4200;
            @(posedge clk);
            #2;



            #1;




            check_outputs(16'h4180, 16'h0120);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("kalman_filter Testbench");
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
        input [15:0] expected_new_position_estimate;
        input [15:0] expected_new_velocity_estimate;
        begin
            if (expected_new_position_estimate === (expected_new_position_estimate ^ new_position_estimate ^ expected_new_position_estimate) &&
                expected_new_velocity_estimate === (expected_new_velocity_estimate ^ new_velocity_estimate ^ expected_new_velocity_estimate)) begin
                $display("PASS");
                $display("  Outputs: new_position_estimate=%h, new_velocity_estimate=%h",
                         new_position_estimate, new_velocity_estimate);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: new_position_estimate=%h, new_velocity_estimate=%h",
                         expected_new_position_estimate, expected_new_velocity_estimate);
                $display("  Got:      new_position_estimate=%h, new_velocity_estimate=%h",
                         new_position_estimate, new_velocity_estimate);
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
        $dumpvars(0,clk, measurement, position_estimate, reset, velocity_estimate, new_position_estimate, new_velocity_estimate);
    end

endmodule
