`timescale 1ns/1ps

module SLAM_EKF_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] position_meas;
    reg rst;
    reg [15:0] velocity_meas;
    wire [15:0] estimated_position;
    wire [15:0] estimated_velocity;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    SLAM_EKF dut (
        .clk(clk),
        .position_meas(position_meas),
        .rst(rst),
        .velocity_meas(velocity_meas),
        .estimated_position(estimated_position),
        .estimated_velocity(estimated_velocity)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            position_meas = 16'h0;
            velocity_meas = 16'h0;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Starting Testcase %0d: Reset Behavior", test_num);
            reset_dut();

            #1;


            check_outputs(16'h0000, 16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Starting Testcase %0d: Static Input Convergence", test_num);
            reset_dut();
            position_meas = 16'h1000;
            velocity_meas = 16'h0010;

            repeat(20) @(posedge clk);


            #1;



            check_outputs(16'h1000, 16'h0010);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Starting Testcase %0d: Dynamic Tracking", test_num);
            reset_dut();

            for(i = 0; i < 10; i = i + 1) begin
                position_meas = 16'h0100 + (i * 16'h0010);
                velocity_meas = 16'h0010;
                @(posedge clk);
            end

            #1;


            check_outputs(16'h0190, 16'h0010);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Starting Testcase %0d: Noise Smoothing", test_num);
            reset_dut();

            position_meas = 16'h2000;
            velocity_meas = 16'h0000;
            repeat(10) @(posedge clk);


            position_meas = 16'hFFFF;
            @(posedge clk);


            position_meas = 16'h2000;
            repeat(5) @(posedge clk);


            #1;



            check_outputs(16'h2000, 16'h0000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Starting Testcase %0d: Max Range Processing", test_num);
            reset_dut();
            position_meas = 16'h0000;
            velocity_meas = 16'h7FFF;
            repeat(2) @(posedge clk);


            #1;



            check_outputs(16'hFFFE, 16'h7FFF);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("SLAM_EKF Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        
        
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
        input [15:0] expected_estimated_position;
        input [15:0] expected_estimated_velocity;
        begin
            if (expected_estimated_position === (expected_estimated_position ^ estimated_position ^ expected_estimated_position) &&
                expected_estimated_velocity === (expected_estimated_velocity ^ estimated_velocity ^ expected_estimated_velocity)) begin
                $display("PASS");
                $display("  Outputs: estimated_position=%h, estimated_velocity=%h",
                         estimated_position, estimated_velocity);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: estimated_position=%h, estimated_velocity=%h",
                         expected_estimated_position, expected_estimated_velocity);
                $display("  Got:      estimated_position=%h, estimated_velocity=%h",
                         estimated_position, estimated_velocity);
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
        $dumpvars(0,clk, position_meas, rst, velocity_meas, estimated_position, estimated_velocity);
    end

endmodule
