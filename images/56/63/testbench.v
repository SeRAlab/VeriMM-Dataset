`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [22:0] d;
    reg enable;
    reg load;
    reg rst_n;
    reg [22:0] seed;
    wire [22:0] m;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .d(d),
        .enable(enable),
        .load(load),
        .rst_n(rst_n),
        .seed(seed),
        .m(m)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            load = 0;
            enable = 0;
            seed = 0;
            d = 0;
            @(posedge clk);
            #1 rst_n = 1;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            seed = 23'h123456;
            d = 23'h123456;
            load = 1;
            @(posedge clk);
            #2;
            load = 0;
            $display("Testcase 001: Checking parallel load with seed 23'h123456");
            #1;

            check_outputs(23'h123456);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            seed = 23'h000001;
            d = 23'h000001;
            load = 1;
            @(posedge clk);
            #2 load = 0;
            enable = 1;
            @(posedge clk);
            #2 enable = 0;
            $display("Testcase 002: Shift 1 cycle (Feedback 1 ^ 0 = 1)");
            #1;

            check_outputs(23'h400000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            seed = 23'h040001;
            d = 23'h040001;
            load = 1;
            @(posedge clk);
            #2 load = 0;
            enable = 1;
            @(posedge clk);
            #2 enable = 0;
            $display("Testcase 003: Shift 1 cycle (Feedback 1 ^ 1 = 0)");
            #1;

            check_outputs(23'h020000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            seed = 23'h000001;
            d = 23'h000001;
            load = 1;
            @(posedge clk);
            #2 load = 0;
            enable = 1;
            repeat(2) @(posedge clk);
            #2 enable = 0;
            $display("Testcase 004: Shift 2 cycles");
            #1;

            check_outputs(23'h200000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            seed = 23'h7ABCDE;
            d = 23'h7ABCDE;
            load = 1;
            @(posedge clk);
            #2 load = 0;
            enable = 0;
            repeat(3) @(posedge clk);
            #2;
            $display("Testcase 005: Checking enable=0 (State should remain constant)");
            #1;

            check_outputs(23'h7ABCDE);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            seed = 23'h111111;
            d = 23'h111111;
            load = 1;
            enable = 1;
            @(posedge clk);
            #2;
            $display("Testcase 006: Load priority over enable");
            #1;

            check_outputs(23'h111111);
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
        input [22:0] expected_m;
        begin
            if (expected_m === (expected_m ^ m ^ expected_m)) begin
                $display("PASS");
                $display("  Outputs: m=%h",
                         m);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: m=%h",
                         expected_m);
                $display("  Got:      m=%h",
                         m);
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
        $dumpvars(0,clk, d, enable, load, rst_n, seed, m);
    end

endmodule
