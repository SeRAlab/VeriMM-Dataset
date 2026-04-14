`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [1:0] connectStateIn;
    reg resumeDetectedIn;
    reg rst;
    wire [1:0] connectStateOut;
    wire connectionEventOut;
    wire resumeIntOut;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .connectStateIn(connectStateIn),
        .resumeDetectedIn(resumeDetectedIn),
        .rst(rst),
        .connectStateOut(connectStateOut),
        .connectionEventOut(connectionEventOut),
        .resumeIntOut(resumeIntOut)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            connectStateIn = 2'b00;
            resumeDetectedIn = 1'b0;
            repeat(2) @(posedge clk);
            #1 rst = 0;
            repeat(1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            #1;


            check_outputs(2'b00, 0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            @(negedge clk);
            connectStateIn = 2'b01;
            @(posedge clk);
            #2;
            #1;

            check_outputs(2'b01, 1, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            @(negedge clk);
            connectStateIn = 2'b11;
            @(posedge clk);
            #2;
            #1;

            check_outputs(2'b11, 1, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            @(negedge clk);
            resumeDetectedIn = 1'b1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(2'b00, 0, 1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            @(negedge clk);
            connectStateIn = 2'b10;
            resumeDetectedIn = 1'b1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(2'b10, 1, 1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            @(negedge clk);
            connectStateIn = 2'b01;
            @(posedge clk);
            @(negedge clk);
            @(posedge clk);
            #2;

            #1;


            check_outputs(2'b01, 0, 0);
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
        input [1:0] expected_connectStateOut;
        input expected_connectionEventOut;
        input expected_resumeIntOut;
        begin
            if (expected_connectStateOut === (expected_connectStateOut ^ connectStateOut ^ expected_connectStateOut) &&
                expected_connectionEventOut === (expected_connectionEventOut ^ connectionEventOut ^ expected_connectionEventOut) &&
                expected_resumeIntOut === (expected_resumeIntOut ^ resumeIntOut ^ expected_resumeIntOut)) begin
                $display("PASS");
                $display("  Outputs: connectStateOut=%h, connectionEventOut=%b, resumeIntOut=%b",
                         connectStateOut, connectionEventOut, resumeIntOut);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: connectStateOut=%h, connectionEventOut=%b, resumeIntOut=%b",
                         expected_connectStateOut, expected_connectionEventOut, expected_resumeIntOut);
                $display("  Got:      connectStateOut=%h, connectionEventOut=%b, resumeIntOut=%b",
                         connectStateOut, connectionEventOut, resumeIntOut);
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
        $dumpvars(0,clk, connectStateIn, resumeDetectedIn, rst, connectStateOut, connectionEventOut, resumeIntOut);
    end

endmodule
