`timescale 1ns/1ps

module kalman_filter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] measurement;
    reg reset;
    wire [15:0] estimated_covariance;
    wire [15:0] estimated_position;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    kalman_filter dut (
        .clk(clk),
        .measurement(measurement),
        .reset(reset),
        .estimated_covariance(estimated_covariance),
        .estimated_position(estimated_position)
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
            $display("\nRunning Testcase 001: Single update...");
            reset_dut();
            measurement = 16'd1000;
            @(posedge clk);
            #2;



            #1;




            check_outputs(16'h000A, 16'h01F4);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nRunning Testcase 002: Convergence test...");
            reset_dut();
            measurement = 16'd500;
            repeat(10) @(posedge clk);
            #2;


            #1;



            check_outputs(16'h0002, 16'h01F3);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nRunning Testcase 003: Step response...");
            reset_dut();

            measurement = 16'd100;
            repeat(5) @(posedge clk);

            measurement = 16'd2000;
            repeat(3) @(posedge clk);
            #2;

            #1;


            check_outputs(16'h0004, 16'h05DC);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nRunning Testcase 004: Zero input...");
            reset_dut();
            measurement = 16'hFFFF;
            @(posedge clk);
            measurement = 16'h0000;
            repeat(5) @(posedge clk);
            #2;
            #1;

            check_outputs(16'h0003, 16'h0005);
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
        input [15:0] expected_estimated_covariance;
        input [15:0] expected_estimated_position;
        begin
            if (expected_estimated_covariance === (expected_estimated_covariance ^ estimated_covariance ^ expected_estimated_covariance) &&
                expected_estimated_position === (expected_estimated_position ^ estimated_position ^ expected_estimated_position)) begin
                $display("PASS");
                $display("  Outputs: estimated_covariance=%h, estimated_position=%h",
                         estimated_covariance, estimated_position);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: estimated_covariance=%h, estimated_position=%h",
                         expected_estimated_covariance, expected_estimated_position);
                $display("  Got:      estimated_covariance=%h, estimated_position=%h",
                         estimated_covariance, estimated_position);
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
        $dumpvars(0,clk, measurement, reset, estimated_covariance, estimated_position);
    end

endmodule
