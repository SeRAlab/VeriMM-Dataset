`timescale 1ns/1ps

module kalman_filter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg [15:0] z;
    reg [15:0] z_v;
    wire [15:0] v_est;
    wire [15:0] x_est;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    kalman_filter dut (
        .clk(clk),
        .reset(reset),
        .z(z),
        .z_v(z_v),
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
            @(posedge clk);
            reset = 1;
            z = 0;
            z_v = 0;
            repeat (2) @(posedge clk);
            reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Reset State Verification", test_num);
            reset_dut();

            #1;


            check_outputs(16'h0000, 16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Single Step Update (z=100, zv=20)", test_num);
            reset_dut();

            z = 16'd100;
            z_v = 16'd20;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'd10, 16'd50);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Multi-step Tracking", test_num);
            reset_dut();


            z = 16'd100;
            z_v = 16'd20;
            @(posedge clk);


            z = 16'd160;
            z_v = 16'd20;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'd15, 16'd110);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Negative Measurements", test_num);
            reset_dut();

            z = -16'd100;
            z_v = -16'd40;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'hFFEC, 16'hFFCE);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Zero Innovation (Steady State)", test_num);
            reset_dut();

            z = 16'd100;
            z_v = 16'd20;
            @(posedge clk);

            z = 16'd60;
            z_v = 16'd10;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'd10, 16'd60);
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
        $dumpvars(0,clk, reset, z, z_v, v_est, x_est);
    end

endmodule
