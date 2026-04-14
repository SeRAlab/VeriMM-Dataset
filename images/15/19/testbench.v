`timescale 1ns/1ps

module DWT_Haar_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] data_in;
    reg rst;
    wire [15:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    DWT_Haar dut (
        .clk(clk),
        .data_in(data_in),
        .rst(rst),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        data_in = 16'h0;
        @(posedge clk);
        #1;
        rst = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = 1;
        data_in = 16'h0000;
        repeat(2) @(posedge clk);
        #1;
        $display("Test Case 001: All Zeros");
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = 2;
        data_in = 16'h8844;
        repeat(2) @(posedge clk);
        #1;
        $display("Test Case 002: Constant Pairs");
        #1;

        check_outputs(16'h8400);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = 3;
        data_in = 16'hA2C4;
        repeat(2) @(posedge clk);
        #1;
        $display("Test Case 003: Step Up (Positive Diffs)");
        #1;

        check_outputs(16'h6844);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = 4;
        data_in = 16'h264A;

        data_in = 16'h264A;
        repeat(2) @(posedge clk);
        #1;
        $display("Test Case 004: Step Down (Negative Diffs)");
        #1;

        check_outputs(16'h47ED);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = 5;
        data_in = 16'hE62A;
        repeat(2) @(posedge clk);
        #1;
        $display("Test Case 005: Mixed Signals");
        #1;

        check_outputs(16'hA64C);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("DWT_Haar Testbench");
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
        input [15:0] expected_data_out;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h",
                         expected_data_out);
                $display("  Got:      data_out=%h",
                         data_out);
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
        $dumpvars(0,clk, data_in, rst, data_out);
    end

endmodule
