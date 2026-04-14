`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] parameterIn;
    reg rst;
    wire [7:0] outputSignal;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .parameterIn(parameterIn),
        .rst(rst),
        .outputSignal(outputSignal)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        parameterIn = 4'h0;
        @(posedge clk);
        #1;
        rst = 0;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Verify Reset Behavior", test_num);
        rst = 1;
        parameterIn = 4'hF;
        @(posedge clk);
        #1;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Input 4'h0 -> Output 8'h00", test_num);
        reset_dut();
        parameterIn = 4'h0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Input 4'hF -> Output 8'h0F", test_num);
        reset_dut();
        parameterIn = 4'hF;
        @(posedge clk);
        #1;
        #1;

        check_outputs(8'h0F);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Input 4'hA -> Output 8'h0A", test_num);
        reset_dut();
        parameterIn = 4'hA;
        @(posedge clk);
        #1;
        #1;

        check_outputs(8'h0A);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Input 4'h5 -> Output 8'h05", test_num);
        reset_dut();
        parameterIn = 4'h5;
        @(posedge clk);
        #1;
        #1;

        check_outputs(8'h05);
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
        input [7:0] expected_outputSignal;
        begin
            if (expected_outputSignal === (expected_outputSignal ^ outputSignal ^ expected_outputSignal)) begin
                $display("PASS");
                $display("  Outputs: outputSignal=%h",
                         outputSignal);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: outputSignal=%h",
                         expected_outputSignal);
                $display("  Got:      outputSignal=%h",
                         outputSignal);
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
        $dumpvars(0,clk, parameterIn, rst, outputSignal);
    end

endmodule
