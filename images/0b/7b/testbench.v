`timescale 1ns/1ps

module kalman_filter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] q;
    reg [15:0] r;
    reg reset;
    reg [15:0] z;
    wire [15:0] v_hat;
    wire [15:0] x_hat;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    kalman_filter dut (
        .clk(clk),
        .q(q),
        .r(r),
        .reset(reset),
        .z(z),
        .v_hat(v_hat),
        .x_hat(x_hat)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            q = 0;
            r = 0;
            z = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Equal Noise (K=0.5)", test_num);
            reset_dut();
            q = 16'd100;
            r = 16'd100;
            z = 16'd1000;
            @(posedge clk);
            #2;
            #1;

            check_outputs(16'd500, 16'd500);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: High Measurement Noise (K=0.25)", test_num);
            reset_dut();
            q = 16'd50;
            r = 16'd150;
            z = 16'd1000;
            @(posedge clk);
            #2;
            #1;

            check_outputs(16'd250, 16'd250);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Low Measurement Noise (K=0.75)", test_num);
            reset_dut();
            q = 16'd150;
            r = 16'd50;
            z = 16'd1000;
            @(posedge clk);
            #2;
            #1;

            check_outputs(16'd750, 16'd750);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Trust Measurement Fully (K=1.0)", test_num);
            reset_dut();
            q = 16'd200;
            r = 16'd0;
            z = 16'd800;
            @(posedge clk);
            #2;
            #1;

            check_outputs(16'd800, 16'd800);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Sequential Movement", test_num);
            reset_dut();
            q = 16'd100;
            r = 16'd100;
            z = 16'd100;
            @(posedge clk);
            #1 z = 16'd100;
            @(posedge clk);
            #2;
            #1;

            check_outputs(16'd50, 16'd100);
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
        input [15:0] expected_v_hat;
        input [15:0] expected_x_hat;
        begin
            if (expected_v_hat === (expected_v_hat ^ v_hat ^ expected_v_hat) &&
                expected_x_hat === (expected_x_hat ^ x_hat ^ expected_x_hat)) begin
                $display("PASS");
                $display("  Outputs: v_hat=%h, x_hat=%h",
                         v_hat, x_hat);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: v_hat=%h, x_hat=%h",
                         expected_v_hat, expected_x_hat);
                $display("  Got:      v_hat=%h, x_hat=%h",
                         v_hat, x_hat);
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
        $dumpvars(0,clk, q, r, reset, z, v_hat, x_hat);
    end

endmodule
