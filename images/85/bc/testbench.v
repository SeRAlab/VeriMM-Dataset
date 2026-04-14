`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] a;
    reg [3:0] b;
    reg [7:0] c;
    reg clk;
    wire [8:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .c(c),
        .clk(clk),
        .y(y)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            a = 0;
            b = 0;
            c = 0;
            @(posedge clk);
            #1;


        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Small Values", test_num);
            reset_dut();
            a = 4'd2; b = 4'd3; c = 8'd10;
            @(posedge clk);
            expected_y = (expected_y + (a * b) + c) & 9'h1FF;
            #2;
            #1;

            check_outputs(expected_y);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Large Multipliers", test_num);
            reset_dut();
            a = 4'd15; b = 4'd10; c = 8'd20;
            @(posedge clk);
            expected_y = (expected_y + (a * b) + c) & 9'h1FF;
            #2;
            #1;

            check_outputs(expected_y);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Large C Input", test_num);
            reset_dut();
            a = 4'd5; b = 4'd4; c = 8'd250;
            @(posedge clk);
            expected_y = (expected_y + (a * b) + c) & 9'h1FF;
            #2;
            #1;

            check_outputs(expected_y);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Overflow Wrap-around", test_num);
            reset_dut();

            a = 4'd15; b = 4'd15; c = 8'd100;
            @(posedge clk);
            expected_y = (expected_y + (a * b) + c) & 9'h1FF;
            #2;
            #1;

            check_outputs(expected_y);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Zero Inputs Maintenance", test_num);
            reset_dut();
            a = 4'd0; b = 4'd15; c = 8'd0;
            @(posedge clk);
            expected_y = (expected_y + (a * b) + c) & 9'h1FF;
            #2;
            #1;

            check_outputs(expected_y);
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
        input [8:0] expected_y;
        begin
            if (expected_y === (expected_y ^ y ^ expected_y)) begin
                $display("PASS");
                $display("  Outputs: y=%h",
                         y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: y=%h",
                         expected_y);
                $display("  Got:      y=%h",
                         y);
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
        $dumpvars(0,a, b, c, clk, y);
    end

endmodule
