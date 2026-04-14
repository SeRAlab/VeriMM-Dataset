`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    reg [3:0] in;
    reg load;
    reg reset;
    wire [3:0] out;
    wire overflow;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .enable(enable),
        .in(in),
        .load(load),
        .reset(reset),
        .out(out),
        .overflow(overflow)
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
            enable = 0;
            load = 0;
            in = 4'b0;
            @(posedge clk);
            #1 reset = 0;
        end
        endtask
    task testcase001;

        begin
            $display("Running Testcase 001: Basic Reset Verification");
            test_num = 1;
            reset_dut();

            #1;


            check_outputs(4'd0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("Running Testcase 002: Basic Counting (5 steps)");
            test_num = 2;
            reset_dut();
            enable = 1;
            repeat (5) @(posedge clk);
            #1;
            #1;

            check_outputs(4'd5, 1'b0);
        end
        endtask

    task testcase003;

        begin
            $display("Running Testcase 003: Load Functionality");
            test_num = 3;
            reset_dut();
            in = 4'hA;
            load = 1;
            @(posedge clk);
            #1 load = 0;
            #1;

            check_outputs(4'hA, 1'b0);
        end
        endtask

    task testcase004;

        begin
            $display("Running Testcase 004: Overflow Detection (Counting to 15)");
            test_num = 4;
            reset_dut();
            in = 4'hE;
            load = 1;
            @(posedge clk);
            #1 load = 0;
            enable = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'hF, 1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("Running Testcase 005: Wrap Around (15 to 0)");
            test_num = 5;
            reset_dut();
            in = 4'hF;
            load = 1;
            @(posedge clk);
            #1 load = 0;
            enable = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'h0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            $display("Running Testcase 006: Enable/Disable Toggle");
            test_num = 6;
            reset_dut();
            enable = 1;
            repeat (3) @(posedge clk);
            #1 enable = 0;
            repeat (2) @(posedge clk);
            #1;
            #1;

            check_outputs(4'd3, 1'b0);
        end
        endtask

    task testcase007;

        begin
            $display("Running Testcase 007: Load Priority over Enable");
            test_num = 7;
            reset_dut();
            in = 4'h5;
            load = 1;
            enable = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'h5, 1'b0);
        end
        endtask

    task testcase008;

        begin
            $display("Running Testcase 008: Direct Load of Overflow Value");
            test_num = 8;
            reset_dut();
            in = 4'hF;
            load = 1;
            @(posedge clk);
            #1 load = 0;
            #1;

            check_outputs(4'hF, 1'b1);
        end
        endtask

    task testcase009;

        begin
            $display("Running Testcase 009: Full Range Cycle (16 pulses)");
            test_num = 9;
            reset_dut();
            enable = 1;
            repeat (16) @(posedge clk);
            #1;
            #1;

            check_outputs(4'd0, 1'b0);
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
        input [3:0] expected_out;
        input expected_overflow;
        begin
            if (expected_out === (expected_out ^ out ^ expected_out) &&
                expected_overflow === (expected_overflow ^ overflow ^ expected_overflow)) begin
                $display("PASS");
                $display("  Outputs: out=%h, overflow=%b",
                         out, overflow);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h, overflow=%b",
                         expected_out, expected_overflow);
                $display("  Got:      out=%h, overflow=%b",
                         out, overflow);
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
        $dumpvars(0,clk, enable, in, load, reset, out, overflow);
    end

endmodule
