`timescale 1ns/1ps

module kalman_filter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] estimated_position;
    reg [15:0] measurement;
    reg [15:0] measurement_noise;
    reg [15:0] process_noise;
    reg rst;
    wire [15:0] new_estimated_position;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    kalman_filter dut (
        .clk(clk),
        .estimated_position(estimated_position),
        .measurement(measurement),
        .measurement_noise(measurement_noise),
        .process_noise(process_noise),
        .rst(rst),
        .new_estimated_position(new_estimated_position)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            estimated_position = 0;
            measurement = 0;
            measurement_noise = 0;
            process_noise = 0;
            #20;
            rst = 0;
            @(posedge clk);
            #2;
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning Testcase 001: Identity Check (z == x)");
            reset_dut();
            test_num = 1;
            estimated_position = 16'd100;
            measurement = 16'd100;
            process_noise = 16'd10;
            measurement_noise = 16'd10;
            @(posedge clk);
            #2;
            #1;

            check_outputs(16'd100);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning Testcase 002: Zero Measurement Noise (Trust Measurement)");
            reset_dut();
            test_num = 2;
            estimated_position = 16'd100;
            measurement = 16'd200;
            process_noise = 16'd50;
            measurement_noise = 16'd0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(16'd200);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning Testcase 003: Zero Process Noise (Trust Prediction)");
            reset_dut();
            test_num = 3;
            estimated_position = 16'd100;
            measurement = 16'd200;
            process_noise = 16'd0;
            measurement_noise = 16'd50;
            @(posedge clk);
            #2;
            #1;

            check_outputs(16'd100);
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning Testcase 004: Balanced Noise (K=0.5)");
            reset_dut();
            test_num = 4;
            estimated_position = 16'd1000;
            measurement = 16'd2000;
            process_noise = 16'd500;
            measurement_noise = 16'd500;
            @(posedge clk);
            #2;
            #1;

            check_outputs(16'd1500);
        end
        endtask

    task testcase005;

        begin
            $display("\nRunning Testcase 005: High Measurement Noise (K=0.25)");
            reset_dut();
            test_num = 5;
            estimated_position = 16'd0;
            measurement = 16'd1000;
            process_noise = 16'd250;
            measurement_noise = 16'd750;
            @(posedge clk);
            #2;
            #1;

            check_outputs(16'd250);
        end
        endtask

    task testcase006;

        begin
            $display("\nRunning Testcase 006: High Process Noise (K=0.75)");
            reset_dut();
            test_num = 6;
            estimated_position = 16'd0;
            measurement = 16'd1000;
            process_noise = 16'd750;
            measurement_noise = 16'd250;
            @(posedge clk);
            #2;
            #1;

            check_outputs(16'd750);
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
        input [15:0] expected_new_estimated_position;
        begin
            if (expected_new_estimated_position === (expected_new_estimated_position ^ new_estimated_position ^ expected_new_estimated_position)) begin
                $display("PASS");
                $display("  Outputs: new_estimated_position=%h",
                         new_estimated_position);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: new_estimated_position=%h",
                         expected_new_estimated_position);
                $display("  Got:      new_estimated_position=%h",
                         new_estimated_position);
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
        $dumpvars(0,clk, estimated_position, measurement, measurement_noise, process_noise, rst, new_estimated_position);
    end

endmodule
