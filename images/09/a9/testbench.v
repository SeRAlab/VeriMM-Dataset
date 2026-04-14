`timescale 1ns/1ps

module slam_system_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] distance_measurement;
    reg reset;
    wire [255:0] map_data;
    wire [15:0] robot_position;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    slam_system dut (
        .clk(clk),
        .distance_measurement(distance_measurement),
        .reset(reset),
        .map_data(map_data),
        .robot_position(robot_position)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            distance_measurement = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Reset State Verification", test_num);
            reset_dut();


            #1;



            check_outputs(256'h0, 16'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Single Measurement Update", test_num);
            reset_dut();

            distance_measurement = 16'd10;
            @(posedge clk);






            #1;







            check_outputs(256'h400, 16'h1);
        end
        endtask

    task testcase003;

        reg [255:0] expected_map;
        begin
            test_num = 3;
            $display("Testcase %0d: Multiple Sequential Measurements", test_num);
            reset_dut();


            distance_measurement = 16'd5;
            @(posedge clk);


            distance_measurement = 16'd2;
            @(posedge clk);


            distance_measurement = 16'd10;
            @(posedge clk);

            expected_map = (256'h1 << 5) | (256'h1 << 3) | (256'h1 << 12);
            #1;

            check_outputs(expected_map, 16'h3);
        end
        endtask

    task testcase004;

        reg [255:0] expected_map;
        begin
            test_num = 4;
            $display("Testcase %0d: Boundary Measurement", test_num);
            reset_dut();


            distance_measurement = 16'd255;
            @(posedge clk);

            expected_map = (256'h1 << 255);
            #1;

            check_outputs(expected_map, 16'h1);
        end
        endtask

    task testcase005;

        reg [255:0] expected_map;
        begin
            test_num = 5;
            $display("Testcase %0d: Overlapping Map Data", test_num);
            reset_dut();


            distance_measurement = 16'd10;
            @(posedge clk);


            distance_measurement = 16'd9;
            @(posedge clk);


            distance_measurement = 16'd8;
            @(posedge clk);

            expected_map = (256'h1 << 10);
            #1;

            check_outputs(expected_map, 16'h3);
        end
        endtask

    task testcase006;

        integer i;
        reg [255:0] expected_map;
        begin
            test_num = 6;
            $display("Testcase %0d: Long Trajectory Simulation", test_num);
            reset_dut();

            expected_map = 0;
            for(i = 0; i < 10; i = i + 1) begin
                distance_measurement = 16'd20 + i;
                expected_map = expected_map | (256'h1 << (i + 20 + i));
                @(posedge clk);
            end

            #1;


            check_outputs(expected_map, 16'd10);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("slam_system Testbench");
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
        input [255:0] expected_map_data;
        input [15:0] expected_robot_position;
        begin
            if (expected_map_data === (expected_map_data ^ map_data ^ expected_map_data) &&
                expected_robot_position === (expected_robot_position ^ robot_position ^ expected_robot_position)) begin
                $display("PASS");
                $display("  Outputs: map_data=%h, robot_position=%h",
                         map_data, robot_position);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: map_data=%h, robot_position=%h",
                         expected_map_data, expected_robot_position);
                $display("  Got:      map_data=%h, robot_position=%h",
                         map_data, robot_position);
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
        $dumpvars(0,clk, distance_measurement, reset, map_data, robot_position);
    end

endmodule
