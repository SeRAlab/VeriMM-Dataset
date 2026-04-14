`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] a;
    reg [15:0] b;
    reg [15:0] c;
    reg clk;
    reg reset;
    wire [15:0] sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .c(c),
        .clk(clk),
        .reset(reset),
        .sum(sum)
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
            a = 0;
            b = 0;
            c = 0;
            @(posedge clk);
            #1;
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Synchronous Reset Check", test_num);
            reset_dut();


            #1;



            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Basic Addition (Small Values)", test_num);
            reset_dut();
            a = 16'h0001;
            b = 16'h0002;
            c = 16'h0003;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0006);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Large Values with Truncation (Overflow)", test_num);
            reset_dut();
            a = 16'hFFFF;
            b = 16'h0001;
            c = 16'h0001;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'h0001);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: All Zeros", test_num);
            reset_dut();
            a = 16'h0000;
            b = 16'h0000;
            c = 16'h0000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Max Values (All Fs)", test_num);
            reset_dut();
            a = 16'hFFFF;
            b = 16'hFFFF;
            c = 16'hFFFF;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'hFFFD);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Alternating Bit Patterns", test_num);
            reset_dut();
            a = 16'hAAAA;
            b = 16'h5555;
            c = 16'h1111;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'h1110);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Mid-range Addition", test_num);
            reset_dut();
            a = 16'h1234;
            b = 16'h5678;
            c = 16'h9ABC;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'h0368);
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
        input [15:0] expected_sum;
        begin
            if (expected_sum === (expected_sum ^ sum ^ expected_sum)) begin
                $display("PASS");
                $display("  Outputs: sum=%h",
                         sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: sum=%h",
                         expected_sum);
                $display("  Got:      sum=%h",
                         sum);
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
        $dumpvars(0,a, b, c, clk, reset, sum);
    end

endmodule
