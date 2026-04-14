`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst_n;
    reg [15:0] x_im;
    reg [15:0] x_re;
    reg [15:0] y_im;
    reg [15:0] y_re;
    wire [31:0] z_im;
    wire [31:0] z_re;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .rst_n(rst_n),
        .x_im(x_im),
        .x_re(x_re),
        .y_im(y_im),
        .y_re(y_re),
        .z_im(z_im),
        .z_re(z_re)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            x_re = 0;
            x_im = 0;
            y_re = 0;
            y_im = 0;
            @(posedge clk);
            #1 rst_n = 1;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            x_re = 16'sd5; x_im = 16'sd3;
            y_re = 16'sd4; y_im = 16'sd2;
            @(posedge clk);
            #1;

            check_outputs(32'sd22, 32'sd14);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            x_re = -16'sd10; x_im = 16'sd5;
            y_re = 16'sd2;   y_im = -16'sd3;
            @(posedge clk);
            #1;

            check_outputs(32'sd40, -32'sd5);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            x_re = 16'sd0;   x_im = 16'sd0;
            y_re = 16'sd123; y_im = 16'sd456;
            @(posedge clk);
            #1;

            check_outputs(32'sd0, 32'sd0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            x_re = 16'sd15; x_im = 16'sd25;
            y_re = 16'sd1;  y_im = 16'sd0;
            @(posedge clk);
            #1;

            check_outputs(32'sd25, 32'sd15);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            x_re = 16'sd1000; x_im = 16'sd1000;
            y_re = 16'sd1000; y_im = -16'sd1000;
            @(posedge clk);
            #1;

            check_outputs(32'sd0, 32'sd2000000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
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
        input [31:0] expected_z_im;
        input [31:0] expected_z_re;
        begin
            if (expected_z_im === (expected_z_im ^ z_im ^ expected_z_im) &&
                expected_z_re === (expected_z_re ^ z_re ^ expected_z_re)) begin
                $display("PASS");
                $display("  Outputs: z_im=%h, z_re=%h",
                         z_im, z_re);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: z_im=%h, z_re=%h",
                         expected_z_im, expected_z_re);
                $display("  Got:      z_im=%h, z_re=%h",
                         z_im, z_re);
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
        $dumpvars(0,clk, rst_n, x_im, x_re, y_im, y_re, z_im, z_re);
    end

endmodule
