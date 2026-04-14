`timescale 1ns/1ps

module kalman_filter_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] Q;
    reg [15:0] R;
    reg clk;
    reg reset;
    reg [15:0] x_est;
    reg [15:0] z_measure;
    wire [15:0] x_new;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    kalman_filter dut (
        .Q(Q),
        .R(R),
        .clk(clk),
        .reset(reset),
        .x_est(x_est),
        .z_measure(z_measure),
        .x_new(x_new)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            Q = 0;
            R = 0;
            x_est = 0;
            z_measure = 0;
            @(posedge clk);
            #2;
            reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            Q = 16'd10;
            R = 16'd10;
            x_est = 16'd100;
            z_measure = 16'd200;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'd150);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            Q = 16'd80;
            R = 16'd20;
            x_est = 16'd1000;
            z_measure = 16'd2000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'd1800);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            Q = 16'd20;
            R = 16'd80;
            x_est = 16'd1000;
            z_measure = 16'd2000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'd1200);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            Q = 16'd0;
            R = 16'd100;
            x_est = 16'd500;
            z_measure = 16'd1000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'd500);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            Q = 16'd100;
            R = 16'd0;
            x_est = 16'd500;
            z_measure = 16'd1000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'd1000);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            Q = 16'd50;
            R = 16'd50;
            x_est = 16'd2000;
            z_measure = 16'd1000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'd1500);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = 7;
            Q = 16'd1;
            R = 16'd2;
            x_est = 16'd10;
            z_measure = 16'd20;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'd13);
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
        testcase006();
        testcase007();
        
        
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
        input [15:0] expected_x_new;
        begin
            if (expected_x_new === (expected_x_new ^ x_new ^ expected_x_new)) begin
                $display("PASS");
                $display("  Outputs: x_new=%h",
                         x_new);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: x_new=%h",
                         expected_x_new);
                $display("  Got:      x_new=%h",
                         x_new);
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
        $dumpvars(0,Q, R, clk, reset, x_est, z_measure, x_new);
    end

endmodule
