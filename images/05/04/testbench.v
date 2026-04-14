`timescale 1ns/1ps

module kalman_filter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg [15:0] sensor1_pos;
    reg [15:0] sensor2_pos;
    reg [7:0] timestamp1;
    reg [7:0] timestamp2;
    wire [15:0] estimated_pos;
    wire [15:0] estimated_vel;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    kalman_filter dut (
        .clk(clk),
        .reset(reset),
        .sensor1_pos(sensor1_pos),
        .sensor2_pos(sensor2_pos),
        .timestamp1(timestamp1),
        .timestamp2(timestamp2),
        .estimated_pos(estimated_pos),
        .estimated_vel(estimated_vel)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            sensor1_pos = 0;
            sensor2_pos = 0;
            timestamp1 = 0;
            timestamp2 = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Running Testcase 001: Stationary Object");
            test_num = 1;
            reset_dut();

            sensor1_pos = 16'd500;
            sensor2_pos = 16'd500;
            timestamp1  = 8'd10;
            timestamp2  = 8'd10;

            repeat(5) @(posedge clk);
            #1;

            check_outputs(16'd500, 16'd0);
        end
        endtask

    task testcase002;

        begin
            $display("Running Testcase 002: Constant Velocity Motion");
            test_num = 2;
            reset_dut();


            sensor1_pos = 16'd100;
            sensor2_pos = 16'd100;
            timestamp1  = 8'd10;
            timestamp2  = 8'd10;
            repeat(2) @(posedge clk);


            sensor1_pos = 16'd200;
            sensor2_pos = 16'd200;
            timestamp1  = 8'd20;
            timestamp2  = 8'd20;

            repeat(5) @(posedge clk);

            #1;


            check_outputs(16'd200, 16'd10);
        end
        endtask

    task testcase003;

        begin
            $display("Running Testcase 003: Sensor Fusion Disagreement");
            test_num = 3;
            reset_dut();

            sensor1_pos = 16'd1000;
            sensor2_pos = 16'd1100;
            timestamp1  = 8'd50;
            timestamp2  = 8'd50;

            repeat(5) @(posedge clk);

            #1;


            check_outputs(16'd1050, 16'd0);
        end
        endtask

    task testcase004;

        begin
            $display("Running Testcase 004: Zero Input Check");
            test_num = 4;
            reset_dut();

            sensor1_pos = 16'd0;
            sensor2_pos = 16'd0;
            timestamp1  = 8'd0;
            timestamp2  = 8'd0;

            repeat(2) @(posedge clk);
            #1;

            check_outputs(16'd0, 16'd0);
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
        input [15:0] expected_estimated_pos;
        input [15:0] expected_estimated_vel;
        begin
            if (expected_estimated_pos === (expected_estimated_pos ^ estimated_pos ^ expected_estimated_pos) &&
                expected_estimated_vel === (expected_estimated_vel ^ estimated_vel ^ expected_estimated_vel)) begin
                $display("PASS");
                $display("  Outputs: estimated_pos=%h, estimated_vel=%h",
                         estimated_pos, estimated_vel);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: estimated_pos=%h, estimated_vel=%h",
                         expected_estimated_pos, expected_estimated_vel);
                $display("  Got:      estimated_pos=%h, estimated_vel=%h",
                         estimated_pos, estimated_vel);
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
        $dumpvars(0,clk, reset, sensor1_pos, sensor2_pos, timestamp1, timestamp2, estimated_pos, estimated_vel);
    end

endmodule
