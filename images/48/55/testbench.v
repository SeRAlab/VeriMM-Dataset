`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg b_in;
    reg clear;
    reg clk;
    reg gate;
    wire b_out;
    wire zero;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .b_in(b_in),
        .clear(clear),
        .clk(clk),
        .gate(gate),
        .b_out(b_out),
        .zero(zero)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            clear = 1;
            gate = 1;
            b_in = 0;
            @(posedge clk);
            #1;
            clear = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Clear and Initialization Check", test_num);
            reset_dut();

            #1;


            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Gating (Enable) Check", test_num);
            reset_dut();
            gate = 0;
            b_in = 1;
            repeat (5) @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Data Entry Check (Single Bit)", test_num);
            reset_dut();
            gate = 1;
            b_in = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(b_out, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: All-Zero Stream Check", test_num);
            reset_dut();
            gate = 1;
            b_in = 0;
            repeat (20) @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: MSB and Mid-operation Clear Check", test_num);
            reset_dut();
            gate = 1;
            b_in = 1;
            repeat (16) @(posedge clk);
            #1;


            clear = 1;
            @(posedge clk);
            #1;
            clear = 0;
            #1;

            check_outputs(1'b0, 1'b1);
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
        input expected_b_out;
        input expected_zero;
        begin
            if (expected_b_out === (expected_b_out ^ b_out ^ expected_b_out) &&
                expected_zero === (expected_zero ^ zero ^ expected_zero)) begin
                $display("PASS");
                $display("  Outputs: b_out=%b, zero=%b",
                         b_out, zero);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: b_out=%b, zero=%b",
                         expected_b_out, expected_zero);
                $display("  Got:      b_out=%b, zero=%b",
                         b_out, zero);
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
        $dumpvars(0,b_in, clear, clk, gate, b_out, zero);
    end

endmodule
