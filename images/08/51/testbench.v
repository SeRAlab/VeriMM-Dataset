`timescale 1ns/1ps

module SLAM_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] landmark_x;
    reg [15:0] landmark_y;
    reg [15:0] odometry_x;
    reg [15:0] odometry_y;
    reg reset;
    wire [15:0] estimated_x;
    wire [15:0] estimated_y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    SLAM dut (
        .clk(clk),
        .landmark_x(landmark_x),
        .landmark_y(landmark_y),
        .odometry_x(odometry_x),
        .odometry_y(odometry_y),
        .reset(reset),
        .estimated_x(estimated_x),
        .estimated_y(estimated_y)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            landmark_x = 0;
            landmark_y = 0;
            odometry_x = 0;
            odometry_y = 0;
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
            $display("\nTestcase %0d: Initial Reset State", test_num);
            reset_dut();

            #1;


            check_outputs(16'h0000, 16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Matching Odometry and Landmark", test_num);
            reset_dut();

            odometry_x = 16'h0064;
            odometry_y = 16'h00C8;
            landmark_x = 16'h0064;
            landmark_y = 16'h00C8;

            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0064, 16'h00C8);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Position Fusion Calculation", test_num);
            reset_dut();

            odometry_x = 16'h0100;
            odometry_y = 16'h0200;
            landmark_x = 16'h01F4;
            landmark_y = 16'h02EE;


            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(16'h017A, 16'h0277);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Large Coordinate Handling", test_num);
            reset_dut();

            odometry_x = 16'hFF00;
            odometry_y = 16'hFE00;
            landmark_x = 16'hFE00;
            landmark_y = 16'hFC00;


            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(16'hFE80, 16'hFD00);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: Correction toward Origin", test_num);
            reset_dut();

            odometry_x = 16'h03E8;
            odometry_y = 16'h03E8;
            landmark_x = 16'h0000;
            landmark_y = 16'h0000;


            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(16'h01F4, 16'h01F4);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTestcase %0d: Sequential Update", test_num);
            reset_dut();


            odometry_x = 16'h000A;
            odometry_y = 16'h000A;
            landmark_x = 16'h000E;
            landmark_y = 16'h000E;
            repeat(1) @(posedge clk);


            odometry_x = 16'h0014;
            odometry_y = 16'h0014;
            landmark_x = 16'h001E;
            landmark_y = 16'h001E;

            repeat(2) @(posedge clk);
            #1;

            #1;


            check_outputs(16'h0019, 16'h0019);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("SLAM Testbench");
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
        input [15:0] expected_estimated_x;
        input [15:0] expected_estimated_y;
        begin
            if (expected_estimated_x === (expected_estimated_x ^ estimated_x ^ expected_estimated_x) &&
                expected_estimated_y === (expected_estimated_y ^ estimated_y ^ expected_estimated_y)) begin
                $display("PASS");
                $display("  Outputs: estimated_x=%h, estimated_y=%h",
                         estimated_x, estimated_y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: estimated_x=%h, estimated_y=%h",
                         expected_estimated_x, expected_estimated_y);
                $display("  Got:      estimated_x=%h, estimated_y=%h",
                         estimated_x, estimated_y);
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
        $dumpvars(0,clk, landmark_x, landmark_y, odometry_x, odometry_y, reset, estimated_x, estimated_y);
    end

endmodule
