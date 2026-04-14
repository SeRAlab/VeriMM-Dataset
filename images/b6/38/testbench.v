`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk_in;
    wire clk_out_1;
    wire clk_out_2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk_in(clk_in),
        .clk_out_1(clk_out_1),
        .clk_out_2(clk_out_2)
    );

    // Clock generation (10ns period)
    initial begin
        clk_in = 0;
        forever #5 clk_in = ~clk_in;
    end

        task reset_dut;

        begin

            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            @(posedge clk_in);
            #1;
            $display("Testcase 001: Checking state after 1st rising edge (No toggle expected)");

            #1;


            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            repeat(2) @(posedge clk_in);
            #1;
            $display("Testcase 002: Checking state after 2nd rising edge (First toggle expected)");
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            repeat(3) @(posedge clk_in);
            #1;
            $display("Testcase 003: Checking state after 3rd rising edge (State should hold)");
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            repeat(4) @(posedge clk_in);
            #1;
            $display("Testcase 004: Checking state after 4th rising edge (Second toggle expected)");
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            repeat(10) @(posedge clk_in);
            #1;
            $display("Testcase 005: Checking complementarity after 10 cycles");

            if (clk_out_1 !== clk_out_2) begin
                pass_count = pass_count + 1;
                $display("PASS: clk_out_1=%b, clk_out_2=%b", clk_out_1, clk_out_2);
            end else begin
                fail_count = fail_count + 1;
                $display("FAIL: Signals are not complementary! clk_out_1=%b, clk_out_2=%b", clk_out_1, clk_out_2);
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
        input expected_clk_out_1;
        input expected_clk_out_2;
        begin
            if (expected_clk_out_1 === (expected_clk_out_1 ^ clk_out_1 ^ expected_clk_out_1) &&
                expected_clk_out_2 === (expected_clk_out_2 ^ clk_out_2 ^ expected_clk_out_2)) begin
                $display("PASS");
                $display("  Outputs: clk_out_1=%b, clk_out_2=%b",
                         clk_out_1, clk_out_2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: clk_out_1=%b, clk_out_2=%b",
                         expected_clk_out_1, expected_clk_out_2);
                $display("  Got:      clk_out_1=%b, clk_out_2=%b",
                         clk_out_1, clk_out_2);
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
        $dumpvars(0,clk_in, clk_out_1, clk_out_2);
    end

endmodule
