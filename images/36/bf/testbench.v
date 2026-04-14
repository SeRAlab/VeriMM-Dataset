`timescale 1ns/1ps

module kalman_filter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] estimated_position;
    reg rst;
    reg [15:0] sensor1;
    reg [15:0] sensor2;
    wire [15:0] refined_position;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    kalman_filter dut (
        .clk(clk),
        .estimated_position(estimated_position),
        .rst(rst),
        .sensor1(sensor1),
        .sensor2(sensor2),
        .refined_position(refined_position)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            estimated_position = 0;
            sensor1 = 0;
            sensor2 = 0;
            @(posedge clk);
            #2 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning Testcase 001: Zero State...");
            reset_dut();
            estimated_position = 16'h0000;
            sensor1 = 16'h0000;
            sensor2 = 16'h0000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning Testcase 002: Steady State (Value: 4000)...");
            reset_dut();
            estimated_position = 16'd4000;
            sensor1 = 16'd4000;
            sensor2 = 16'd4000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'd4000);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning Testcase 003: Positive Correction...");
            reset_dut();
            estimated_position = 16'd1000;
            sensor1 = 16'd2000;
            sensor2 = 16'd2000;
            @(posedge clk);
            #1;


            #1;



            check_outputs(16'h05DC);
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning Testcase 004: Negative Correction...");
            reset_dut();
            estimated_position = 16'd2000;
            sensor1 = 16'd1000;
            sensor2 = 16'd1000;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'h05DC);
        end
        endtask

    task testcase005;

        begin
            $display("\nRunning Testcase 005: Divergent Sensors...");
            reset_dut();
            estimated_position = 16'd1000;
            sensor1 = 16'd1200;
            sensor2 = 16'd800;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'h03E8);
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
        input [15:0] expected_refined_position;
        begin
            if (expected_refined_position === (expected_refined_position ^ refined_position ^ expected_refined_position)) begin
                $display("PASS");
                $display("  Outputs: refined_position=%h",
                         refined_position);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: refined_position=%h",
                         expected_refined_position);
                $display("  Got:      refined_position=%h",
                         refined_position);
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
        $dumpvars(0,clk, estimated_position, rst, sensor1, sensor2, refined_position);
    end

endmodule
