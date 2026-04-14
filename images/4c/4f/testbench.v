`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg load;
    reg [15:0] parallel_load;
    reg reset;
    reg shift_left;
    reg shift_right;
    wire [15:0] q;
    wire serial_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .load(load),
        .parallel_load(parallel_load),
        .reset(reset),
        .shift_left(shift_left),
        .shift_right(shift_right),
        .q(q),
        .serial_out(serial_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        load = 0;
        shift_left = 0;
        shift_right = 0;
        parallel_load = 0;
        #15;
        reset = 0;
        #10;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        reset_dut();
        #1;

        check_outputs(16'h0000, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        reset_dut();
        @(posedge clk);
        parallel_load = 16'hA5A5;
        load = 1;
        @(posedge clk);
        #1;
        load = 0;
        #1;

        check_outputs(16'hA5A5, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        reset_dut();
        @(posedge clk);
        parallel_load = 16'h5A5A;
        load = 1;
        @(posedge clk);
        #1;
        load = 0;
        #1;

        check_outputs(16'h5A5A, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        reset_dut();
        @(posedge clk);
        parallel_load = 16'h0001;
        load = 1;
        @(posedge clk);
        load = 0;
        shift_left = 1;
        @(posedge clk);
        #1;
        shift_left = 0;
        #1;

        check_outputs(16'h0002, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        reset_dut();
        @(posedge clk);
        parallel_load = 16'h4000;
        load = 1;
        @(posedge clk);
        load = 0;
        shift_left = 1;
        @(posedge clk);
        #1;
        shift_left = 0;
        #1;

        check_outputs(16'h8000, 1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        reset_dut();
        @(posedge clk);
        parallel_load = 16'h0002;
        load = 1;
        @(posedge clk);
        load = 0;
        shift_right = 1;
        @(posedge clk);
        #1;
        shift_right = 0;
        #1;

        check_outputs(16'h0001, 1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        reset_dut();
        @(posedge clk);
        parallel_load = 16'h0004;
        load = 1;
        @(posedge clk);
        load = 0;
        shift_right = 1;
        @(posedge clk);
        #1;
        shift_right = 0;
        #1;

        check_outputs(16'h0002, 1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        reset_dut();
        @(posedge clk);
        parallel_load = 16'hFFFF;
        load = 1;
        shift_left = 1;
        shift_right = 1;
        @(posedge clk);
        #1;
        load = 0;
        shift_left = 0;
        shift_right = 0;
        #1;

        check_outputs(16'hFFFF, 1'b1);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        reset_dut();
        @(posedge clk);
        parallel_load = 16'h000F;
        load = 1;
        @(posedge clk);
        load = 0;
        shift_left = 1;
        repeat(4) @(posedge clk);
        #1;
        shift_left = 0;
        #1;

        check_outputs(16'h00F0, 1'b0);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        reset_dut();
        @(posedge clk);
        parallel_load = 16'h0001;
        load = 1;
        @(posedge clk);
        load = 0;
        shift_left = 1;
        shift_right = 1;
        @(posedge clk);
        #1;
        shift_left = 0;
        shift_right = 0;

        #1;


        check_outputs(16'h0002, 1'b0);
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
        input [15:0] expected_q;
        input expected_serial_out;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q) &&
                expected_serial_out === (expected_serial_out ^ serial_out ^ expected_serial_out)) begin
                $display("PASS");
                $display("  Outputs: q=%h, serial_out=%b",
                         q, serial_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%h, serial_out=%b",
                         expected_q, expected_serial_out);
                $display("  Got:      q=%h, serial_out=%b",
                         q, serial_out);
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
        $dumpvars(0,clk, load, parallel_load, reset, shift_left, shift_right, q, serial_out);
    end

endmodule
