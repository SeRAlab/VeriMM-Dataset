`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] in;
    reg reset;
    wire [15:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .in(in),
        .reset(reset),
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
            in = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Zero Input (0x0000)", test_num);
            reset_dut();
            @(negedge clk);
            in = 16'h0000;

            @(negedge clk);
            @(negedge clk);
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Lower Byte Only (0x0001)", test_num);
            reset_dut();
            @(negedge clk);
            in = 16'h0001;
            @(negedge clk);
            @(negedge clk);
            #1;

            check_outputs(16'h0003);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Upper Byte Only (0x0100)", test_num);
            reset_dut();
            @(negedge clk);
            in = 16'h0100;
            @(negedge clk);
            @(negedge clk);
            #1;

            check_outputs(16'h0003);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Mixed Halves (0x0102)", test_num);
            reset_dut();
            @(negedge clk);
            in = 16'h0102;
            @(negedge clk);
            @(negedge clk);
            #1;

            check_outputs(16'h0009);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Medium Values (0x0A0A)", test_num);
            reset_dut();
            @(negedge clk);
            in = 16'h0A0A;
            @(negedge clk);
            @(negedge clk);
            #1;

            check_outputs(16'h003C);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Maximum Values (0xFFFF)", test_num);
            reset_dut();
            @(negedge clk);
            in = 16'hFFFF;
            @(negedge clk);
            @(negedge clk);
            #1;

            check_outputs(16'h05FA);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Random Input (0x1234)", test_num);
            reset_dut();
            @(negedge clk);
            in = 16'h1234;
            @(negedge clk);
            @(negedge clk);
            #1;

            check_outputs(16'h00D2);
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
        input [15:0] expected_out;
        begin
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
        $dumpvars(0,clk, in, reset, out);
    end

endmodule
