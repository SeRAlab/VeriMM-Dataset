`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] A;
    reg [7:0] B;
    reg clk;
    reg reset;
    wire [15:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .clk(clk),
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
            A = 0;
            B = 0;
            @(posedge clk);
            #2;
            reset = 0;
            @(posedge clk);
        end
        endtask
    task wait_cycles;

        input integer cycles;
        begin
            repeat(cycles) @(posedge clk);
            #1;
        end
        endtask

    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: 5 * 4", test_num);
            reset_dut();
            A = 8'sd5;
            B = 8'sd4;
            wait_cycles(20);
            #1;

            check_outputs(16'sd20);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: 7 * -3", test_num);
            reset_dut();
            A = 8'sd7;
            B = 8'sd-3;
            wait_cycles(20);
            #1;

            check_outputs(16'sd-21);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: -10 * 8", test_num);
            reset_dut();
            A = 8'sd-10;
            B = 8'sd8;
            wait_cycles(20);
            #1;

            check_outputs(16'sd-80);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: -12 * -11", test_num);
            reset_dut();
            A = 8'sd-12;
            B = 8'sd-11;
            wait_cycles(20);
            #1;

            check_outputs(16'sd132);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: 0 * 50", test_num);
            reset_dut();
            A = 8'sd0;
            B = 8'sd50;
            wait_cycles(20);
            #1;

            check_outputs(16'sd0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: 127 * 2", test_num);
            reset_dut();
            A = 8'sd127;
            B = 8'sd2;
            wait_cycles(20);
            #1;

            check_outputs(16'sd254);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: -128 * 2", test_num);
            reset_dut();
            A = 8'sd-128;
            B = 8'sd2;
            wait_cycles(20);
            #1;

            check_outputs(16'sd-256);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: 127 * 127", test_num);
            reset_dut();
            A = 8'sd127;
            B = 8'sd127;
            wait_cycles(20);
            #1;

            check_outputs(16'sd16129);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: -128 * -128", test_num);
            reset_dut();
            A = 8'sd-128;
            B = 8'sd-128;
            wait_cycles(20);
            #1;

            check_outputs(16'sd16384);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: -1 * -1", test_num);
            reset_dut();
            A = 8'sd-1;
            B = 8'sd-1;
            wait_cycles(20);
            #1;

            check_outputs(16'sd1);
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
        $dumpvars(0,A, B, clk, reset, out);
    end

endmodule
