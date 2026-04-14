`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] bcd_in;
    reg clk;
    reg [3:0] decimal_points;
    wire [6:0] a_to_g;
    wire [3:0] anode;
    wire decimal_point;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .bcd_in(bcd_in),
        .clk(clk),
        .decimal_points(decimal_points),
        .a_to_g(a_to_g),
        .anode(anode),
        .decimal_point(decimal_point)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            bcd_in = 16'h0000;
            decimal_points = 4'h0;
            #20;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case 001: BCD 0, DP ON");
            bcd_in = 16'h4320;
            decimal_points = 4'b0001;
            #20;

            #1;


            check_outputs(7'b1000000, 4'b1110, 1'b0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case 002: BCD 1, DP OFF");
            bcd_in = 16'h4321;
            decimal_points = 4'b0000;
            #20;

            #1;


            check_outputs(7'b1111001, 4'b1110, 1'b1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case 003: BCD 8, DP ON");
            bcd_in = 16'h9878;
            decimal_points = 4'b0001;
            #20;

            #1;


            check_outputs(7'b0000000, 4'b1110, 1'b0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case 004: BCD 4, DP OFF");
            bcd_in = 16'h0004;
            decimal_points = 4'b0000;
            #20;

            #1;


            check_outputs(7'b0011001, 4'b1110, 1'b1);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case 005: BCD 7, DP ON");
            bcd_in = 16'h0007;
            decimal_points = 4'b0001;
            #20;

            #1;


            check_outputs(7'b1111000, 4'b1110, 1'b0);
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
        input [6:0] expected_a_to_g;
        input [3:0] expected_anode;
        input expected_decimal_point;
        begin
            if (expected_a_to_g === (expected_a_to_g ^ a_to_g ^ expected_a_to_g) &&
                expected_anode === (expected_anode ^ anode ^ expected_anode) &&
                expected_decimal_point === (expected_decimal_point ^ decimal_point ^ expected_decimal_point)) begin
                $display("PASS");
                $display("  Outputs: a_to_g=%h, anode=%h, decimal_point=%b",
                         a_to_g, anode, decimal_point);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: a_to_g=%h, anode=%h, decimal_point=%b",
                         expected_a_to_g, expected_anode, expected_decimal_point);
                $display("  Got:      a_to_g=%h, anode=%h, decimal_point=%b",
                         a_to_g, anode, decimal_point);
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
        $dumpvars(0,bcd_in, clk, decimal_points, a_to_g, anode, decimal_point);
    end

endmodule
