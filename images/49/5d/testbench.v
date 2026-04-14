`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg [15:0] constant;
    reg enable;
    reg reset;
    reg [15:0] xi;
    reg [15:0] yi;
    reg [15:0] zi;
    wire [15:0] xo;
    wire [15:0] yo;
    wire [15:0] zo;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .constant(constant),
        .enable(enable),
        .reset(reset),
        .xi(xi),
        .yi(yi),
        .zi(zi),
        .xo(xo),
        .yo(yo),
        .zo(zo)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            reset = 1;
            enable = 0;
            xi = 0;
            yi = 0;
            zi = 0;
            constant = 0;
            @(posedge clock);
            #2 reset = 0;
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Reset verification", test_num);
            reset = 1;
            enable = 1;
            xi = 16'h1234;
            yi = 16'h5678;
            zi = 16'h0010;
            constant = 16'h0005;
            @(posedge clock);
            #1 #1;
 check_outputs(16'h0000, 16'h0000, 16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Positive Angle Rotation (Shift 0)", test_num);
            reset_dut();
            xi = 16'd1000;
            yi = 16'd500;
            zi = 16'd100;
            constant = 16'd45;
            enable = 1;
            @(posedge clock);
            #1 #1;
 check_outputs(16'd500, 16'd1500, 16'd55);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Negative Angle Rotation (Shift 0)", test_num);
            reset_dut();
            xi = 16'd1000;
            yi = 16'd500;
            zi = 16'hFF9C;
            constant = 16'd45;
            enable = 1;
            @(posedge clock);



            #1 #1;
 check_outputs(16'h05DC, 16'hFE0C, 16'hFFC9);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Enable signal check", test_num);
            reset_dut();
            xi = 16'hAAAA;
            yi = 16'hBBBB;
            zi = 16'h00FF;
            constant = 16'h0001;
            enable = 0;
            @(posedge clock);
            #1 #1;
 check_outputs(16'h0000, 16'h0000, 16'h0000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Large Value Operation", test_num);
            reset_dut();
            xi = 16'h2000;
            yi = 16'h1000;
            zi = 16'h0010;
            constant = 16'h0020;
            enable = 1;
            @(posedge clock);



            #1 #1;
 check_outputs(16'h1000, 16'h3000, 16'hFFF0);
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
        input [15:0] expected_xo;
        input [15:0] expected_yo;
        input [15:0] expected_zo;
        begin
            if (expected_xo === (expected_xo ^ xo ^ expected_xo) &&
                expected_yo === (expected_yo ^ yo ^ expected_yo) &&
                expected_zo === (expected_zo ^ zo ^ expected_zo)) begin
                $display("PASS");
                $display("  Outputs: xo=%h, yo=%h, zo=%h",
                         xo, yo, zo);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: xo=%h, yo=%h, zo=%h",
                         expected_xo, expected_yo, expected_zo);
                $display("  Got:      xo=%h, yo=%h, zo=%h",
                         xo, yo, zo);
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
        $dumpvars(0,clock, constant, enable, reset, xi, yi, zi, xo, yo, zo);
    end

endmodule
