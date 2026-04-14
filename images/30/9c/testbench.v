`timescale 1ns/1ps

module slam_system_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [1:0] control_command;
    reg reset;
    reg [7:0] sensor_reading;
    wire [7:0] pos_x;
    wire [7:0] pos_y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    slam_system dut (
        .clk(clk),
        .control_command(control_command),
        .reset(reset),
        .sensor_reading(sensor_reading),
        .pos_x(pos_x),
        .pos_y(pos_y)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            control_command = 2'b00;
            sensor_reading = 8'h00;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            #1;

            check_outputs(8'd0, 8'd0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            control_command = 2'b01;
            sensor_reading = 8'd15;
            @(posedge clk);
            #1 control_command = 2'b00;
            #1;

            check_outputs(8'd15, 8'd0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            control_command = 2'b10;
            sensor_reading = 8'd25;
            @(posedge clk);
            #1 control_command = 2'b00;
            #1;

            check_outputs(8'd0, 8'd25);
        end
        endtask

    task testcase004;

        begin
            reset_dut();

            control_command = 2'b01;
            sensor_reading = 8'd10;
            @(posedge clk);

            #1 control_command = 2'b10;
            sensor_reading = 8'd20;
            @(posedge clk);
            #1 control_command = 2'b00;
            #1;

            check_outputs(8'd10, 8'd20);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            control_command = 2'b01;
            sensor_reading = 8'd5;
            @(posedge clk);
            #1 sensor_reading = 8'd10;
            @(posedge clk);
            #1 sensor_reading = 8'd2;
            @(posedge clk);
            #1 control_command = 2'b00;
            #1;

            check_outputs(8'd17, 8'd0);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            control_command = 2'b00;
            sensor_reading = 8'd100;
            @(posedge clk);
            @(posedge clk);
            #1;

            check_outputs(8'd0, 8'd0);
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
        input [7:0] expected_pos_x;
        input [7:0] expected_pos_y;
        begin
            if (expected_pos_x === (expected_pos_x ^ pos_x ^ expected_pos_x) &&
                expected_pos_y === (expected_pos_y ^ pos_y ^ expected_pos_y)) begin
                $display("PASS");
                $display("  Outputs: pos_x=%h, pos_y=%h",
                         pos_x, pos_y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: pos_x=%h, pos_y=%h",
                         expected_pos_x, expected_pos_y);
                $display("  Got:      pos_x=%h, pos_y=%h",
                         pos_x, pos_y);
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
        $dumpvars(0,clk, control_command, reset, sensor_reading, pos_x, pos_y);
    end

endmodule
