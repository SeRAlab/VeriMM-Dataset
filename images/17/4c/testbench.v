`timescale 1ns/1ps

module cnn_conv_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] feature_map;
    reg [3:0] kernel;
    reg rst;
    wire [8:0] output_map;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    cnn_conv dut (
        .clk(clk),
        .feature_map(feature_map),
        .kernel(kernel),
        .rst(rst),
        .output_map(output_map)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            feature_map = 16'h0000;
            kernel = 4'h0;
            repeat(2) @(posedge clk);
            #1 rst = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %03d: All Zeros", test_num);
            reset_dut();
            feature_map = 16'h0000;
            kernel = 4'h0;
            repeat(2) @(posedge clk);
            #1 #1;
 check_outputs(9'h000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %03d: Single-bit Kernel (Identity Shift)", test_num);
            reset_dut();
            feature_map = 16'hF0F0;
            kernel = 4'h8;
            repeat(2) @(posedge clk);


            #1 #1;
 check_outputs(9'h1C7);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %03d: Full Map, Single Kernel Bit", test_num);
            reset_dut();
            feature_map = 16'hFFFF;
            kernel = 4'h1;
            repeat(2) @(posedge clk);
            #1 #1;
 check_outputs(9'h1FF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %03d: All Ones (XOR Reduction)", test_num);
            reset_dut();
            feature_map = 16'hFFFF;
            kernel = 4'hF;
            repeat(2) @(posedge clk);
            #1 #1;
 check_outputs(9'h000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %03d: Checkerboard Pattern", test_num);
            reset_dut();
            feature_map = 16'hAAAA;
            kernel = 4'hF;
            repeat(2) @(posedge clk);


            #1 #1;
 check_outputs(9'h000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("cnn_conv Testbench");
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
        input [8:0] expected_output_map;
        begin
            if (expected_output_map === (expected_output_map ^ output_map ^ expected_output_map)) begin
                $display("PASS");
                $display("  Outputs: output_map=%h",
                         output_map);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: output_map=%h",
                         expected_output_map);
                $display("  Got:      output_map=%h",
                         output_map);
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
        $dumpvars(0,clk, feature_map, kernel, rst, output_map);
    end

endmodule
