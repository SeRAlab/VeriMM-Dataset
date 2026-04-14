`timescale 1ns/1ps

module kalman_filter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] q;
    reg [15:0] r;
    reg rst;
    reg [15:0] z;
    wire [15:0] x_est;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    kalman_filter dut (
        .clk(clk),
        .q(q),
        .r(r),
        .rst(rst),
        .z(z),
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
            q = 0;
            r = 0;
            z = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
            $display("DUT Reset performed.");
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Basic Convergence (z=1000)", test_num);
            reset_dut();

            q = 16'd100;
            r = 16'd100;
            z = 16'd1000;


            repeat (50) @(posedge clk);


            #1;



            check_outputs(16'd1000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Negative Measurement (z=-500)", test_num);
            reset_dut();

            q = 16'd50;
            r = 16'd50;
            z = -16'sd500;

            repeat (50) @(posedge clk);


            #1;



            check_outputs(-16'sd500);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: High Measurement Noise (R >> Q)", test_num);
            reset_dut();

            q = 16'd1;
            r = 16'd1000;
            z = 16'd2000;


            repeat (5) @(posedge clk);

            if (x_est < 16'd500) begin
                $display("PASS: Filter responded slowly as expected with high R.");
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: Filter responded too quickly for high R. x_est=%d", x_est);
                fail_count = fail_count + 1;
            end
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: High Process Noise (Q >> R)", test_num);
            reset_dut();

            q = 16'd1000;
            r = 16'd1;
            z = 16'd3000;


            repeat (2) @(posedge clk);


            #1;



            check_outputs(16'd3000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: Minimum Noise Parameter Test", test_num);
            reset_dut();

            q = 16'd1;
            r = 16'd1;
            z = 16'h7FFF;

            repeat (40) @(posedge clk);

            #1;


            check_outputs(16'h7FFF);
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
        input [15:0] expected_x_est;
        begin
            if (expected_x_est === (expected_x_est ^ x_est ^ expected_x_est)) begin
                $display("PASS");
                $display("  Outputs: x_est=%h",
                         x_est);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: x_est=%h",
                         expected_x_est);
                $display("  Got:      x_est=%h",
                         x_est);
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
        $dumpvars(0,clk, q, r, rst, z, x_est);
    end

endmodule
