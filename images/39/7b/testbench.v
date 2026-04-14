`timescale 1ns/1ps

module kalman_filter_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] Q;
    reg [15:0] R;
    reg clk;
    reg rst;
    reg [15:0] x_prev;
    reg [15:0] z;
    wire [15:0] P;
    wire [15:0] x_est;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    kalman_filter dut (
        .Q(Q),
        .R(R),
        .clk(clk),
        .rst(rst),
        .x_prev(x_prev),
        .z(z),
        .P(P),
        .x_est(x_est)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            Q = 0; R = 0; x_prev = 0; z = 0;
            @(posedge clk);
            #2 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Initial Update (K=0)", test_num);
            reset_dut();
            Q = 16'h000A;
            R = 16'h0014;
            x_prev = 16'h0064;
            z = 16'h0096;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h000A, 16'h0064);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: High Gain (R=0)", test_num);
            reset_dut();

            Q = 10; R = 5; x_prev = 100; z = 100;
            @(posedge clk);

            #1;
            Q = 16'h0005;
            R = 16'h0000;
            x_prev = 16'h0064;
            z = 16'h00C8;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0005, 16'h00C8);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Covariance Accumulation", test_num);
            reset_dut();

            Q = 20; R = 100; x_prev = 50; z = 50;
            @(posedge clk);
            #1;

            Q = 20; R = 100; x_prev = 50; z = 80;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0028, 16'h0032);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Zero Noise Recovery", test_num);
            reset_dut();

            Q = 50; R = 10; x_prev = 10; z = 10;
            @(posedge clk);
            #1;

            Q = 0; R = 0; x_prev = 10; z = 500;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0000, 16'h01F4);
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
        input [15:0] expected_P;
        input [15:0] expected_x_est;
        begin
            if (expected_P === (expected_P ^ P ^ expected_P) &&
                expected_x_est === (expected_x_est ^ x_est ^ expected_x_est)) begin
                $display("PASS");
                $display("  Outputs: P=%h, x_est=%h",
                         P, x_est);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: P=%h, x_est=%h",
                         expected_P, expected_x_est);
                $display("  Got:      P=%h, x_est=%h",
                         P, x_est);
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
        $dumpvars(0,Q, R, clk, rst, x_prev, z, P, x_est);
    end

endmodule
