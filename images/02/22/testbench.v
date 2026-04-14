`timescale 1ns/1ps

module DWT_Haar_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg [15:0] signal_in;
    wire [15:0] approx_out;
    wire [15:0] detail_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    DWT_Haar dut (
        .clk(clk),
        .rst(rst),
        .signal_in(signal_in),
        .approx_out(approx_out),
        .detail_out(detail_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        signal_in = 0;
        #20;
        rst = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Positive Pair (100, 60)", test_num);
        reset_dut();
        signal_in <= 16'd100;
        @(posedge clk);
        signal_in <= 16'd60;
        @(posedge clk);
        #2;
        #1;

        check_outputs(16'd80, 16'd20);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Negative Detail (40, 100)", test_num);
        reset_dut();
        signal_in <= 16'd40;
        @(posedge clk);
        signal_in <= 16'd100;
        @(posedge clk);
        #2;
        #1;

        check_outputs(16'd70, 16'hFFE2);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Identical Inputs (500, 500)", test_num);
        reset_dut();
        signal_in <= 16'd500;
        @(posedge clk);
        signal_in <= 16'd500;
        @(posedge clk);
        #2;
        #1;

        check_outputs(16'd500, 16'd0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Zero Inputs", test_num);
        reset_dut();
        signal_in <= 16'd0;
        @(posedge clk);
        signal_in <= 16'd0;
        @(posedge clk);
        #2;
        #1;

        check_outputs(16'd0, 16'd0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Large Values with Truncation (30001, 10000)", test_num);
        reset_dut();
        signal_in <= 16'd30001;
        @(posedge clk);
        signal_in <= 16'd10000;
        @(posedge clk);
        #2;
        #1;

        check_outputs(16'd20000, 16'd10000);
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
        input [15:0] expected_approx_out;
        input [15:0] expected_detail_out;
        begin
            if (expected_approx_out === (expected_approx_out ^ approx_out ^ expected_approx_out) &&
                expected_detail_out === (expected_detail_out ^ detail_out ^ expected_detail_out)) begin
                $display("PASS");
                $display("  Outputs: approx_out=%h, detail_out=%h",
                         approx_out, detail_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: approx_out=%h, detail_out=%h",
                         expected_approx_out, expected_detail_out);
                $display("  Got:      approx_out=%h, detail_out=%h",
                         approx_out, detail_out);
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
        $dumpvars(0,clk, rst, signal_in, approx_out, detail_out);
    end

endmodule
