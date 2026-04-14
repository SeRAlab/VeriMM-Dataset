`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] in1;
    reg [15:0] in2;
    reg rst;
    wire [15:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .in1(in1),
        .in2(in2),
        .rst(rst),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(posedge clk);
            rst = 1;
            in1 = 0;
            in2 = 0;
            @(posedge clk);
            rst = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset Behavior", test_num);
            @(posedge clk);
            rst = 1;
            in1 = 16'hFFFF;
            in2 = 16'hFFFF;
            @(posedge clk);

            #1;


            check_outputs(16'h0000);
            rst = 0;
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All Zeros (0 ^ 0)", test_num);
            reset_dut();
            in1 = 16'h0000;
            in2 = 16'h0000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All Ones (FFFF ^ FFFF)", test_num);
            reset_dut();
            in1 = 16'hFFFF;
            in2 = 16'hFFFF;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Alternating Patterns (AAAA ^ 5555)", test_num);
            reset_dut();
            in1 = 16'hAAAA;
            in2 = 16'h5555;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: High Byte vs Low Byte (FF00 ^ 00FF)", test_num);
            reset_dut();
            in1 = 16'hFF00;
            in2 = 16'h00FF;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Arbitrary Pattern (1234 ^ ABCD)", test_num);
            reset_dut();
            in1 = 16'h1234;
            in2 = 16'hABCD;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h1234 ^ 16'hABCD);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Arbitrary Pattern (F0F0 ^ 1234)", test_num);
            reset_dut();
            in1 = 16'hF0F0;
            in2 = 16'h1234;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'hF0F0 ^ 16'h1234);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Single Bit (0001 ^ 8000)", test_num);
            reset_dut();
            in1 = 16'h0001;
            in2 = 16'h8000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h8001);
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
        $dumpvars(0,clk, in1, in2, rst, out);
    end

endmodule
