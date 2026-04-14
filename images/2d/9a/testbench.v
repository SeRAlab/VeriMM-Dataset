`timescale 1ns/1ps

module KalmanFilter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] measurement;
    reg reset;
    wire [15:0] estimate;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    KalmanFilter dut (
        .clk(clk),
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
            measurement = 16'h0000;
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
            $display("Testcase 001: Zero Input Initialization");
            reset_dut();
            measurement = 16'h0000;
            repeat (5) @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase 002: Constant Measurement (0x0100)");
            reset_dut();
            measurement = 16'h0100;


            repeat (20) @(posedge clk);
            #1;


            #1;



            check_outputs(16'h0100);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase 003: Step Response (0x0500)");
            reset_dut();
            measurement = 16'h0200;
            repeat (10) @(posedge clk);
            measurement = 16'h0500;
            repeat (20) @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0500);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase 004: Noise Smoothing (Alternating 0x0090 and 0x00B0)");
            reset_dut();

            repeat (10) begin
                measurement = 16'h0090;
                @(posedge clk);
                measurement = 16'h00B0;
                @(posedge clk);
            end
            #1;

            #1;


            check_outputs(16'h00A0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase 005: Large Measurement (0xF000)");
            reset_dut();
            measurement = 16'hF000;
            repeat (30) @(posedge clk);
            #1;
            #1;

            check_outputs(16'hF000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("KalmanFilter Testbench");
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
        $dumpvars(0,clk, measurement, reset, estimate);
    end

endmodule
