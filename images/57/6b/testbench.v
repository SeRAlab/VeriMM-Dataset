`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] dest_addr;
    reg [9:0] length;
    reg rst;
    reg [31:0] src_addr;
    reg start;
    wire busy;
    wire done;
    wire error;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .dest_addr(dest_addr),
        .length(length),
        .rst(rst),
        .src_addr(src_addr),
        .start(start),
        .busy(busy),
        .done(done),
        .error(error)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            start = 0;
            src_addr = 0;
            dest_addr = 0;
            length = 0;
            repeat (2) @(posedge clk);
            #1 rst = 0;
            repeat (2) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase 001: 1 word transfer");
            reset_dut();
            src_addr = 32'h0000_1000;
            dest_addr = 32'h0000_2000;
            length = 10'd1;

            @(posedge clk);
            #1 start = 1;
            @(posedge clk);
            #1 start = 0;


            wait(done == 1'b1);
            @(posedge clk);
            #1 #1;
 check_outputs(1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase 002: 16 words transfer");
            reset_dut();
            src_addr = 32'hAAAA_0000;
            dest_addr = 32'hBBBB_0000;
            length = 10'd16;

            @(posedge clk);
            #1 start = 1;
            @(posedge clk);
            #1 start = 0;


            repeat(5) @(posedge clk);
            if (busy !== 1'b1) $display("Warning: Busy signal not asserted during transfer.");

            wait(done == 1'b1);
            @(posedge clk);
            #1 #1;
 check_outputs(1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase 003: 512 words transfer");
            reset_dut();
            src_addr = 32'h1234_5678;
            dest_addr = 32'h8765_4321;
            length = 10'd512;

            @(posedge clk);
            #1 start = 1;
            @(posedge clk);
            #1 start = 0;

            wait(done == 1'b1);
            @(posedge clk);
            #1 #1;
 check_outputs(1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase 004: Maximum length transfer (1023 words)");
            reset_dut();
            src_addr = 32'h0000_0000;
            dest_addr = 32'hFFFF_FFFF;
            length = 10'd1023;

            @(posedge clk);
            #1 start = 1;
            @(posedge clk);
            #1 start = 0;

            wait(done == 1'b1);
            @(posedge clk);
            #1 #1;
 check_outputs(1'b0, 1'b1, 1'b0);
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
        input expected_busy;
        input expected_done;
        input expected_error;
        begin
            if (expected_busy === (expected_busy ^ busy ^ expected_busy) &&
                expected_done === (expected_done ^ done ^ expected_done) &&
                expected_error === (expected_error ^ error ^ expected_error)) begin
                $display("PASS");
                $display("  Outputs: busy=%b, done=%b, error=%b",
                         busy, done, error);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: busy=%b, done=%b, error=%b",
                         expected_busy, expected_done, expected_error);
                $display("  Got:      busy=%b, done=%b, error=%b",
                         busy, done, error);
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
        $dumpvars(0,clk, dest_addr, length, rst, src_addr, start, busy, done, error);
    end

endmodule
