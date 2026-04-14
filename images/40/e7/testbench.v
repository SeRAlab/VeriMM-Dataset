`timescale 1ns/1ps

module kalman_filter_tb;

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
    kalman_filter dut (
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
            position_meas = 0;
            velocity_meas = 0;
            repeat(2) @(posedge clk);
            #1 rst = 0;
            repeat(1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Reset State Verification");
            reset_dut();
            #1;

            check_outputs(16'h0000, 16'h0000);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Constant Measurement Convergence");
            reset_dut();
            position_meas = 16'h1000;
            velocity_meas = 16'h0050;


            repeat(20) @(posedge clk);


            #1;



            check_outputs(16'h1000, 16'h0050);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Step Response Check");
            reset_dut();


            position_meas = 16'h0500;
            velocity_meas = 16'h0010;
            repeat(10) @(posedge clk);


            position_meas = 16'h2000;
            velocity_meas = 16'h00A0;


            repeat(30) @(posedge clk);

            #1;


            check_outputs(16'h2000, 16'h00A0);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Returning to Zero");
            reset_dut();


            position_meas = 16'hFFFF;
            velocity_meas = 16'h01FF;
            repeat(20) @(posedge clk);


            position_meas = 16'h0000;
            velocity_meas = 16'h0000;
            repeat(30) @(posedge clk);

            #1;


            check_outputs(16'h0000, 16'h0000);
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
