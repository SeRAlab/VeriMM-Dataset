`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] cb;
    reg clk;
    reg [7:0] cr;
    reg [7:0] y;
    wire [7:0] blue;
    wire [7:0] green;
    wire [7:0] red;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .cb(cb),
        .clk(clk),
        .cr(cr),
        .y(y),
        .blue(blue),
        .green(green),
        .red(red)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            y = 8'd0;
            cb = 8'd128;
            cr = 8'd128;
            repeat(2) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            y = 8'd128;
            cb = 8'd128;
            cr = 8'd128;
            repeat(5) @(posedge clk);
            $display("Test Case 001: Mid-point Gray");
            #1;

            check_outputs(8'd128, 8'd128, 8'd128);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            y = 8'd255;
            cb = 8'd128;
            cr = 8'd128;
            repeat(5) @(posedge clk);
            $display("Test Case 002: Full White");
            #1;

            check_outputs(8'd255, 8'd255, 8'd255);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            y = 8'd0;
            cb = 8'd128;
            cr = 8'd128;
            repeat(5) @(posedge clk);
            $display("Test Case 003: Full Black");
            #1;

            check_outputs(8'd0, 8'd0, 8'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            y = 8'd76;
            cb = 8'd84;
            cr = 8'd255;
            repeat(5) @(posedge clk);
            $display("Test Case 004: Standard Red");
            #1;

            check_outputs(8'd0, 8'd0, 8'd254);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            y = 8'd149;
            cb = 8'd43;
            cr = 8'd21;
            repeat(5) @(posedge clk);
            $display("Test Case 005: Standard Green");
            #1;

            check_outputs(8'd1, 8'd255, 8'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            y = 8'd29;
            cb = 8'd255;
            cr = 8'd107;
            repeat(5) @(posedge clk);
            $display("Test Case 006: Standard Blue");
            #1;

            check_outputs(8'd254, 8'd0, 8'd0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            y = 8'd255;
            cb = 8'd255;
            cr = 8'd255;
            repeat(5) @(posedge clk);
            $display("Test Case 007: High Saturation Clamp");



            #1;




            check_outputs(8'd255, 8'd121, 8'd255);
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
        input [7:0] expected_blue;
        input [7:0] expected_green;
        input [7:0] expected_red;
        begin
            if (expected_blue === (expected_blue ^ blue ^ expected_blue) &&
                expected_green === (expected_green ^ green ^ expected_green) &&
                expected_red === (expected_red ^ red ^ expected_red)) begin
                $display("PASS");
                $display("  Outputs: blue=%h, green=%h, red=%h",
                         blue, green, red);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: blue=%h, green=%h, red=%h",
                         expected_blue, expected_green, expected_red);
                $display("  Got:      blue=%h, green=%h, red=%h",
                         blue, green, red);
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
        $dumpvars(0,cb, clk, cr, y, blue, green, red);
    end

endmodule
