`timescale 1ns/1ps

module kalman_filter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] measurement;
    reg [15:0] measurement_noise;
    reg [15:0] process_noise;
    reg reset;
    wire [15:0] state_estimate;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    kalman_filter dut (
        .clk(clk),
        .measurement(measurement),
        .measurement_noise(measurement_noise),
        .process_noise(process_noise),
        .reset(reset),
        .state_estimate(state_estimate)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            measurement = 16'h0;
            measurement_noise = 16'h0;
            process_noise = 16'h0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Perfect Measurement Confidence (R=0)", test_num);
            reset_dut();
            measurement = 16'h03E8;
            process_noise = 16'h0001;
            measurement_noise = 16'h0000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h03E8);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Perfect Process Confidence (Q=0)", test_num);
            reset_dut();
            measurement = 16'hFFFF;
            process_noise = 16'h0000;
            measurement_noise = 16'h0001;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Balanced Noise (Q=R, K=0.5)", test_num);
            reset_dut();
            measurement = 16'h0200;
            process_noise = 16'h000A;
            measurement_noise = 16'h000A;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0100);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Multi-cycle Convergence", test_num);
            reset_dut();
            measurement = 16'h0400;
            process_noise = 16'h0001;
            measurement_noise = 16'h0001;
            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0300);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Large Measurement Noise Dampening", test_num);
            reset_dut();
            measurement = 16'h0064;
            process_noise = 16'h0001;
            measurement_noise = 16'h0009;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h000A);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Reset Mid-Operation", test_num);
            reset_dut();
            measurement = 16'h0500;
            process_noise = 16'h0001;
            measurement_noise = 16'h0000;
            @(posedge clk);
            reset = 1;
            @(posedge clk);
            #1;
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
        input [15:0] expected_state_estimate;
        begin
            if (expected_state_estimate === (expected_state_estimate ^ state_estimate ^ expected_state_estimate)) begin
                $display("PASS");
                $display("  Outputs: state_estimate=%h",
                         state_estimate);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: state_estimate=%h",
                         expected_state_estimate);
                $display("  Got:      state_estimate=%h",
                         state_estimate);
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
        $dumpvars(0,clk, measurement, measurement_noise, process_noise, reset, state_estimate);
    end

endmodule
