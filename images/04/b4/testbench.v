`timescale 1ns/1ps

module kalman_filter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] dt;
    reg reset;
    reg [15:0] v_prev;
    reg [15:0] x_prev;
    reg [15:0] z_measured;
    wire [15:0] v_est;
    wire [15:0] x_est;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    kalman_filter dut (
        .clk(clk),
        .dt(dt),
        .reset(reset),
        .v_prev(v_prev),
        .x_prev(x_prev),
        .z_measured(z_measured),
        .v_est(v_est),
        .x_est(x_est)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            dt = 0;
            v_prev = 0;
            x_prev = 0;
            z_measured = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Zero State Initialization", test_num);
            reset_dut();

            dt = 16'h0001;
            v_prev = 16'h0000;
            x_prev = 16'h0000;
            z_measured = 16'h0000;

            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0000, 16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Perfect Prediction", test_num);
            reset_dut();

            dt = 16'h0002;
            v_prev = 16'h000A;
            x_prev = 16'h0064;
            z_measured = 16'h0078;

            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(16'h000A, 16'h0078);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Measurement Correction (Positive)", test_num);
            reset_dut();

            dt = 16'h0001;
            v_prev = 16'h0000;
            x_prev = 16'h01F4;
            z_measured = 16'h0258;

            repeat(2) @(posedge clk);
            #1;

            #1;


            check_outputs(16'h000A, 16'h0226);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Large Time Step Match", test_num);
            reset_dut();

            dt = 16'h000A;
            v_prev = 16'h0032;
            x_prev = 16'h03E8;
            z_measured = 16'h05DC;

            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0032, 16'h05DC);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Noisy Measurement Filtering", test_num);
            reset_dut();

            dt = 16'h0001;
            v_prev = 16'h0000;
            x_prev = 16'h07D0;
            z_measured = 16'h0834;

            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(16'h000A, 16'h0802);
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
        input [15:0] expected_v_est;
        input [15:0] expected_x_est;
        begin
            if (expected_v_est === (expected_v_est ^ v_est ^ expected_v_est) &&
                expected_x_est === (expected_x_est ^ x_est ^ expected_x_est)) begin
                $display("PASS");
                $display("  Outputs: v_est=%h, x_est=%h",
                         v_est, x_est);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: v_est=%h, x_est=%h",
                         expected_v_est, expected_x_est);
                $display("  Got:      v_est=%h, x_est=%h",
                         v_est, x_est);
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
        $dumpvars(0,clk, dt, reset, v_prev, x_prev, z_measured, v_est, x_est);
    end

endmodule
