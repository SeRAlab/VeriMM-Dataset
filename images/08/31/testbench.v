`timescale 1ns/1ps

module kalman_filter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] measurement1;
    reg [15:0] measurement2;
    reg rst;
    wire [15:0] position_estimate;
    wire [15:0] velocity_estimate;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    kalman_filter dut (
        .clk(clk),
        .measurement1(measurement1),
        .measurement2(measurement2),
        .rst(rst),
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
            rst = 1;
            measurement1 = 16'h0000;
            measurement2 = 16'h0000;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Zero Inputs", test_num);
            reset_dut();

            measurement1 = 16'h0000;
            measurement2 = 16'h0000;

            repeat (10) @(posedge clk);


            #1;



            check_outputs(16'h0000, 16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Constant Position Convergence", test_num);
            reset_dut();


            measurement1 = 16'h1000;
            measurement2 = 16'h1000;

            repeat (20) @(posedge clk);


            #1;



            check_outputs(16'h1000, 16'h0000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Sensor Fusion Mean", test_num);
            reset_dut();

            measurement1 = 16'h1000;
            measurement2 = 16'h2000;

            repeat (30) @(posedge clk);


            #1;



            check_outputs(16'h1800, 16'h0000);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Constant Velocity Tracking", test_num);
            reset_dut();


            for (i = 0; i < 50; i = i + 1) begin
                measurement1 = i * 16'h0010;
                measurement2 = i * 16'h0010;
                @(posedge clk);
            end



            #1;




            check_outputs(16'h0310, 16'h0010);
        end
        endtask

    task testcase005;

        integer i;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Noisy Sensor Smoothing", test_num);
            reset_dut();

            for (i = 0; i < 40; i = i + 1) begin
                measurement1 = 16'h2000;

                measurement2 = (i % 2 == 0) ? 16'h2100 : 16'h1F00;
                @(posedge clk);
            end


            #1;



            check_outputs(16'h2000, 16'h0000);
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
        $dumpvars(0,clk, measurement1, measurement2, rst, position_estimate, velocity_estimate);
    end

endmodule
