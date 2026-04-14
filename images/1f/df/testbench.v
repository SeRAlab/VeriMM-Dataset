`timescale 1ns/1ps

module kalman_filter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] current_estimate;
    reg [15:0] kalman_gain;
    reg [15:0] measurement;
    reg reset;
    wire [15:0] updated_estimate;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    kalman_filter dut (
        .clk(clk),
        .current_estimate(current_estimate),
        .kalman_gain(kalman_gain),
        .measurement(measurement),
        .reset(reset),
        .updated_estimate(updated_estimate)
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
            current_estimate = 0;
            kalman_gain = 0;
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
            reset_dut();
            measurement = 16'h0000;
            current_estimate = 16'h0000;
            kalman_gain = 16'h0000;
            @(posedge clk);
            #1;
            $display("Testcase 001: Reset and Zero Inputs");
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            measurement = 16'hA000;
            current_estimate = 16'h1234;
            kalman_gain = 16'h0000;
            @(posedge clk);
            #1;
            $display("Testcase 002: Zero Gain (Ignore Measurement)");
            #1;

            check_outputs(16'h1234);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            measurement = 16'h5555;
            current_estimate = 16'h5555;
            kalman_gain = 16'h8000;
            @(posedge clk);
            #1;
            $display("Testcase 003: No Innovation (Meas == Est)");
            #1;

            check_outputs(16'h5555);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            measurement = 16'h4000;
            current_estimate = 16'h1000;
            kalman_gain = 16'hFFFF;
            @(posedge clk);
            #1;
            $display("Testcase 004: Maximum Gain (Trust Measurement)");


            #1;



            check_outputs(16'h3FFF);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            measurement = 16'h2000;
            current_estimate = 16'h1000;
            kalman_gain = 16'h8000;
            @(posedge clk);
            #1;
            $display("Testcase 005: 50 percent Gain (Halfway step)");


            #1;



            check_outputs(16'h1800);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            measurement = 16'h1000;
            current_estimate = 16'h3000;
            kalman_gain = 16'h4000;
            @(posedge clk);
            #1;
            $display("Testcase 006: Negative Innovation (Meas < Est)");



            #1;




            check_outputs(16'h2800);
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
        input [15:0] expected_updated_estimate;
        begin
            if (expected_updated_estimate === (expected_updated_estimate ^ updated_estimate ^ expected_updated_estimate)) begin
                $display("PASS");
                $display("  Outputs: updated_estimate=%h",
                         updated_estimate);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: updated_estimate=%h",
                         expected_updated_estimate);
                $display("  Got:      updated_estimate=%h",
                         updated_estimate);
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
        $dumpvars(0,clk, current_estimate, kalman_gain, measurement, reset, updated_estimate);
    end

endmodule
