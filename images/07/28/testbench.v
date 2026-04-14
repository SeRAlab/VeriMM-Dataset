`timescale 1ns/1ps

module kalman_filter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] measure_pos;
    reg [15:0] measure_vel;
    reg reset;
    wire [15:0] est_pos;
    wire [15:0] est_vel;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    kalman_filter dut (
        .clk(clk),
        .measure_pos(measure_pos),
        .measure_vel(measure_vel),
        .reset(reset),
        .est_pos(est_pos),
        .est_vel(est_vel)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            measure_pos = 16'h0000;
            measure_vel = 16'h0000;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Running Testcase %0d: Reset State Verification", test_num);
            reset_dut();

            #1;


            check_outputs(16'h0000, 16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Running Testcase %0d: Static Position (Pos=100, Vel=0)", test_num);
            reset_dut();
            measure_pos = 16'd100;
            measure_vel = 16'd0;


            repeat(10) @(posedge clk);

            #1;


            check_outputs(16'd100, 16'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Running Testcase %0d: Constant Velocity Tracking", test_num);
            reset_dut();


            measure_pos = 16'd10;
            measure_vel = 16'd5;
            @(posedge clk);


            measure_pos = 16'd15;
            measure_vel = 16'd5;
            repeat(5) @(posedge clk);

            #1;


            check_outputs(16'd15, 16'd5);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Running Testcase %0d: Sudden Velocity Change", test_num);
            reset_dut();


            measure_pos = 16'd100;
            measure_vel = 16'd50;
            repeat(2) @(posedge clk);


            measure_pos = 16'd150;
            measure_vel = 16'd0;
            repeat(10) @(posedge clk);

            #1;


            check_outputs(16'd150, 16'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Running Testcase %0d: Large Value Handling", test_num);
            reset_dut();

            measure_pos = 16'hFFFF;
            measure_vel = 16'h0001;
            repeat(5) @(posedge clk);

            #1;


            check_outputs(16'hFFFF, 16'h0001);
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
        input [15:0] expected_est_pos;
        input [15:0] expected_est_vel;
        begin
            if (expected_est_pos === (expected_est_pos ^ est_pos ^ expected_est_pos) &&
                expected_est_vel === (expected_est_vel ^ est_vel ^ expected_est_vel)) begin
                $display("PASS");
                $display("  Outputs: est_pos=%h, est_vel=%h",
                         est_pos, est_vel);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: est_pos=%h, est_vel=%h",
                         expected_est_pos, expected_est_vel);
                $display("  Got:      est_pos=%h, est_vel=%h",
                         est_pos, est_vel);
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
        $dumpvars(0,clk, measure_pos, measure_vel, reset, est_pos, est_vel);
    end

endmodule
