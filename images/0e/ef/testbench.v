`timescale 1ns/1ps

module kalman_filter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] kalman_gain;
    reg [15:0] measurement;
    reg [15:0] predicted_state;
    reg reset;
    wire [15:0] updated_state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    kalman_filter dut (
        .clk(clk),
        .kalman_gain(kalman_gain),
        .measurement(measurement),
        .predicted_state(predicted_state),
        .reset(reset),
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
            kalman_gain = 0;
            measurement = 0;
            predicted_state = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Running Testcase 001: Zero Gain");
            reset_dut();
            test_num = 1;
            kalman_gain = 16'h0000;
            measurement = 16'hA000;
            predicted_state = 16'h1000;
            @(posedge clk);
            #2;
            #1;

            check_outputs(16'h1000);
        end
        endtask

    task testcase002;

        begin
            $display("Running Testcase 002: Maximum Gain");
            reset_dut();
            test_num = 2;
            kalman_gain = 16'hFFFF;
            measurement = 16'h5000;
            predicted_state = 16'h1000;
            @(posedge clk);
            #2;

            #1;


            check_outputs(16'h4FFF);
        end
        endtask

    task testcase003;

        begin
            $display("Running Testcase 003: 50%% Gain");
            reset_dut();
            test_num = 3;
            kalman_gain = 16'h8000;
            measurement = 16'h4000;
            predicted_state = 16'h2000;
            @(posedge clk);
            #2;

            #1;


            check_outputs(16'h3000);
        end
        endtask

    task testcase004;

        begin
            $display("Running Testcase 004: Negative Innovation");
            reset_dut();
            test_num = 4;
            kalman_gain = 16'h4000;
            measurement = 16'h1000;
            predicted_state = 16'h5000;
            @(posedge clk);
            #2;


            #1;



            check_outputs(16'h4000);
        end
        endtask

    task testcase005;

        begin
            $display("Running Testcase 005: Reset Verification");
            reset_dut();
            test_num = 5;
            reset = 1;
            kalman_gain = 16'h8000;
            measurement = 16'hFFFF;
            predicted_state = 16'hFFFF;
            @(posedge clk);
            #2;
            #1;

            check_outputs(16'h0000);
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
        $dumpvars(0,clk, kalman_gain, measurement, predicted_state, reset, updated_state);
    end

endmodule
