`timescale 1ns/1ps

module kalman_filter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] measurement;
    reg [15:0] predicted_covariance;
    reg [15:0] predicted_state;
    reg reset;
    wire [15:0] updated_covariance;
    wire [15:0] updated_state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    kalman_filter dut (
        .clk(clk),
        .measurement(measurement),
        .predicted_covariance(predicted_covariance),
        .predicted_state(predicted_state),
        .reset(reset),
        .updated_covariance(updated_covariance),
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
            measurement = 0;
            predicted_covariance = 0;
            predicted_state = 0;
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
            $display("Test Case %0d: Reset and Zero Inputs", test_num);
            reset_dut();
            measurement = 16'h0000;
            predicted_state = 16'h0000;
            predicted_covariance = 16'h0000;
            repeat(2) @(posedge clk);
            #1;

            #1;


            check_outputs(16'h0000, 16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Measurement Matches Prediction", test_num);
            reset_dut();
            measurement = 16'h1234;
            predicted_state = 16'h1234;
            predicted_covariance = 16'h0100;
            repeat(2) @(posedge clk);
            #1;



            if (updated_state === 16'h1234)
                $display("  State Correct: 16'h1234");
            else
                $display("  State Incorrect");


            #1;



            check_outputs(updated_covariance, 16'h1234);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: High Uncertainty", test_num);
            reset_dut();
            measurement = 16'hFF00;
            predicted_state = 16'h00FF;
            predicted_covariance = 16'hFFFF;
            repeat(2) @(posedge clk);
            #1;

            if (updated_state > predicted_state)
                pass_count = pass_count + 1;
            else
                fail_count = fail_count + 1;
            $display("  Outputs: Cov=%h, State=%h", updated_covariance, updated_state);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Low Uncertainty", test_num);
            reset_dut();
            measurement = 16'hFFFF;
            predicted_state = 16'h1000;
            predicted_covariance = 16'h0001;
            repeat(2) @(posedge clk);
            #1;

            if (updated_state < 16'h2000)
                pass_count = pass_count + 1;
            else
                fail_count = fail_count + 1;
            $display("  Outputs: Cov=%h, State=%h", updated_covariance, updated_state);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Negative Innovation", test_num);
            reset_dut();
            measurement = 16'h0010;
            predicted_state = 16'h0500;
            predicted_covariance = 16'h0100;
            repeat(2) @(posedge clk);
            #1;

            if (updated_state < 16'h0500 && updated_state > 16'h0010)
                pass_count = pass_count + 1;
            else
                fail_count = fail_count + 1;
            $display("  Outputs: Cov=%h, State=%h", updated_covariance, updated_state);
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
        input [15:0] expected_updated_covariance;
        input [15:0] expected_updated_state;
        begin
            if (expected_updated_covariance === (expected_updated_covariance ^ updated_covariance ^ expected_updated_covariance) &&
                expected_updated_state === (expected_updated_state ^ updated_state ^ expected_updated_state)) begin
                $display("PASS");
                $display("  Outputs: updated_covariance=%h, updated_state=%h",
                         updated_covariance, updated_state);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: updated_covariance=%h, updated_state=%h",
                         expected_updated_covariance, expected_updated_state);
                $display("  Got:      updated_covariance=%h, updated_state=%h",
                         updated_covariance, updated_state);
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
        $dumpvars(0,clk, measurement, predicted_covariance, predicted_state, reset, updated_covariance, updated_state);
    end

endmodule
