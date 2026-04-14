`timescale 1ns/1ps

module kalman_filter_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] P_prev;
    reg [15:0] R;
    reg clk;
    reg reset;
    reg [15:0] x_prev;
    reg [15:0] z;
    wire [15:0] P_est;
    wire [15:0] x_est;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    kalman_filter dut (
        .P_prev(P_prev),
        .R(R),
        .clk(clk),
        .reset(reset),
        .x_prev(x_prev),
        .z(z),
        .P_est(P_est),
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
            x_prev = 0;
            z = 0;
            P_prev = 0;
            R = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Gain K=0.5");
            reset_dut();
            test_num = 1;
            x_prev = 16'h000A;
            z      = 16'h0014;
            P_prev = 16'h001E;
            R      = 16'h001E;

            repeat(5) @(posedge clk);
            #1;

            check_outputs(16'h000F, 16'h000F);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Trust measurement (R=0)");
            reset_dut();
            test_num = 2;
            x_prev = 16'h0064;
            z      = 16'h00C8;
            P_prev = 16'h0064;
            R      = 16'h0000;

            repeat(5) @(posedge clk);
            #1;

            check_outputs(16'h0000, 16'h00C8);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Trust prediction (P=0)");
            reset_dut();
            test_num = 3;
            x_prev = 16'h0032;
            z      = 16'h00C8;
            P_prev = 16'h0000;
            R      = 16'h0064;

            repeat(5) @(posedge clk);
            #1;

            check_outputs(16'h0000, 16'h0032);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Gain K=0.75");
            reset_dut();
            test_num = 4;
            x_prev = 16'h0028;
            z      = 16'h0050;
            P_prev = 16'h003C;
            R      = 16'h0014;

            repeat(5) @(posedge clk);
            #1;

            check_outputs(16'h000F, 16'h0046);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: All zero inputs");
            reset_dut();
            test_num = 5;
            x_prev = 16'h0000;
            z      = 16'h0000;
            P_prev = 16'h0000;
            R      = 16'hFFFF;

            repeat(5) @(posedge clk);
            #1;

            check_outputs(16'h0000, 16'h0000);
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
        input [15:0] expected_P_est;
        input [15:0] expected_x_est;
        begin
            if (expected_P_est === (expected_P_est ^ P_est ^ expected_P_est) &&
                expected_x_est === (expected_x_est ^ x_est ^ expected_x_est)) begin
                $display("PASS");
                $display("  Outputs: P_est=%h, x_est=%h",
                         P_est, x_est);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: P_est=%h, x_est=%h",
                         expected_P_est, expected_x_est);
                $display("  Got:      P_est=%h, x_est=%h",
                         P_est, x_est);
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
        $dumpvars(0,P_prev, R, clk, reset, x_prev, z, P_est, x_est);
    end

endmodule
