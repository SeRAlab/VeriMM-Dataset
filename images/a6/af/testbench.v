`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    wire [31:0] fib_num;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .reset(reset),
        .fib_num(fib_num)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            @(posedge clk);
            #2;
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            reset_dut();

            #1;


            check_outputs(32'd0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'd1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            repeat(2) @(posedge clk);
            #2;
            #1;

            check_outputs(32'd1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            repeat(3) @(posedge clk);
            #2;
            #1;

            check_outputs(32'd2);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            repeat(5) @(posedge clk);
            #2;
            #1;

            check_outputs(32'd5);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            repeat(10) @(posedge clk);
            #2;
            #1;

            check_outputs(32'd55);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            repeat(20) @(posedge clk);
            #2;
            #1;

            check_outputs(32'd6765);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            repeat(15) @(posedge clk);
            #2;
            #1;

            check_outputs(32'd610);
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
        input [31:0] expected_fib_num;
        begin
            if (expected_fib_num === (expected_fib_num ^ fib_num ^ expected_fib_num)) begin
                $display("PASS");
                $display("  Outputs: fib_num=%h",
                         fib_num);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: fib_num=%h",
                         expected_fib_num);
                $display("  Got:      fib_num=%h",
                         fib_num);
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
        $dumpvars(0,clk, reset, fib_num);
    end

endmodule
