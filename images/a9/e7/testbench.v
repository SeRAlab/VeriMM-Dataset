`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg [4:0] x;
    reg xval;
    wire [4:0] y;
    wire yval;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .rst(rst),
        .x(x),
        .xval(xval),
        .y(y),
        .yval(yval)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            x = 0;
            xval = 0;
            @(posedge clk);
            #1 rst = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            xval = 0;
            x = 5'b01010;
            #1;

            check_outputs(5'd5, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();

            xval = 0; x = 5'b10100;
            x = 5'd20;
            @(posedge clk);

            #1 xval = 1;
            @(posedge clk);

            #1 xval = 0; x = 5'd8;

            #1;


            check_outputs(y + 5'd4, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            xval = 0;
            x = 5'b11100;
            #1;

            check_outputs(5'b11110, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();

            xval = 0; x = 5'd6;
            @(posedge clk);

            #1 xval = 1;
            @(posedge clk);

            #1 xval = 0; x = 5'b10110;
            #1;

            check_outputs(5'b11110, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            xval = 0;
            x = 5'b11101;
            #1;

            check_outputs(5'b11110, 1'b1);
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
        input [4:0] expected_y;
        input expected_yval;
        begin
            if (expected_y === (expected_y ^ y ^ expected_y) &&
                expected_yval === (expected_yval ^ yval ^ expected_yval)) begin
                $display("PASS");
                $display("  Outputs: y=%h, yval=%b",
                         y, yval);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: y=%h, yval=%b",
                         expected_y, expected_yval);
                $display("  Got:      y=%h, yval=%b",
                         y, yval);
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
        $dumpvars(0,clk, rst, x, xval, y, yval);
    end

endmodule
