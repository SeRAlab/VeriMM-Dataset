`timescale 1ns/1ps

module kalman_filter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] measurement;
    reg [15:0] measurement_noise;
    reg [15:0] process_noise;
    reg rst;
    wire [15:0] estimate;

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
        .rst(rst),
        .estimate(estimate)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        measurement = 0;
        measurement_noise = 0;
        process_noise = 0;
        @(posedge clk);
        #1 rst = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case 001: Constant Input Convergence");
        reset_dut();


        process_noise = 16'h0001;
        measurement_noise = 16'h0001;
        measurement = 16'h0064;


        repeat(20) @(posedge clk);


        #1;



        check_outputs(16'h0064);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case 002: Step Response (Low Measurement Noise)");
        reset_dut();

        process_noise = 16'h000A;
        measurement_noise = 16'h0001;
        measurement = 16'h03E8;


        repeat(10) @(posedge clk);


        #1;



        check_outputs(16'h03E8);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case 003: High Measurement Noise (Smoothing)");
        reset_dut();

        process_noise = 16'h0001;
        measurement_noise = 16'h00FF;
        measurement = 16'h01F4;




        repeat(50) @(posedge clk);

        #1;


        check_outputs(16'h01F4);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case 004: Zero Process Noise Stability");
        reset_dut();

        process_noise = 16'h0000;
        measurement_noise = 16'h0005;
        measurement = 16'h0010;

        repeat(30) @(posedge clk);


        #1;



        check_outputs(16'h0010);
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
        input [15:0] expected_estimate;
        begin
            if (expected_estimate === (expected_estimate ^ estimate ^ expected_estimate)) begin
                $display("PASS");
                $display("  Outputs: estimate=%h",
                         estimate);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: estimate=%h",
                         expected_estimate);
                $display("  Got:      estimate=%h",
                         estimate);
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
        $dumpvars(0,clk, measurement, measurement_noise, process_noise, rst, estimate);
    end

endmodule
