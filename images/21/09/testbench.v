`timescale 1ns/1ps

module kalman_filter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] position_meas;
    reg reset;
    reg [15:0] velocity_meas;
    wire [15:0] position_est;
    wire [15:0] velocity_est;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    kalman_filter dut (
        .clk(clk),
        .position_meas(position_meas),
        .reset(reset),
        .velocity_meas(velocity_meas),
        .position_est(position_est),
        .velocity_est(velocity_est)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            $display("\nResetting DUT...");
            reset = 1;
            position_meas = 16'h0;
            velocity_meas = 16'h0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Initialization Check", test_num);
            reset_dut();


            #1;



            check_outputs(16'h0000, 16'h0000);
        end
        endtask

    task testcase002;

        integer i;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Static Position Convergence", test_num);
            reset_dut();


            position_meas = 16'd1000;
            velocity_meas = 16'd0;


            for (i = 0; i < 20; i = i + 1) begin
                @(posedge clk);
            end


            #1;



            check_outputs(16'd1000, 16'd0);
        end
        endtask

    task testcase003;

        integer i;
        reg [15:0] current_pos;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Constant Velocity Tracking", test_num);
            reset_dut();

            current_pos = 16'd100;
            velocity_meas = 16'd50;

            for (i = 0; i < 10; i = i + 1) begin
                position_meas = current_pos;
                @(posedge clk);
                current_pos = current_pos + 16'd50;
            end



            #1;




            check_outputs(16'd600, 16'd50);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Outlier Rejection (Smoothing)", test_num);
            reset_dut();


            position_meas = 16'd500;
            velocity_meas = 16'd0;
            for (i = 0; i < 10; i = i + 1) @(posedge clk);


            position_meas = 16'd2000;
            @(posedge clk);


            position_meas = 16'd500;
            @(posedge clk);




            if (position_est < 16'd800 && position_est > 16'd400) begin
                $display("Smoothing Logic verified.");
                #1;

                check_outputs(position_est, velocity_est);
            end else begin
                $display("Smoothing Failed: Output followed outlier too closely.");
                #1;

                check_outputs(16'd500, 16'd0);
            end
        end
        endtask

    task testcase005;

        integer i;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Negative Velocity Tracking", test_num);
            reset_dut();

            position_meas = 16'd1000;
            velocity_meas = 16'shFFCE;

            for (i = 0; i < 10; i = i + 1) begin
                @(posedge clk);
                position_meas = position_meas - 16'd50;
            end


            #1;



            check_outputs(16'd500, 16'shFFCE);
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
        input [15:0] expected_position_est;
        input [15:0] expected_velocity_est;
        begin
            if (expected_position_est === (expected_position_est ^ position_est ^ expected_position_est) &&
                expected_velocity_est === (expected_velocity_est ^ velocity_est ^ expected_velocity_est)) begin
                $display("PASS");
                $display("  Outputs: position_est=%h, velocity_est=%h",
                         position_est, velocity_est);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: position_est=%h, velocity_est=%h",
                         expected_position_est, expected_velocity_est);
                $display("  Got:      position_est=%h, velocity_est=%h",
                         position_est, velocity_est);
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
        $dumpvars(0,clk, position_meas, reset, velocity_meas, position_est, velocity_est);
    end

endmodule
