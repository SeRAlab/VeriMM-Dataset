`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [9:0] datain;
    reg reset;
    wire [9:0] dataout;
    wire validout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .datain(datain),
        .reset(reset),
        .dataout(dataout),
        .validout(validout)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        datain = 10'd0;
        @(posedge clk);
        #2;
        reset = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case 001: Reset Behavior");
        reset_dut();


        #1;



        check_outputs(10'd0, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case 002: datain = 0 (Below Threshold)");
        reset_dut();
        @(negedge clk);
        datain = 10'd0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(10'd0, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case 003: datain = 99 (Below Threshold)");
        reset_dut();
        @(negedge clk);
        datain = 10'd99;
        @(posedge clk);
        #1;
        #1;

        check_outputs(10'd0, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case 004: datain = 100 (Threshold Boundary)");
        reset_dut();
        @(negedge clk);
        datain = 10'd100;
        @(posedge clk);
        #1;
        #1;

        check_outputs(10'd100, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case 005: datain = 101 (Above Threshold)");
        reset_dut();
        @(negedge clk);
        datain = 10'd101;
        @(posedge clk);
        #1;
        #1;

        check_outputs(10'd101, 1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case 006: datain = 512 (High Value)");
        reset_dut();
        @(negedge clk);
        datain = 10'd512;
        @(posedge clk);
        #1;
        #1;

        check_outputs(10'd512, 1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case 007: datain = 1023 (Max Value)");
        reset_dut();
        @(negedge clk);
        datain = 10'd1023;
        @(posedge clk);
        #1;
        #1;

        check_outputs(10'd1023, 1'b1);
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
        input [9:0] expected_dataout;
        input expected_validout;
        begin
            if (expected_dataout === (expected_dataout ^ dataout ^ expected_dataout) &&
                expected_validout === (expected_validout ^ validout ^ expected_validout)) begin
                $display("PASS");
                $display("  Outputs: dataout=%h, validout=%b",
                         dataout, validout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dataout=%h, validout=%b",
                         expected_dataout, expected_validout);
                $display("  Got:      dataout=%h, validout=%b",
                         dataout, validout);
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
        $dumpvars(0,clk, datain, reset, dataout, validout);
    end

endmodule
