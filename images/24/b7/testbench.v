`timescale 1ns/1ps

module kalman_filter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] predicted_state;
    reg reset;
    reg [15:0] sensor_measurement;
    wire [15:0] updated_state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    kalman_filter dut (
        .clk(clk),
        .predicted_state(predicted_state),
        .reset(reset),
        .sensor_measurement(sensor_measurement),
        .updated_state(updated_state)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            predicted_state = 0;
            sensor_measurement = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Running Testcase 001: No change scenario");
            reset_dut();
            predicted_state = 16'd100;
            sensor_measurement = 16'd100;
            @(posedge clk);
            #2;
            #1;

            check_outputs(16'd100);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Running Testcase 002: Upward adjustment");
            reset_dut();
            predicted_state = 16'd100;
            sensor_measurement = 16'd200;
            @(posedge clk);
            #2;
            #1;

            check_outputs(16'd150);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Running Testcase 003: Downward adjustment");
            reset_dut();
            predicted_state = 16'd500;
            sensor_measurement = 16'd300;
            @(posedge clk);
            #2;
            #1;

            check_outputs(16'd400);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Running Testcase 004: Zero prediction boundary");
            reset_dut();
            predicted_state = 16'd0;
            sensor_measurement = 16'd1000;
            @(posedge clk);
            #2;
            #1;

            check_outputs(16'd500);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Running Testcase 005: Large values");
            reset_dut();
            predicted_state = 16'd40000;
            sensor_measurement = 16'd20000;
            @(posedge clk);
            #2;
            #1;

            check_outputs(16'd30000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Running Testcase 006: Zero measurement");
            reset_dut();
            predicted_state = 16'd2048;
            sensor_measurement = 16'd0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(16'd1024);
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
        input [15:0] expected_updated_state;
        begin
            if (expected_updated_state === (expected_updated_state ^ updated_state ^ expected_updated_state)) begin
                $display("PASS");
                $display("  Outputs: updated_state=%h",
                         updated_state);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: updated_state=%h",
                         expected_updated_state);
                $display("  Got:      updated_state=%h",
                         updated_state);
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
        $dumpvars(0,clk, predicted_state, reset, sensor_measurement, updated_state);
    end

endmodule
