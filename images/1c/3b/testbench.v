`timescale 1ns/1ps

module KalmanFilter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg [15:0] sensor1_position;
    reg [15:0] sensor1_velocity;
    reg [15:0] sensor2_position;
    reg [15:0] sensor2_velocity;
    wire [15:0] estimated_position;
    wire [15:0] estimated_velocity;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    KalmanFilter dut (
        .clk(clk),
        .reset(reset),
        .sensor1_position(sensor1_position),
        .sensor1_velocity(sensor1_velocity),
        .sensor2_position(sensor2_position),
        .sensor2_velocity(sensor2_velocity),
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
            reset = 1;
            sensor1_position = 16'd0;
            sensor1_velocity = 16'd0;
            sensor2_position = 16'd0;
            sensor2_velocity = 16'd0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Identical Sensor Inputs", test_num);
            reset_dut();
            sensor1_position = 16'h0100;
            sensor1_velocity = 16'h0010;
            sensor2_position = 16'h0100;
            sensor2_velocity = 16'h0010;


            repeat(10) @(posedge clk);

            #1;


            check_outputs(16'h0100, 16'h0010);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Divergent Sensor Inputs", test_num);
            reset_dut();
            sensor1_position = 16'd1000;
            sensor1_velocity = 16'd50;
            sensor2_position = 16'd2000;
            sensor2_velocity = 16'd150;

            repeat(10) @(posedge clk);


            #1;



            check_outputs(16'h05DC, 16'h0064);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Zero States", test_num);
            reset_dut();
            sensor1_position = 16'd0;
            sensor1_velocity = 16'd0;
            sensor2_position = 16'd0;
            sensor2_velocity = 16'd0;

            repeat(10) @(posedge clk);

            #1;


            check_outputs(16'h0000, 16'h0000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Large Magnitude Inputs", test_num);
            reset_dut();
            sensor1_position = 16'h7000;
            sensor1_velocity = 16'h0F00;
            sensor2_position = 16'h5000;
            sensor2_velocity = 16'h0100;

            repeat(10) @(posedge clk);


            #1;



            check_outputs(16'h6000, 16'h0800);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Small Delta Variations", test_num);
            reset_dut();
            sensor1_position = 16'd501;
            sensor1_velocity = 16'd21;
            sensor2_position = 16'd499;
            sensor2_velocity = 16'd19;

            repeat(10) @(posedge clk);


            #1;



            check_outputs(16'h01F4, 16'h0014);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("KalmanFilter Testbench");
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
        $dumpvars(0,clk, reset, sensor1_position, sensor1_velocity, sensor2_position, sensor2_velocity, estimated_position, estimated_velocity);
    end

endmodule
