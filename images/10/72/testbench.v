`timescale 1ns/1ps

module kalman_filter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg [15:0] z_position;
    reg [15:0] z_velocity;
    wire [15:0] x_position;
    wire [15:0] x_velocity;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    kalman_filter dut (
        .clk(clk),
        .rst(rst),
        .z_position(z_position),
        .z_velocity(z_velocity),
        .x_position(x_position),
        .x_velocity(x_velocity)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            z_position = 0;
            z_velocity = 0;
            @(posedge clk);
            #2 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nRunning Testcase 001: Reset State");
            reset_dut();

            #1;


            check_outputs(16'h0000, 16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nRunning Testcase 002: Static Convergence");
            reset_dut();
            z_position = 16'd1000;
            z_velocity = 16'd0;

            repeat(50) @(posedge clk);
            #1;

            check_outputs(16'd1000, 16'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nRunning Testcase 003: High Velocity Tracking");
            reset_dut();
            z_position = 16'd500;
            z_velocity = 16'd250;
            repeat(50) @(posedge clk);
            #1;

            check_outputs(16'd500, 16'd250);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nRunning Testcase 004: Noise Filtering");
            reset_dut();

            repeat(10) begin
                z_position = 16'd2000; z_velocity = 16'd10; @(posedge clk);
                z_position = 16'd2100; z_velocity = 16'd10; @(posedge clk);
                z_position = 16'd1900; z_velocity = 16'd10; @(posedge clk);
            end


            #1;



            check_outputs(16'd2000, 16'd10);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nRunning Testcase 005: Full Scale Input");
            reset_dut();
            z_position = 16'hFFFF;
            z_velocity = 16'hFFFF;
            repeat(50) @(posedge clk);
            #1;

            check_outputs(16'hFFFF, 16'hFFFF);
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
        input [15:0] expected_x_position;
        input [15:0] expected_x_velocity;
        begin
            if (expected_x_position === (expected_x_position ^ x_position ^ expected_x_position) &&
                expected_x_velocity === (expected_x_velocity ^ x_velocity ^ expected_x_velocity)) begin
                $display("PASS");
                $display("  Outputs: x_position=%h, x_velocity=%h",
                         x_position, x_velocity);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: x_position=%h, x_velocity=%h",
                         expected_x_position, expected_x_velocity);
                $display("  Got:      x_position=%h, x_velocity=%h",
                         x_position, x_velocity);
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
        $dumpvars(0,clk, rst, z_position, z_velocity, x_position, x_velocity);
    end

endmodule
