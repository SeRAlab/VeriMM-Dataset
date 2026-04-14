`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] a_in;
    reg [31:0] b_in;
    reg clk;
    reg enable;
    wire [31:0] a_out;
    wire [31:0] b_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a_in(a_in),
        .b_in(b_in),
        .clk(clk),
        .enable(enable),
        .a_out(a_out),
        .b_out(b_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            a_in = 0;
            b_in = 0;
            enable = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase %0d: Positive signed integers", test_num);
            a_in = 32'd10;
            b_in = 32'd25;
            enable = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'd10, 32'd25 + (weight * 32'd10));
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase %0d: Negative signed integers", test_num);
            a_in = -32'd15;
            b_in = 32'd100;
            enable = 1;
            @(posedge clk);
            #2;

            #1;


            check_outputs(-32'd15, 32'd100 + (weight * -32'd15));
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase %0d: Enable signal low (No update)", test_num);

            a_in = 32'd50;
            b_in = 32'd50;
            enable = 1;
            @(posedge clk);
            #2;


            a_in = 32'd999;
            b_in = 32'd999;
            enable = 0;
            @(posedge clk);
            #2;

            #1;


            check_outputs(32'd50, 32'd50 + (weight * 32'd50));
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase %0d: Zero inputs", test_num);
            a_in = 32'd0;
            b_in = 32'd0;
            enable = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'd0, 32'd0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Testcase %0d: Large signed values", test_num);
            a_in = 32'h0000_FFFF;
            b_in = 32'h0000_0001;
            enable = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'h0000_FFFF, 32'h0000_FFFF + 32'h0000_0001);
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
        input [31:0] expected_a_out;
        input [31:0] expected_b_out;
        begin
            if (expected_a_out === (expected_a_out ^ a_out ^ expected_a_out) &&
                expected_b_out === (expected_b_out ^ b_out ^ expected_b_out)) begin
                $display("PASS");
                $display("  Outputs: a_out=%h, b_out=%h",
                         a_out, b_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: a_out=%h, b_out=%h",
                         expected_a_out, expected_b_out);
                $display("  Got:      a_out=%h, b_out=%h",
                         a_out, b_out);
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
        $dumpvars(0,a_in, b_in, clk, enable, a_out, b_out);
    end

endmodule
