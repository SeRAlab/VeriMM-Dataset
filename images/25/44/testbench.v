`timescale 1ns/1ps

module KalmanFilter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg [15:0] sensor1;
    reg [15:0] sensor2;
    wire [15:0] error_covariance;
    wire [15:0] estimated_state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    KalmanFilter dut (
        .clk(clk),
        .rst(rst),
        .sensor1(sensor1),
        .sensor2(sensor2),
        .error_covariance(error_covariance),
        .estimated_state(estimated_state)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            sensor1 = 16'h0;
            sensor2 = 16'h0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTest Case %0d: Reset Behavior", test_num);
            reset_dut();

            #1;


            check_outputs(16'h0000, 16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTest Case %0d: Identical Steady-State Inputs", test_num);
            reset_dut();
            sensor1 = 16'd1000;
            sensor2 = 16'd1000;

            repeat(10) @(posedge clk);


            #1;



            check_outputs(16'h000A, 16'h03E8);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTest Case %0d: Sensor Fusion (Different Inputs)", test_num);
            reset_dut();
            sensor1 = 16'd2000;
            sensor2 = 16'd4000;
            repeat(15) @(posedge clk);

            #1;


            check_outputs(16'h0005, 16'h0BB8);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTest Case %0d: Step Change Response", test_num);
            reset_dut();

            sensor1 = 16'd500;
            sensor2 = 16'd500;
            repeat(5) @(posedge clk);

            sensor1 = 16'd1500;
            sensor2 = 16'd500;
            repeat(10) @(posedge clk);

            #1;


            check_outputs(16'h0008, 16'h03E8);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTest Case %0d: Maximum Range Inputs", test_num);
            reset_dut();
            sensor1 = 16'hFFFF;
            sensor2 = 16'hFFFF;
            repeat(10) @(posedge clk);

            #1;


            check_outputs(16'h0002, 16'hFFFF);
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
        input [15:0] expected_error_covariance;
        input [15:0] expected_estimated_state;
        begin
            if (expected_error_covariance === (expected_error_covariance ^ error_covariance ^ expected_error_covariance) &&
                expected_estimated_state === (expected_estimated_state ^ estimated_state ^ expected_estimated_state)) begin
                $display("PASS");
                $display("  Outputs: error_covariance=%h, estimated_state=%h",
                         error_covariance, estimated_state);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: error_covariance=%h, estimated_state=%h",
                         expected_error_covariance, expected_estimated_state);
                $display("  Got:      error_covariance=%h, estimated_state=%h",
                         error_covariance, estimated_state);
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
        $dumpvars(0,clk, rst, sensor1, sensor2, error_covariance, estimated_state);
    end

endmodule
