`timescale 1ns/1ps

module kalman_filter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] control_input;
    reg [15:0] measurement;
    reg rst;
    wire [15:0] position_estimate;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    kalman_filter dut (
        .clk(clk),
        .control_input(control_input),
        .measurement(measurement),
        .rst(rst),
        .position_estimate(position_estimate)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            control_input = 16'h0000;
            measurement = 16'h0000;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %03d: Reset Behavior", test_num);
            reset_dut();

            #1;


            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %03d: Static Steady State", test_num);
            reset_dut();
            control_input = 16'h0000;
            measurement = 16'h0000;
            repeat(5) @(posedge clk);
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %03d: Constant Velocity Tracking", test_num);
            reset_dut();


            control_input = 16'd10;
            measurement = 16'd10;
            @(posedge clk);


            measurement = 16'd20;
            @(posedge clk);


            measurement = 16'd30;
            @(posedge clk);

            #1;
            #1;

            check_outputs(16'd30);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %03d: Response to Measurement Step", test_num);
            reset_dut();

            control_input = 16'h0000;
            measurement = 16'd100;
            @(posedge clk);
            #1;



            if (position_estimate > 16'd0 && position_estimate <= 16'd100) begin
                $display("PASS: Estimate moved toward measurement. Got: %d", position_estimate);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: Estimate did not react correctly. Got: %d", position_estimate);
                fail_count = fail_count + 1;
            end
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
        input [15:0] expected_position_estimate;
        begin
            if (expected_position_estimate === (expected_position_estimate ^ position_estimate ^ expected_position_estimate)) begin
                $display("PASS");
                $display("  Outputs: position_estimate=%h",
                         position_estimate);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: position_estimate=%h",
                         expected_position_estimate);
                $display("  Got:      position_estimate=%h",
                         position_estimate);
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
        $dumpvars(0,clk, control_input, measurement, rst, position_estimate);
    end

endmodule
