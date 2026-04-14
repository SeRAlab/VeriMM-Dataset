`timescale 1ns/1ps

module kalman_filter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] pos_measurement;
    reg [15:0] pos_uncertainty;
    reg rst;
    reg [15:0] vel_measurement;
    reg [15:0] vel_uncertainty;
    wire [15:0] pos_error;
    wire [15:0] pos_estimate;
    wire [15:0] vel_error;
    wire [15:0] vel_estimate;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    kalman_filter dut (
        .clk(clk),
        .pos_measurement(pos_measurement),
        .pos_uncertainty(pos_uncertainty),
        .rst(rst),
        .vel_measurement(vel_measurement),
        .vel_uncertainty(vel_uncertainty),
        .pos_error(pos_error),
        .pos_estimate(pos_estimate),
        .vel_error(vel_error),
        .vel_estimate(vel_estimate)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            pos_measurement = 0;
            pos_uncertainty = 0;
            vel_measurement = 0;
            vel_uncertainty = 0;
            @(posedge clk);
            #2 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: High Confidence Update", test_num);
            reset_dut();



            pos_measurement = 16'h1000;
            pos_uncertainty = 16'h0001;
            vel_measurement = 16'h0500;
            vel_uncertainty = 16'h0001;


            repeat(2) @(posedge clk);




            #1;





            check_outputs(16'h0001, 16'h1000, 16'h0001, 16'h0500);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Low Confidence (High Uncertainty)", test_num);
            reset_dut();

            pos_measurement = 16'hFFFF;
            pos_uncertainty = 16'hFFFF;
            vel_measurement = 16'hFFFF;
            vel_uncertainty = 16'hFFFF;

            repeat(2) @(posedge clk);



            #1;




            check_outputs(16'h7FFF, 16'h0000, 16'h7FFF, 16'h0000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Balanced Uncertainty", test_num);
            reset_dut();


            pos_measurement = 16'h2000;
            pos_uncertainty = 16'h1000;
            vel_measurement = 16'h0800;
            vel_uncertainty = 16'h0400;

            repeat(2) @(posedge clk);



            #1;




            check_outputs(16'h0800, 16'h1000, 16'h0200, 16'h0400);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %04d: Maximum Values", test_num);
            reset_dut();

            pos_measurement = 16'hFFFF;
            pos_uncertainty = 16'h0000;
            vel_measurement = 16'hFFFF;
            vel_uncertainty = 16'h0000;

            repeat(2) @(posedge clk);

            #1;


            check_outputs(16'h0000, 16'hFFFF, 16'h0000, 16'hFFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %05d: Zero Measurements", test_num);
            reset_dut();

            pos_measurement = 16'h0000;
            pos_uncertainty = 16'h0010;
            vel_measurement = 16'h0000;
            vel_uncertainty = 16'h0010;

            repeat(2) @(posedge clk);


            #1;



            check_outputs(16'h0010, 16'h0000, 16'h0010, 16'h0000);
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
        input [15:0] expected_pos_error;
        input [15:0] expected_pos_estimate;
        input [15:0] expected_vel_error;
        input [15:0] expected_vel_estimate;
        begin
            if (expected_pos_error === (expected_pos_error ^ pos_error ^ expected_pos_error) &&
                expected_pos_estimate === (expected_pos_estimate ^ pos_estimate ^ expected_pos_estimate) &&
                expected_vel_error === (expected_vel_error ^ vel_error ^ expected_vel_error) &&
                expected_vel_estimate === (expected_vel_estimate ^ vel_estimate ^ expected_vel_estimate)) begin
                $display("PASS");
                $display("  Outputs: pos_error=%h, pos_estimate=%h, vel_error=%h, vel_estimate=%h",
                         pos_error, pos_estimate, vel_error, vel_estimate);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: pos_error=%h, pos_estimate=%h, vel_error=%h, vel_estimate=%h",
                         expected_pos_error, expected_pos_estimate, expected_vel_error, expected_vel_estimate);
                $display("  Got:      pos_error=%h, pos_estimate=%h, vel_error=%h, vel_estimate=%h",
                         pos_error, pos_estimate, vel_error, vel_estimate);
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
        $dumpvars(0,clk, pos_measurement, pos_uncertainty, rst, vel_measurement, vel_uncertainty, pos_error, pos_estimate, vel_error, vel_estimate);
    end

endmodule
