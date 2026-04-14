`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] bin_input;
    reg clk;
    reg reset_n;
    wire [7:0] hex_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .bin_input(bin_input),
        .clk(clk),
        .reset_n(reset_n),
        .hex_output(hex_output)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset_n = 0;
            bin_input = 4'b0000;
            repeat(2) @(posedge clk);
            reset_n = 1;
            repeat(1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            bin_input = 4'h0;

            repeat(4) @(posedge clk);
            #1;
            $display("Test Case %0d: Binary Input 0", test_num);
            #1;

            check_outputs(8'h3F);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            bin_input = 4'h1;
            repeat(4) @(posedge clk);
            #1;
            $display("Test Case %0d: Binary Input 1", test_num);
            #1;

            check_outputs(8'h06);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            bin_input = 4'h5;
            repeat(4) @(posedge clk);
            #1;
            $display("Test Case %0d: Binary Input 5", test_num);
            #1;

            check_outputs(8'h6D);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            bin_input = 4'h9;
            repeat(4) @(posedge clk);
            #1;
            $display("Test Case %0d: Binary Input 9", test_num);
            #1;

            check_outputs(8'h6F);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            bin_input = 4'hA;
            repeat(4) @(posedge clk);
            #1;
            $display("Test Case %0d: Binary Input A", test_num);
            #1;

            check_outputs(8'h77);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            reset_dut();
            bin_input = 4'hF;
            repeat(4) @(posedge clk);
            #1;
            $display("Test Case %0d: Binary Input F", test_num);
            #1;

            check_outputs(8'h71);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            reset_dut();
            bin_input = 4'h4;
            repeat(4) @(posedge clk);
            #1;
            $display("Test Case %0d: Binary Input 4", test_num);
            #1;

            check_outputs(8'h66);
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
        input [7:0] expected_hex_output;
        begin
            if (expected_hex_output === (expected_hex_output ^ hex_output ^ expected_hex_output)) begin
                $display("PASS");
                $display("  Outputs: hex_output=%h",
                         hex_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: hex_output=%h",
                         expected_hex_output);
                $display("  Got:      hex_output=%h",
                         hex_output);
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
        $dumpvars(0,bin_input, clk, reset_n, hex_output);
    end

endmodule
