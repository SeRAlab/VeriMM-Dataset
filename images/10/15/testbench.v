`timescale 1ns/1ps

module slam_fsm_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg [3:0] sensor_data;
    wire [7:0] position_x;
    wire [7:0] position_y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    slam_fsm dut (
        .clk(clk),
        .reset(reset),
        .sensor_data(sensor_data),
        .position_x(position_x),
        .position_y(position_y)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        sensor_data = 4'd0;
        @(posedge clk);
        #1;
        reset = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Initial Reset State", test_num);
        reset_dut();

        #1;


        check_outputs(8'h00, 8'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Basic Movement North and East", test_num);
        reset_dut();

        sensor_data = 4'd4;
        @(posedge clk);
        #1;
        sensor_data = 4'd1;
        @(posedge clk);
        #1;
        sensor_data = 4'd0;
        @(posedge clk);
        #1;

        #1;


        check_outputs(8'h01, 8'h01);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Multiple steps East", test_num);
        reset_dut();

        sensor_data = 4'd4;
        repeat(3) @(posedge clk);
        #1;
        sensor_data = 4'd0;
        @(posedge clk);
        #1;

        #1;


        check_outputs(8'h03, 8'h00);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Square Path Loop", test_num);
        reset_dut();

        sensor_data = 4'd1;
        @(posedge clk);
        #1;
        sensor_data = 4'd4;
        @(posedge clk);
        #1;
        sensor_data = 4'd2;
        @(posedge clk);
        #1;
        sensor_data = 4'd3;
        @(posedge clk);
        #1;
        sensor_data = 4'd0;
        @(posedge clk);
        #1;

        #1;


        check_outputs(8'h00, 8'h00);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Negative Direction Movement", test_num);
        reset_dut();

        sensor_data = 4'd3;
        @(posedge clk);
        #1;
        sensor_data = 4'd3;
        @(posedge clk);
        #1;
        sensor_data = 4'd0;
        @(posedge clk);
        #1;



        #1;




        check_outputs(8'hFE, 8'h00);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Idle/Invalid Sensor Data", test_num);
        reset_dut();

        sensor_data = 4'd4;
        @(posedge clk);
        #1;
        sensor_data = 4'd15;
        repeat(5) @(posedge clk);
        #1;

        #1;


        check_outputs(8'h01, 8'h00);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("slam_fsm Testbench");
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
        input [7:0] expected_position_x;
        input [7:0] expected_position_y;
        begin
            if (expected_position_x === (expected_position_x ^ position_x ^ expected_position_x) &&
                expected_position_y === (expected_position_y ^ position_y ^ expected_position_y)) begin
                $display("PASS");
                $display("  Outputs: position_x=%h, position_y=%h",
                         position_x, position_y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: position_x=%h, position_y=%h",
                         expected_position_x, expected_position_y);
                $display("  Got:      position_x=%h, position_y=%h",
                         position_x, position_y);
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
        $dumpvars(0,clk, reset, sensor_data, position_x, position_y);
    end

endmodule
