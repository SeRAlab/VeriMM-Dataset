`timescale 1ns/1ps

module kalman_filter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] pos1;
    reg [15:0] pos2;
    reg rst;
    wire [15:0] error_cov;
    wire [15:0] est_pos;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    kalman_filter dut (
        .clk(clk),
        .pos1(pos1),
        .pos2(pos2),
        .rst(rst),
        .error_cov(error_cov),
        .est_pos(est_pos)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            pos1 = 0;
            pos2 = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Initial Reset State", test_num);
            reset_dut();

            #1;


            check_outputs(16'h0000, 16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Identical Sensor Inputs", test_num);
            reset_dut();
            pos1 = 16'd1000;
            pos2 = 16'd1000;
            repeat(5) @(posedge clk);

            #1;


            check_outputs(error_cov, 16'd1000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Sensor Fusion Midpoint", test_num);
            reset_dut();
            pos1 = 16'd200;
            pos2 = 16'd400;
            repeat(10) @(posedge clk);

            #1;


            check_outputs(error_cov, 16'd300);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Dynamic Step Response", test_num);
            reset_dut();
            pos1 = 16'd100;
            pos2 = 16'd100;
            repeat(5) @(posedge clk);

            pos1 = 16'd500;
            pos2 = 16'd500;
            repeat(10) @(posedge clk);

            #1;


            check_outputs(error_cov, 16'd500);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Boundary Values (Max Scale)", test_num);
            reset_dut();
            pos1 = 16'hFFFF;
            pos2 = 16'hFFFF;
            repeat(5) @(posedge clk);
            #1;

            check_outputs(error_cov, 16'hFFFF);
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
        input [15:0] expected_error_cov;
        input [15:0] expected_est_pos;
        begin
            if (expected_error_cov === (expected_error_cov ^ error_cov ^ expected_error_cov) &&
                expected_est_pos === (expected_est_pos ^ est_pos ^ expected_est_pos)) begin
                $display("PASS");
                $display("  Outputs: error_cov=%h, est_pos=%h",
                         error_cov, est_pos);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: error_cov=%h, est_pos=%h",
                         expected_error_cov, expected_est_pos);
                $display("  Got:      error_cov=%h, est_pos=%h",
                         error_cov, est_pos);
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
        $dumpvars(0,clk, pos1, pos2, rst, error_cov, est_pos);
    end

endmodule
