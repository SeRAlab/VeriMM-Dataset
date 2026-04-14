`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] BusIn;
    reg C;
    reg D;
    reg L;
    reg clk;
    wire [3:0] BusOut;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .BusIn(BusIn),
        .C(C),
        .D(D),
        .L(L),
        .clk(clk),
        .BusOut(BusOut)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            C = 1;
            L = 0;
            D = 0;
            BusIn = 4'h0;
            @(posedge clk);
            #1;
            C = 0;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            L = 1;
            BusIn = 4'hA;
            @(posedge clk);
            #1;
            L = 0;
            $display("Testcase 001: Load 4'hA");
            #1;

            check_outputs(4'hA);
        end
        endtask

    task testcase002;

        begin
            reset_dut();

            L = 1;
            BusIn = 4'h5;
            @(posedge clk);
            #1;

            L = 0;
            D = 1;
            @(posedge clk);
            #1;
            D = 0;
            $display("Testcase 002: Load 4'h5 then Decrement");
            #1;

            check_outputs(4'h4);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            D = 1;
            @(posedge clk);
            #1;
            D = 0;
            $display("Testcase 003: Decrement from 0 (Roll-over)");
            #1;

            check_outputs(4'hF);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            C = 1;
            L = 1;
            BusIn = 4'h7;
            @(posedge clk);
            #1;
            C = 0;
            L = 0;
            $display("Testcase 004: Priority - Clear over Load");
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            L = 1;
            D = 1;
            BusIn = 4'hE;
            @(posedge clk);
            #1;
            L = 0;
            D = 0;
            $display("Testcase 005: Priority - Load over Decrement");
            #1;

            check_outputs(4'hE);
        end
        endtask

    task testcase006;

        begin
            reset_dut();

            L = 1;
            BusIn = 4'h8;
            @(posedge clk);
            #1;
            L = 0;

            D = 1;
            repeat(3) @(posedge clk);
            #1;
            D = 0;
            $display("Testcase 006: Load 4'h8 and Decrement 3 times");
            #1;

            check_outputs(4'h5);
        end
        endtask

    task testcase007;

        begin
            reset_dut();

            L = 1;
            BusIn = 4'hB;
            @(posedge clk);
            #1;

            L = 0;
            D = 0;
            C = 0;
            repeat(2) @(posedge clk);
            #1;
            $display("Testcase 007: Hold value 4'hB");
            #1;

            check_outputs(4'hB);
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
        input [3:0] expected_BusOut;
        begin
            if (expected_BusOut === (expected_BusOut ^ BusOut ^ expected_BusOut)) begin
                $display("PASS");
                $display("  Outputs: BusOut=%h",
                         BusOut);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: BusOut=%h",
                         expected_BusOut);
                $display("  Got:      BusOut=%h",
                         BusOut);
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
        $dumpvars(0,BusIn, C, D, L, clk, BusOut);
    end

endmodule
