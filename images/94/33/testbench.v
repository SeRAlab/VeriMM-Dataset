`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    wire [5:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin

            force dut.out = 6'h01;
            @(posedge clk);
            #1;
            release dut.out;
            test_num = test_num + 1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            $display("Testcase %0d: Checking initial state after reset", test_num);
            #1;

            check_outputs(6'h01);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            $display("Testcase %0d: Checking state after 1 clock cycle", test_num);
            @(posedge clk);
            #1;

            #1;


            check_outputs(6'h02);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            $display("Testcase %0d: Checking state after 5 clock cycles", test_num);
            repeat(5) @(posedge clk);
            #1;

            #1;


            check_outputs(6'h21);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            $display("Testcase %0d: Checking state after 10 clock cycles", test_num);
            repeat(10) @(posedge clk);
            #1;

            #1;


            check_outputs(6'h31);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            $display("Testcase %0d: Checking state after 63 clock cycles (full rotation)", test_num);
            repeat(63) @(posedge clk);
            #1;

            #1;


            check_outputs(6'h01);
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
        input [5:0] expected_out;
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
        $dumpvars(0,clk, out);
    end

endmodule
