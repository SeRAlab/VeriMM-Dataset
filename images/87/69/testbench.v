`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] d;
    reg parity_in;
    reg parity_mode;
    wire f;
    wire p;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .d(d),
        .parity_in(parity_in),
        .parity_mode(parity_mode),
        .f(f),
        .p(p)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            d = 0;
            parity_mode = 0;
            parity_in = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase 001: Even Parity, Even 1s, Match");
            reset_dut();
            d = 8'b0000_0000;
            parity_mode = 0;
            parity_in = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase 002: Even Parity, Odd 1s, Match");
            reset_dut();
            d = 8'b0000_0001;
            parity_mode = 0;
            parity_in = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1, 1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase 003: Even Parity, Odd 1s, Mismatch");
            reset_dut();
            d = 8'b0000_0001;
            parity_mode = 0;
            parity_in = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(0, 1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase 004: Odd Parity, Even 1s, Match");
            reset_dut();
            d = 8'b1010_1010;
            parity_mode = 1;
            parity_in = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1, 1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase 005: Odd Parity, Odd 1s, Match");
            reset_dut();
            d = 8'b1110_0000;
            parity_mode = 1;
            parity_in = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1, 0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase 006: Odd Parity, Even 1s, Mismatch");
            reset_dut();
            d = 8'b0000_0000;
            parity_mode = 1;
            parity_in = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(0, 1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase 007: Even Parity, All 1s, Match");
            reset_dut();
            d = 8'b1111_1111;
            parity_mode = 0;
            parity_in = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1, 0);
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
        input expected_f;
        input expected_p;
        begin
            if (expected_f === (expected_f ^ f ^ expected_f) &&
                expected_p === (expected_p ^ p ^ expected_p)) begin
                $display("PASS");
                $display("  Outputs: f=%b, p=%b",
                         f, p);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: f=%b, p=%b",
                         expected_f, expected_p);
                $display("  Got:      f=%b, p=%b",
                         f, p);
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
        $dumpvars(0,clk, d, parity_in, parity_mode, f, p);
    end

endmodule
