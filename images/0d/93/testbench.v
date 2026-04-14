`timescale 1ns/1ps

module kalman_filter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] measurement;
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
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Executing Testcase 001: Reset state verification...");
            reset_dut();

            #1;


            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Executing Testcase 002: Steady-state convergence...");
            reset_dut();
            measurement = 16'd1000;

            repeat(200) @(posedge clk);
            #1;

            check_outputs(16'd1000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Executing Testcase 003: High to low value tracking...");
            reset_dut();

            measurement = 16'hFFFF;
            repeat(200) @(posedge clk);

            measurement = 16'h00FF;
            repeat(200) @(posedge clk);
            #1;

            check_outputs(16'h00FF);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Executing Testcase 004: Return to zero check...");
            reset_dut();
            measurement = 16'hA5A5;
            repeat(200) @(posedge clk);
            measurement = 16'h0000;
            repeat(200) @(posedge clk);
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
        $dumpvars(0,clk, measurement, rst, estimate);
    end

endmodule
