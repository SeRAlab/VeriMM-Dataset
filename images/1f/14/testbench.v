`timescale 1ns/1ps

module kalman_filter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] control;
    reg [15:0] measurement;
    reg reset;
    wire [15:0] estimate;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    kalman_filter dut (
        .clk(clk),
        .control(control),
        .measurement(measurement),
        .reset(reset),
        .estimate(estimate)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        control = 0;
        measurement = 0;
        repeat(2) @(posedge clk);
        #1 reset = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Test %0d: Zero Initialization", test_num);
        reset_dut();
        control = 16'h0000;
        measurement = 16'h0000;
        @(posedge clk);
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %0d: Control Input Matching Measurement", test_num);
        reset_dut();
        control = 16'd20;
        measurement = 16'd20;
        @(posedge clk);
        #1;

        check_outputs(16'd20);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %0d: Positive Measurement Correction", test_num);
        reset_dut();
        control = 16'd0;
        measurement = 16'd100;
        @(posedge clk);
        #1;

        check_outputs(16'd50);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %0d: Negative Measurement Correction", test_num);
        reset_dut();
        control = 16'd40;
        measurement = 16'd0;
        @(posedge clk);
        #1;

        check_outputs(16'd20);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %0d: Multi-step Convergence", test_num);
        reset_dut();


        control = 16'd10;
        measurement = 16'd10;
        @(posedge clk);


        control = 16'd10;
        measurement = 16'd40;
        @(posedge clk);

        #1;


        check_outputs(16'd30);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test %0d: High Magnitude Values", test_num);
        reset_dut();
        control = 16'h4000;
        measurement = 16'h4000;
        @(posedge clk);
        #1;

        check_outputs(16'h4000);
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
        $dumpvars(0,clk, control, measurement, reset, estimate);
    end

endmodule
