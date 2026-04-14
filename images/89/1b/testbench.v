`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] input_binary;
    reg reset;
    wire [6:0] output_segments;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .input_binary(input_binary),
        .reset(reset),
        .output_segments(output_segments)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(posedge clk);
            reset = 1;
            input_binary = 4'd0;
            @(posedge clk);
            #1;
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Running Testcase %03d: Reset initialization", test_num);
            reset_dut();

            #1;


            check_outputs(SEG_1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Running Testcase %03d: Input Binary 0", test_num);
            reset_dut();
            input_binary = 4'd0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(SEG_0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Running Testcase %03d: Input Binary 3", test_num);
            reset_dut();
            input_binary = 4'd3;
            @(posedge clk);
            #1;
            #1;

            check_outputs(SEG_3);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Running Testcase %03d: Input Binary 8", test_num);
            reset_dut();
            input_binary = 4'd8;
            @(posedge clk);
            #1;
            #1;

            check_outputs(SEG_8);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Running Testcase %03d: Input Binary 9", test_num);
            reset_dut();
            input_binary = 4'd9;
            @(posedge clk);
            #1;
            #1;

            check_outputs(SEG_9);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Running Testcase %03d: Out-of-range Input 10", test_num);
            reset_dut();
            input_binary = 4'd10;
            @(posedge clk);
            #1;

            #1;


            check_outputs(SEG_OFF);
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
        input [6:0] expected_output_segments;
        begin
            if (expected_output_segments === (expected_output_segments ^ output_segments ^ expected_output_segments)) begin
                $display("PASS");
                $display("  Outputs: output_segments=%h",
                         output_segments);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: output_segments=%h",
                         expected_output_segments);
                $display("  Got:      output_segments=%h",
                         output_segments);
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
        $dumpvars(0,clk, input_binary, reset, output_segments);
    end

endmodule
