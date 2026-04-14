`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg faster;
    reg reset;
    reg slower;
    reg write;
    reg [7:0] writedata;
    wire [3:0] delay;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .faster(faster),
        .reset(reset),
        .slower(slower),
        .write(write),
        .writedata(writedata),
        .delay(delay)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        faster = 0;
        slower = 0;
        write = 0;
        writedata = 8'h00;
        @(posedge clk);
        #1 reset = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        $display("Test Case 001: Power-on Reset");
        reset_dut();

        #1;


        check_outputs(4'd8);
    end
        endtask

    task testcase002;

    begin
        $display("Test Case 002: Write Value 12");
        reset_dut();
        write = 1;
        writedata = 8'h0C;
        @(posedge clk);
        #1 write = 0;
        @(posedge clk);
        #1;

        check_outputs(4'd12);
    end
        endtask

    task testcase003;

    begin
        $display("Test Case 003: Faster (8 to 7)");
        reset_dut();
        faster = 1;
        @(posedge clk);
        #1 faster = 0;
        @(posedge clk);
        #1;

        check_outputs(4'd7);
    end
        endtask

    task testcase004;

    begin
        $display("Test Case 004: Slower (8 to 9)");
        reset_dut();
        slower = 1;
        @(posedge clk);
        #1 slower = 0;
        @(posedge clk);
        #1;

        check_outputs(4'd9);
    end
        endtask

    task testcase005;

    begin
        $display("Test Case 005: Lower Bound (Clamp at 1)");
        reset_dut();

        write = 1;
        writedata = 8'h02;
        @(posedge clk);
        #1 write = 0;

        faster = 1;
        @(posedge clk);
        @(posedge clk);
        #1 faster = 0;
        @(posedge clk);
        #1;

        check_outputs(4'd1);
    end
        endtask

    task testcase006;

    begin
        $display("Test Case 006: Upper Bound (Clamp at 15)");
        reset_dut();

        write = 1;
        writedata = 8'h0E;
        @(posedge clk);
        #1 write = 0;

        slower = 1;
        @(posedge clk);
        @(posedge clk);
        #1 slower = 0;
        @(posedge clk);
        #1;

        check_outputs(4'd15);
    end
        endtask

    task testcase007;

    begin
        $display("Test Case 007: Multiple Adjustments (8 + 3 - 5 = 6)");
        reset_dut();

        slower = 1;
        repeat(3) @(posedge clk);
        slower = 0;

        faster = 1;
        repeat(5) @(posedge clk);
        faster = 0;
        @(posedge clk);
        #1;

        check_outputs(4'd6);
    end
        endtask

    task testcase008;

    begin
        $display("Test Case 008: Write 8-bit truncation (Write 0xF3)");
        reset_dut();
        write = 1;
        writedata = 8'hF3;
        @(posedge clk);
        #1 write = 0;
        @(posedge clk);
        #1;

        check_outputs(4'd3);
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
        input [3:0] expected_delay;
        begin
            if (expected_delay === (expected_delay ^ delay ^ expected_delay)) begin
                $display("PASS");
                $display("  Outputs: delay=%h",
                         delay);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: delay=%h",
                         expected_delay);
                $display("  Got:      delay=%h",
                         delay);
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
        $dumpvars(0,clk, faster, reset, slower, write, writedata, delay);
    end

endmodule
