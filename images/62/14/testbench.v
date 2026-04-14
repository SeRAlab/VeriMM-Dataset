`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clear;
    reg clk;
    reg [15:0] data;
    reg enable;
    reg load;
    wire [15:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clear(clear),
        .clk(clk),
        .data(data),
        .enable(enable),
        .load(load),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clear = 0;
        forever #5 clear = ~clear;
    end

        task reset_dut;

        begin
            clear = 1;
            load = 0;
            enable = 0;
            data = 0;
            #12;
            clear = 0;
            #5;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Asynchronous Clear");
            reset_dut();

            #1;


            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Synchronous Load");
            reset_dut();
            @(posedge clk);
            data = 16'hABCD;
            load = 1;
            enable = 0;
            @(posedge clk);
            #1;
            load = 0;
            #1;

            check_outputs(16'hABCD);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Enable (Hold) functionality");
            reset_dut();

            @(posedge clk);
            data = 16'h1234;
            load = 1;
            @(posedge clk);
            #1;

            load = 0;
            enable = 1;
            data = 16'hFFFF;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'h1234);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Load priority over Enable");
            reset_dut();
            @(posedge clk);
            data = 16'h55AA;
            load = 1;
            enable = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'h55AA);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Asynchronous Clear Priority");
            reset_dut();

            @(posedge clk);
            data = 16'h7777;
            load = 1;
            @(posedge clk);
            #1;

            #3;
            clear = 1;
            #1;

            #1;


            check_outputs(16'h0000);
            clear = 0;
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Consecutive loads");
            reset_dut();
            @(posedge clk);
            data = 16'h1111;
            load = 1;
            @(posedge clk);
            #1;
            data = 16'h2222;
            @(posedge clk);
            #1;
            data = 16'h3333;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h3333);
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
        input [15:0] expected_q;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: q=%h",
                         q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%h",
                         expected_q);
                $display("  Got:      q=%h",
                         q);
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
        $dumpvars(0,clear, clk, data, enable, load, q);
    end

endmodule
