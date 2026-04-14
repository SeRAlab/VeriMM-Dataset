`timescale 1ns/1ps

module kalman_filter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg [15:0] sensor1_measurement;
    reg [15:0] sensor2_measurement;
    wire [15:0] estimated_position;
    wire [15:0] estimated_velocity;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    kalman_filter dut (
        .clk(clk),
        .reset(reset),
        .sensor1_measurement(sensor1_measurement),
        .sensor2_measurement(sensor2_measurement),
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
            @(posedge clk);
            reset = 1;
            sensor1_measurement = 0;
            sensor2_measurement = 0;
            @(posedge clk);
            #1 reset = 0;
            $display("DUT Reset Complete");
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning testcase001: Zero Input...");
            test_num = 1;
            reset_dut();
            sensor1_measurement = 16'h0000;
            sensor2_measurement = 16'h0000;
            repeat(2) @(posedge clk);

            #1;


            check_outputs(16'h0000, 16'h0000);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning testcase002: Constant Position...");
            test_num = 2;
            reset_dut();
            sensor1_measurement = 16'h1000;
            sensor2_measurement = 16'h1000;
            repeat(5) @(posedge clk);


            #1;



            check_outputs(16'h0800, 16'h0000);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning testcase003: Sensor Fusion...");
            test_num = 3;
            reset_dut();
            sensor1_measurement = 16'h1000;
            sensor2_measurement = 16'h2000;
            repeat(2) @(posedge clk);

            #1;


            check_outputs(16'h0C00, 16'h0000);
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning testcase004: Negative Measurement...");
            test_num = 4;
            reset_dut();
            sensor1_measurement = 16'hFF00;
            sensor2_measurement = 16'hFF00;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(16'hFF80, 16'h0000);
        end
        endtask

    task testcase005;

        begin
            $display("\nRunning testcase005: Dynamic Movement...");
            test_num = 5;
            reset_dut();


            sensor1_measurement = 16'h0064;
            sensor2_measurement = 16'h0064;
            @(posedge clk);


            sensor1_measurement = 16'h00C8;
            sensor2_measurement = 16'h00C8;
            @(posedge clk);


            sensor1_measurement = 16'h012C;
            sensor2_measurement = 16'h012C;
            @(posedge clk);


            #1;



            check_outputs(16'h0090, 16'h0010);
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
        $dumpvars(0,clk, reset, sensor1_measurement, sensor2_measurement, estimated_position, estimated_velocity);
    end

endmodule
