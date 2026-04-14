`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] binary_in;
    reg clk;
    wire [3:0] bcd_out;
    wire greater_than_nine;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .binary_in(binary_in),
        .clk(clk),
        .bcd_out(bcd_out),
        .greater_than_nine(greater_than_nine)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            binary_in = 4'b0000;
            repeat(2) @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            binary_in = 4'd0;
            repeat(2) @(posedge clk);
            #1;
            $display("Testcase %0d: Input 0", test_num);
            #1;

            check_outputs(4'd0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            binary_in = 4'd5;
            repeat(2) @(posedge clk);
            #1;
            $display("Testcase %0d: Input 5", test_num);
            #1;

            check_outputs(4'd5, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            binary_in = 4'd9;
            repeat(2) @(posedge clk);
            #1;
            $display("Testcase %0d: Input 9", test_num);
            #1;

            check_outputs(4'd9, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            binary_in = 4'd10;
            repeat(2) @(posedge clk);
            #1;
            $display("Testcase %0d: Input 10", test_num);
            #1;

            check_outputs(4'd0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            binary_in = 4'd13;
            repeat(2) @(posedge clk);
            #1;
            $display("Testcase %0d: Input 13", test_num);
            #1;

            check_outputs(4'd3, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            binary_in = 4'd15;
            repeat(2) @(posedge clk);
            #1;
            $display("Testcase %0d: Input 15", test_num);
            #1;

            check_outputs(4'd5, 1'b1);
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
        input [3:0] expected_bcd_out;
        input expected_greater_than_nine;
        begin
            if (expected_bcd_out === (expected_bcd_out ^ bcd_out ^ expected_bcd_out) &&
                expected_greater_than_nine === (expected_greater_than_nine ^ greater_than_nine ^ expected_greater_than_nine)) begin
                $display("PASS");
                $display("  Outputs: bcd_out=%h, greater_than_nine=%b",
                         bcd_out, greater_than_nine);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: bcd_out=%h, greater_than_nine=%b",
                         expected_bcd_out, expected_greater_than_nine);
                $display("  Got:      bcd_out=%h, greater_than_nine=%b",
                         bcd_out, greater_than_nine);
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
        $dumpvars(0,binary_in, clk, bcd_out, greater_than_nine);
    end

endmodule
