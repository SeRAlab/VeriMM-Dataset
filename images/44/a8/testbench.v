`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst_n;
    wire [63:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .rst_n(rst_n),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            @(posedge clk);
            #2;
            rst_n = 1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Reset Verification", test_num);
            rst_n = 0;
            repeat (2) @(posedge clk);
            #1;
            #1;

            check_outputs(64'h0000000000000000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: First Clock Transition", test_num);
            reset_dut();
            @(posedge clk);
            #1;

            #1;


            check_outputs(64'h0000000000000001);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Multiple Cycle Transition", test_num);
            reset_dut();
            repeat (2) @(posedge clk);
            #1;

            #1;


            check_outputs(64'h0000000000000003);
        end
        endtask

    task testcase004;

        reg [63:0] temp_val;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Sequence Stability Check", test_num);
            reset_dut();
            repeat (10) @(posedge clk);
            #1;
            temp_val = Q;
            if (temp_val != 64'h0) begin
                $display("PASS: LFSR is non-zero after 10 cycles (%h)", temp_val);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: LFSR stuck at zero");
                fail_count = fail_count + 1;
            end
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
        input [63:0] expected_Q;
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q)) begin
                $display("PASS");
                $display("  Outputs: Q=%h",
                         Q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%h",
                         expected_Q);
                $display("  Got:      Q=%h",
                         Q);
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
        $dumpvars(0,clk, rst_n, Q);
    end

endmodule
