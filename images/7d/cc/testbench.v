`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] a;
    reg clk;
    reg [15:0] dt;
    reg enable;
    reg rst;
    wire busy;
    wire [31:0] v;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .clk(clk),
        .dt(dt),
        .enable(enable),
        .rst(rst),
        .busy(busy),
        .v(v)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            enable = 0;
            a = 0;
            dt = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Single cycle accumulation", test_num);
            reset_dut();
            a = 16'd10;
            dt = 16'd5;
            enable = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 32'd50);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Multiple cycles constant inputs", test_num);
            reset_dut();
            a = 16'd2;
            dt = 16'd3;
            enable = 1;
            repeat(4) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 32'd24);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Varying inputs", test_num);
            reset_dut();
            enable = 1;

            a = 16'd5; dt = 16'd2; @(posedge clk);
            a = 16'd10; dt = 16'd3; @(posedge clk);
            a = 16'd1; dt = 16'd1; @(posedge clk);

            #1;
            #1;

            check_outputs(1'b1, 32'd41);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Enable/Disable behavior", test_num);
            reset_dut();

            a = 16'd10; dt = 16'd2; enable = 1; @(posedge clk);
            enable = 0; @(posedge clk);
            enable = 0; @(posedge clk);
            a = 16'd5; dt = 16'd4; enable = 1; @(posedge clk);

            #1;
            #1;

            check_outputs(1'b1, 32'd40);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Large input values", test_num);
            reset_dut();

            a = 16'hFFFF;
            dt = 16'd2;
            enable = 1;
            @(posedge clk);

            #1;
            #1;

            check_outputs(1'b1, 32'd131070);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Reset while busy", test_num);
            reset_dut();

            a = 16'd100; dt = 16'd100; enable = 1; @(posedge clk);
            rst = 1; @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 32'd0);
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
        input expected_busy;
        input [31:0] expected_v;
        begin
            if (expected_busy === (expected_busy ^ busy ^ expected_busy) &&
                expected_v === (expected_v ^ v ^ expected_v)) begin
                $display("PASS");
                $display("  Outputs: busy=%b, v=%h",
                         busy, v);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: busy=%b, v=%h",
                         expected_busy, expected_v);
                $display("  Got:      busy=%b, v=%h",
                         busy, v);
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
        $dumpvars(0,a, clk, dt, enable, rst, busy, v);
    end

endmodule
