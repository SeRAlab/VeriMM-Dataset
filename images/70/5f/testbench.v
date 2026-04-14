`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] a;
    reg [7:0] b;
    reg clk;
    reg rst;
    wire [15:0] p;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .clk(clk),
        .rst(rst),
        .p(p)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            a = 0;
            b = 0;
            repeat(2) @(posedge clk);
            #1 rst = 0;
            repeat(1) @(posedge clk);
        end
        endtask
    task run_test;

        input signed [7:0] val_a;
        input signed [7:0] val_b;
        begin
            reset_dut();
            a = val_a;
            b = val_b;

            repeat(20) @(posedge clk);
            #1;

            check_outputs(val_a * val_b);
        end
        endtask

    task testcase001;

        begin
            run_test(8'sd5, 8'sd4);
        end
        endtask

    task testcase002;

        begin
            run_test(8'sd10, -8'sd3);
        end
        endtask

    task testcase003;

        begin
            run_test(-8'sd7, 8'sd6);
        end
        endtask

    task testcase004;

        begin
            run_test(-8'sd8, -8'sd4);
        end
        endtask

    task testcase005;

        begin
            run_test(8'sd0, 8'sd127);
        end
        endtask

    task testcase006;

        begin
            run_test(-8'sd128, 8'sd0);
        end
        endtask

    task testcase007;

        begin
            run_test(8'sd127, 8'sd127);
        end
        endtask

    task testcase008;

        begin
            run_test(-8'sd128, -8'sd128);
        end
        endtask

    task testcase009;

        begin
            run_test(8'sd1, -8'sd55);
        end
        endtask

    task testcase010;

        begin
            run_test(-8'sd128, 8'sd127);
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
        input [15:0] expected_p;
        begin
            if (expected_p === (expected_p ^ p ^ expected_p)) begin
                $display("PASS");
                $display("  Outputs: p=%h",
                         p);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: p=%h",
                         expected_p);
                $display("  Got:      p=%h",
                         p);
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
        $dumpvars(0,a, b, clk, rst, p);
    end

endmodule
