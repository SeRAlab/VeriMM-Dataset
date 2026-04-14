`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] a;
    reg [7:0] b;
    reg clk;
    reg reset;
    wire [15:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .clk(clk),
        .reset(reset),
        .result(result)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        a = 8'd0;
        b = 8'd0;
        @(posedge clk);
        #1;
        reset = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: 0 x 0", test_num);
        reset_dut();
        a = 8'd0; b = 8'd0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(16'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: 255 x 0", test_num);
        reset_dut();
        a = 8'd255; b = 8'd0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(16'd0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: 0 x 123", test_num);
        reset_dut();
        a = 8'd0; b = 8'd123;
        @(posedge clk);
        #1;
        #1;

        check_outputs(16'd0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: 1 x 1", test_num);
        reset_dut();
        a = 8'd1; b = 8'd1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(16'd1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: 255 x 1", test_num);
        reset_dut();
        a = 8'd255; b = 8'd1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(16'd255);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: 12 x 12", test_num);
        reset_dut();
        a = 8'd12; b = 8'd12;
        @(posedge clk);
        #1;
        #1;

        check_outputs(16'd144);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: 128 x 2", test_num);
        reset_dut();
        a = 8'd128; b = 8'd2;
        @(posedge clk);
        #1;
        #1;

        check_outputs(16'd256);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: 85 x 2", test_num);
        reset_dut();
        a = 8'h55; b = 8'd2;
        @(posedge clk);
        #1;
        #1;

        check_outputs(16'd170);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test %0d: 127 x 127", test_num);
        reset_dut();
        a = 8'd127; b = 8'd127;
        @(posedge clk);
        #1;
        #1;

        check_outputs(16'd16129);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test %0d: 255 x 255", test_num);
        reset_dut();
        a = 8'd255; b = 8'd255;
        @(posedge clk);
        #1;
        #1;

        check_outputs(16'd65025);
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
        testcase008();
        testcase009();
        testcase010();
        
        
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
        input [15:0] expected_result;
        begin
            if (expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: result=%h",
                         result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: result=%h",
                         expected_result);
                $display("  Got:      result=%h",
                         result);
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
        $dumpvars(0,a, b, clk, reset, result);
    end

endmodule
