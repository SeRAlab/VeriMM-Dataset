`timescale 1ns/1ps

module kalman_filter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] measurement;
    reg reset;
    wire [15:0] position_estimate;
    wire [15:0] velocity_estimate;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    kalman_filter dut (
        .clk(clk),
        .measurement(measurement),
        .reset(reset),
        .position_estimate(position_estimate),
        .velocity_estimate(velocity_estimate)
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
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        integer i;
        begin
            test_num = 1;
            $display("\nTestcase %0d: Zero Input Stability", test_num);
            reset_dut();
            for (i = 0; i < 20; i = i + 1) begin
                measurement = 16'h0000;
                @(posedge clk);
            end

            #1;


            check_outputs(16'h0000, 16'h0000);
        end
        endtask

    task testcase002;

        integer i;
        begin
            test_num = 2;
            $display("\nTestcase %0d: Constant Position Convergence", test_num);
            reset_dut();
            for (i = 0; i < 50; i = i + 1) begin
                measurement = 16'h0500;
                @(posedge clk);
            end

            #1;


            check_outputs(16'h0500, 16'h0000);
        end
        endtask

    task testcase003;

        integer i;
        reg [15:0] ramp;
        begin
            test_num = 3;
            $display("\nTestcase %0d: Constant Velocity Tracking", test_num);
            reset_dut();
            ramp = 0;
            for (i = 0; i < 32; i = i + 1) begin
                measurement = ramp;
                ramp = ramp + 16'h0010;
                @(posedge clk);
            end


            #1;



            check_outputs(16'h01F0, 16'h0010);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = 4;
            $display("\nTestcase %0d: Noise Filtering", test_num);
            reset_dut();
            for (i = 0; i < 100; i = i + 1) begin

                if (i % 2 == 0) measurement = 16'h1010;
                else           measurement = 16'h0FF0;
                @(posedge clk);
            end

            #1;


            check_outputs(16'h1000, 16'h0000);
        end
        endtask

    task testcase005;

        integer i;
        begin
            test_num = 5;
            $display("\nTestcase %0d: Step Response", test_num);
            reset_dut();

            for (i = 0; i < 20; i = i + 1) begin
                measurement = 16'h0000;
                @(posedge clk);
            end

            for (i = 0; i < 50; i = i + 1) begin
                measurement = 16'h2000;
                @(posedge clk);
            end

            #1;


            check_outputs(16'h2000, 16'h0000);
        end
        endtask

    task testcase006;

        integer i;
        begin
            test_num = 6;
            $display("\nTestcase %0d: High Value Tracking", test_num);
            reset_dut();
            for (i = 0; i < 40; i = i + 1) begin
                measurement = 16'hFFFF;
                @(posedge clk);
            end
            #1;

            check_outputs(16'hFFFF, 16'h0000);
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
        input [15:0] expected_position_estimate;
        input [15:0] expected_velocity_estimate;
        begin
            if (expected_position_estimate === (expected_position_estimate ^ position_estimate ^ expected_position_estimate) &&
                expected_velocity_estimate === (expected_velocity_estimate ^ velocity_estimate ^ expected_velocity_estimate)) begin
                $display("PASS");
                $display("  Outputs: position_estimate=%h, velocity_estimate=%h",
                         position_estimate, velocity_estimate);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: position_estimate=%h, velocity_estimate=%h",
                         expected_position_estimate, expected_velocity_estimate);
                $display("  Got:      position_estimate=%h, velocity_estimate=%h",
                         position_estimate, velocity_estimate);
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
        $dumpvars(0,clk, measurement, reset, position_estimate, velocity_estimate);
    end

endmodule
