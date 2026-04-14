`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] max_value;
    reg reset;
    reg start;
    wire [7:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .max_value(max_value),
        .reset(reset),
        .start(start),
        .count(count)
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
            start = 0;
            max_value = 8'h00;
            @(posedge clk);
            #1 reset = 0;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Reset Check");
            reset_dut();
            @(posedge clk);
            #1 #1;
 check_outputs(8'h00);
        end
        endtask

    task testcase002;

        integer i;
        begin
            $display("Testcase 002: Basic Counting (up to 10)");
            reset_dut();
            max_value = 8'd20;
            start = 1;
            for (i = 0; i < 10; i = i + 1) begin
                @(posedge clk);
            end
            #1 #1;
 check_outputs(8'd10);
        end
        endtask

    task testcase003;

        integer i;
        begin
            $display("Testcase 003: Reach max_value and stay at limit");
            reset_dut();
            max_value = 8'd5;
            start = 1;

            for (i = 0; i < 5; i = i + 1) begin
                @(posedge clk);
            end
            #1 #1;
 check_outputs(8'd5);
        end
        endtask

    task testcase004;

        integer i;
        begin
            $display("Testcase 004: Wrap around to 0 after max_value");
            reset_dut();
            max_value = 8'd5;
            start = 1;

            for (i = 0; i < 6; i = i + 1) begin
                @(posedge clk);
            end
            #1 #1;
 check_outputs(8'd0);
        end
        endtask

    task testcase005;

        integer i;
        begin
            $display("Testcase 005: Start signal control (pause count)");
            reset_dut();
            max_value = 8'd50;
            start = 1;
            for (i = 0; i < 5; i = i + 1) @(posedge clk);
            start = 0;
            for (i = 0; i < 5; i = i + 1) @(posedge clk);
            #1 #1;
 check_outputs(8'd5);
        end
        endtask

    task testcase006;

        integer i;
        begin
            $display("Testcase 006: Reset during active count");
            reset_dut();
            max_value = 8'd100;
            start = 1;
            for (i = 0; i < 20; i = i + 1) @(posedge clk);
            reset = 1;
            @(posedge clk);
            reset = 0;
            #1 #1;
 check_outputs(8'd0);
        end
        endtask

    task testcase007;

        integer i;
        begin
            $display("Testcase 007: Count to 255");
            reset_dut();
            max_value = 8'hFF;
            start = 1;
            for (i = 0; i < 255; i = i + 1) begin
                @(posedge clk);
            end
            #1 #1;
 check_outputs(8'hFF);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: Max value of 1");
            reset_dut();
            max_value = 8'h01;
            start = 1;
            @(posedge clk);
            @(posedge clk);
            #1 #1;
 check_outputs(8'h00);
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
        input [7:0] expected_count;
        begin
            if (expected_count === (expected_count ^ count ^ expected_count)) begin
                $display("PASS");
                $display("  Outputs: count=%h",
                         count);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count=%h",
                         expected_count);
                $display("  Got:      count=%h",
                         count);
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
        $dumpvars(0,clk, max_value, reset, start, count);
    end

endmodule
