`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg gxgyrun;
    reg rstn;
    reg [23:0] x1;
    reg [23:0] x2;
    reg [23:0] x3;
    wire [10:0] gx;
    wire [10:0] gy;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .gxgyrun(gxgyrun),
        .rstn(rstn),
        .x1(x1),
        .x2(x2),
        .x3(x3),
        .gx(gx),
        .gy(gy)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rstn = 0;
            gxgyrun = 0;
            x1 = 0; x2 = 0; x3 = 0;
            #20;
            rstn = 1;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            #1;

            check_outputs(11'h000, 11'h000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            gxgyrun = 1;
            x1 = 24'hFFFFFF;
            x2 = 24'hFFFFFF;
            x3 = 24'hFFFFFF;
            #1;

            check_outputs(11'h000, 11'h000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            gxgyrun = 1;
            x1 = 24'h0000FF;
            x2 = 24'h0000FF;
            x3 = 24'h0000FF;
            #1;

            check_outputs(11'h3FC, 11'h000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            gxgyrun = 1;
            x1 = 24'hFFFFFF;
            x2 = 24'h000000;
            x3 = 24'h000000;
            #1;

            check_outputs(11'h000, 11'h3FC);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            gxgyrun = 1;
            x1 = 24'hFF0000;
            x2 = 24'hFF0000;
            x3 = 24'hFF0000;
            #1;

            check_outputs(11'h404, 11'h000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            gxgyrun = 0;
            x1 = 24'hFFFFFF;
            x2 = 24'hFFFFFF;
            x3 = 24'hFFFFFF;

            #1;


            check_outputs(11'h000, 11'h000);
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
        input [10:0] expected_gx;
        input [10:0] expected_gy;
        begin
            if (expected_gx === (expected_gx ^ gx ^ expected_gx) &&
                expected_gy === (expected_gy ^ gy ^ expected_gy)) begin
                $display("PASS");
                $display("  Outputs: gx=%h, gy=%h",
                         gx, gy);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: gx=%h, gy=%h",
                         expected_gx, expected_gy);
                $display("  Got:      gx=%h, gy=%h",
                         gx, gy);
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
        $dumpvars(0,clk, gxgyrun, rstn, x1, x2, x3, gx, gy);
    end

endmodule
