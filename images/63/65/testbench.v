`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [1:0] dataIn0;
    reg [1:0] dataIn1;
    reg reset;
    reg selector;
    wire [1:0] dataOut;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .dataIn0(dataIn0),
        .dataIn1(dataIn1),
        .reset(reset),
        .selector(selector),
        .dataOut(dataOut)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            dataIn0 = 2'b00;
            dataIn1 = 2'b00;
            selector = 0;
            @(posedge clk);
            #1 reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase 001: Verifying Reset functionality...");
            reset_dut();

            #1;


            check_outputs(2'b00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase 002: Selecting dataIn0...");
            reset_dut();
            dataIn0 = 2'b10;
            dataIn1 = 2'b01;
            selector = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase 003: Selecting dataIn1...");
            reset_dut();
            dataIn0 = 2'b10;
            dataIn1 = 2'b11;
            selector = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'b11);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase 004: Verifying synchronous capture (output shouldn't change until clk)...");
            reset_dut();
            dataIn0 = 2'b01;
            selector = 0;
            @(posedge clk);
            #1;
            dataIn0 = 2'b11;
            #2;

            #1;


            check_outputs(2'b01);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase 005: Verifying Reset priority over selector...");
            reset_dut();
            dataIn1 = 2'b11;
            selector = 1;
            @(posedge clk);
            #1 reset = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'b00);
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
        input [1:0] expected_dataOut;
        begin
            if (expected_dataOut === (expected_dataOut ^ dataOut ^ expected_dataOut)) begin
                $display("PASS");
                $display("  Outputs: dataOut=%h",
                         dataOut);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dataOut=%h",
                         expected_dataOut);
                $display("  Got:      dataOut=%h",
                         dataOut);
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
        $dumpvars(0,clk, dataIn0, dataIn1, reset, selector, dataOut);
    end

endmodule
