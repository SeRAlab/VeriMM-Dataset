`timescale 1ns/1ps

module slam_system_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] front_sensor;
    reg [7:0] left_sensor;
    reg [7:0] right_sensor;
    reg rst;
    wire [7:0] current_position;
    wire [7:0] map_front;
    wire [7:0] map_left;
    wire [7:0] map_right;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    slam_system dut (
        .clk(clk),
        .front_sensor(front_sensor),
        .left_sensor(left_sensor),
        .right_sensor(right_sensor),
        .rst(rst),
        .current_position(current_position),
        .map_front(map_front),
        .map_left(map_left),
        .map_right(map_right)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            front_sensor = 8'h00;
            left_sensor = 8'h00;
            right_sensor = 8'h00;
            @(posedge clk);
            #1;
            rst = 0;

        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Reset State Verification", test_num);
            reset_dut();

            #1;


            check_outputs(8'h00, 8'h00, 8'h00, 8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Single Step Update", test_num);
            reset_dut();


            front_sensor = 8'h0A;
            left_sensor  = 8'h05;
            right_sensor = 8'h0F;

            @(posedge clk);
            #1;


            #1;



            check_outputs(8'h01, 8'h0A, 8'h05, 8'h0F);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Multi-Step Tracking", test_num);
            reset_dut();


            front_sensor = 8'h10; left_sensor = 8'h11; right_sensor = 8'h12;
            @(posedge clk);
            #1;


            front_sensor = 8'h20; left_sensor = 8'h21; right_sensor = 8'h22;
            @(posedge clk);
            #1;


            front_sensor = 8'h30; left_sensor = 8'h31; right_sensor = 8'h32;
            @(posedge clk);
            #1;


            #1;



            check_outputs(8'h03, 8'h30, 8'h31, 8'h32);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Maximum Sensor Values", test_num);
            reset_dut();

            front_sensor = 8'hFF;
            left_sensor  = 8'hFF;
            right_sensor = 8'hFF;

            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h01, 8'hFF, 8'hFF, 8'hFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Reset After Operation", test_num);
            reset_dut();


            front_sensor = 8'hAA;
            @(posedge clk);
            @(posedge clk);
            #1;


            rst = 1;
            @(posedge clk);
            #1;
            rst = 0;


            #1;



            check_outputs(8'h00, 8'h00, 8'h00, 8'h00);
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
        input [7:0] expected_current_position;
        input [7:0] expected_map_front;
        input [7:0] expected_map_left;
        input [7:0] expected_map_right;
        begin
            if (expected_current_position === (expected_current_position ^ current_position ^ expected_current_position) &&
                expected_map_front === (expected_map_front ^ map_front ^ expected_map_front) &&
                expected_map_left === (expected_map_left ^ map_left ^ expected_map_left) &&
                expected_map_right === (expected_map_right ^ map_right ^ expected_map_right)) begin
                $display("PASS");
                $display("  Outputs: current_position=%h, map_front=%h, map_left=%h, map_right=%h",
                         current_position, map_front, map_left, map_right);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: current_position=%h, map_front=%h, map_left=%h, map_right=%h",
                         expected_current_position, expected_map_front, expected_map_left, expected_map_right);
                $display("  Got:      current_position=%h, map_front=%h, map_left=%h, map_right=%h",
                         current_position, map_front, map_left, map_right);
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
        $dumpvars(0,clk, front_sensor, left_sensor, right_sensor, rst, current_position, map_front, map_left, map_right);
    end

endmodule
