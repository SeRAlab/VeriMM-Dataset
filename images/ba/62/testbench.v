`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    reg [7:0] framesize;
    reg in;
    reg reset;
    wire complete;
    wire [135:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .enable(enable),
        .framesize(framesize),
        .in(in),
        .reset(reset),
        .complete(complete),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            enable = 0;
            framesize = 0;
            in = 0;
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
            $display("Running Testcase %0d: Basic 8-bit deserialization (0xA5)", test_num);
            reset_dut();
            framesize = 8'd7;
            enable = 1;


            in = 1; @(posedge clk); #1;
            in = 0; @(posedge clk); #1;
            in = 1; @(posedge clk); #1;
            in = 0; @(posedge clk); #1;
            in = 0; @(posedge clk); #1;
            in = 1; @(posedge clk); #1;
            in = 0; @(posedge clk); #1;
            in = 1; @(posedge clk); #1;

            enable = 0;
            #1;

            check_outputs(1'b1, 136'hA5);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: 4-bit with Enable suspension", test_num);
            reset_dut();
            framesize = 8'd3;

            enable = 1; in = 1; @(posedge clk); #1;
            enable = 0; in = 0; @(posedge clk); #1;
            enable = 0; in = 1; @(posedge clk); #1;
            enable = 1; in = 1; @(posedge clk); #1;
            enable = 1; in = 0; @(posedge clk); #1;
            enable = 1; in = 1; @(posedge clk); #1;

            enable = 0;
            #1;

            check_outputs(1'b1, 136'h0D);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Minimum framesize (1 bit)", test_num);
            reset_dut();
            framesize = 8'd0;
            enable = 1;
            in = 1; @(posedge clk); #1;

            enable = 0;
            #1;

            check_outputs(1'b1, 136'h01);
        end
        endtask

    task testcase004;

        reg [15:0] pattern;
        integer i;
        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: 16-bit deserialization (0x1234)", test_num);
            reset_dut();
            framesize = 8'd15;
            pattern = 16'h1234;
            enable = 1;

            for (i = 15; i >= 0; i = i - 1) begin
                in = pattern[i];
                @(posedge clk); #1;
            end

            enable = 0;
            #1;

            check_outputs(1'b1, 136'h1234);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Reset during operation", test_num);
            reset_dut();
            framesize = 8'd7;
            enable = 1;
            in = 1; @(posedge clk); #1;
            in = 1; @(posedge clk); #1;

            reset = 1; @(posedge clk); #1;
            reset = 0;

            #1;


            check_outputs(1'b0, 136'h0);
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
        input expected_complete;
        input [135:0] expected_out;
        begin
            if (expected_complete === (expected_complete ^ complete ^ expected_complete) &&
                expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: complete=%b, out=%h",
                         complete, out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: complete=%b, out=%h",
                         expected_complete, expected_out);
                $display("  Got:      complete=%b, out=%h",
                         complete, out);
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
        $dumpvars(0,clk, enable, framesize, in, reset, complete, out);
    end

endmodule
