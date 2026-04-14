`timescale 1ns/1ps

module simple_rnn_cell_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] h_in;
    reg rst;
    reg [7:0] x;
    wire [7:0] h_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    simple_rnn_cell dut (
        .clk(clk),
        .h_in(h_in),
        .rst(rst),
        .x(x),
        .h_out(h_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            x = 0;
            h_in = 0;
            @(posedge clk);
            #2 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase 001: Zero inputs");
            reset_dut();
            x = 8'd0;
            h_in = 8'd0;
            @(posedge clk);
            #1 #1;
 check_outputs(8'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase 002: Basic addition (x=10, h_in=20)");
            reset_dut();
            x = 8'd10;
            h_in = 8'd20;
            @(posedge clk);
            #1 #1;
 check_outputs(8'd30);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase 003: Overflow check (200 + 100)");
            reset_dut();
            x = 8'd200;
            h_in = 8'd100;
            @(posedge clk);
            #1 #1;
 check_outputs(8'd44);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase 004: Input stimulus with zero previous state");
            reset_dut();
            x = 8'd55;
            h_in = 8'd0;
            @(posedge clk);
            #1 #1;
 check_outputs(8'd55);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase 005: Zero input with existing hidden state");
            reset_dut();
            x = 8'd0;
            h_in = 8'd128;
            @(posedge clk);
            #1 #1;
 check_outputs(8'd128);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("simple_rnn_cell Testbench");
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
        input [7:0] expected_h_out;
        begin
            if (expected_h_out === (expected_h_out ^ h_out ^ expected_h_out)) begin
                $display("PASS");
                $display("  Outputs: h_out=%h",
                         h_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: h_out=%h",
                         expected_h_out);
                $display("  Got:      h_out=%h",
                         h_out);
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
        $dumpvars(0,clk, h_in, rst, x, h_out);
    end

endmodule
